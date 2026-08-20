//
//  NetworkManager.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// Generic HTTP transport for the app — encodes a request body and decodes a response,
/// knowing nothing about the health-check domain. `HealthCheckRepository` is the only thing
/// that calls this directly (see `NETWORKING.md`).
protocol NetworkManaging {
    /// Sends a request to `endpoint` and decodes its response as `Response`.
    ///
    /// - Parameters:
    ///   - endpoint: The full URL to send the request to.
    ///   - method: The HTTP method to send it with.
    ///   - parameters: Encoded as the request body (or, for `.get`, as query items). `nil`
    ///     sends neither.
    ///
    /// Usage: `let session: HealthCheckSessionDTO = try await networkManager.request(endpoint:
    /// url, method: .post, parameters: nil)` — `Response` is inferred from the caller's own
    /// declared return type, never passed explicitly.
    func request<Response: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: Encodable?
    ) async throws -> Response
}

/// See `NetworkManaging`. Every throw site here surfaces a `NetworkError` — callers never
/// need to catch anything else. The API's JSON is already `camelCase` (`sessionId`,
/// `questionId`, ...), matching Swift's own naming, so `encoder`/`decoder` use the default
/// key strategy — no conversion needed.
final class NetworkManager: NetworkManaging {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func request<Response: Decodable>(
        endpoint: String,
        method: HTTPMethod = .post,
        parameters: Encodable? = nil
    ) async throws -> Response {
        let (data, response) = try await performRequest(endpoint: endpoint, method: method, parameters: parameters)
        try validate(response, data: data)

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    /// Builds the `URLRequest` from `endpoint`/`method`/`parameters` and fires it — the one
    /// seam that knows `URLSession` exists. Swapping HTTP client or adding an authenticator
    /// (attach a header before firing) both happen here; nothing else needs to change either
    /// way.
    ///
    /// - Parameters:
    ///   - endpoint: The full URL to send the request to.
    ///   - method: The HTTP method to send it with.
    ///   - parameters: Encoded as the request body, unless `method` is `.get` — a `GET`
    ///     sends `parameters` as query items instead, never a body.
    private func performRequest(
        endpoint: String,
        method: HTTPMethod,
        parameters: Encodable?
    ) async throws -> (Data, URLResponse) {
        guard var components = URLComponents(string: endpoint) else {
            throw NetworkError.transport(URLError(.badURL))
        }

        if method == .get, let parameters {
            components.queryItems = try queryItems(from: parameters)
        }

        guard let url = components.url else {
            throw NetworkError.transport(URLError(.badURL))
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if method != .get, let parameters {
            urlRequest.httpBody = try encoder.encode(parameters)
        }

        do {
            return try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw NetworkError.transport(error)
        }
    }

    /// Encodes `parameters` and converts it into `URLQueryItem`s, for `.get` requests, which
    /// send their parameters in the URL rather than a body.
    ///
    /// - Parameter parameters: The value to encode as query items.
    private func queryItems(from parameters: Encodable) throws -> [URLQueryItem] {
        let data = try encoder.encode(parameters)
        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return []
        }
        return dictionary.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }

    /// Throws a `NetworkError` unless `response` is an `HTTPURLResponse` with a 2xx status.
    ///
    /// - Parameters:
    ///   - response: The `URLResponse` `performRequest` returned.
    ///   - data: The body alongside it — decoded as an `APIErrorDTO` when the status isn't
    ///     2xx, to build a specific `NetworkError` case instead of a generic one.
    private func validate(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard !(200...299).contains(httpResponse.statusCode) else {
            return
        }

        let apiError = try? decoder.decode(APIErrorDTO.self, from: data)
        throw mapError(statusCode: httpResponse.statusCode, apiError: apiError)
    }

    /// Maps a non-2xx status code, plus whatever `APIErrorDTO` (if any) came with it, to a
    /// specific `NetworkError` case. `429`/`405` are matched on status alone; every other
    /// status needs `apiError?.code` to disambiguate (`400` alone covers three cases).
    ///
    /// - Parameters:
    ///   - statusCode: The response's HTTP status code.
    ///   - apiError: The decoded error body, if `NetworkManager` could decode one.
    private func mapError(statusCode: Int, apiError: APIErrorDTO?) -> NetworkError {
        switch (statusCode, apiError?.code) {
        case (400, "INVALID_SESSION_ID"):
            return .invalidSessionId
        case (400, "INVALID_QUESTION"):
            return .invalidQuestion
        case (400, "QUESTION_NOT_FOUND"):
            return .questionNotFound
        case (404, "SESSION_NOT_FOUND"):
            return .sessionNotFound
        case (409, "SESSION_ALREADY_COMPLETED"):
            return .sessionAlreadyCompleted
        case (422, "VALIDATION_ERROR"):
            return .validationError(field: apiError?.field, message: apiError?.message)
        case (429, _):
            return .rateLimited
        case (405, _):
            return .methodNotAllowed
        default:
            return .unrecognizedServerError(statusCode: statusCode, code: apiError?.code, message: apiError?.message)
        }
    }
}
