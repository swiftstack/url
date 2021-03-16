import Stream

extension URL {
    public func encode(
        _ key: PartialKeyPath<URL>,
        to stream: StreamWriter
    ) async throws {
        switch key {
        case \URL.path:
            let escaped = URL.encode(path, allowedCharacters: .pathAllowed)
            try await stream.write(escaped)
        case \URL.query:
            if let query = self.query, query.values.count > 0 {
                try await stream.write(.questionMark)
                try await query.encode(to: stream)
            }
        default:
            fatalError("unimplemented")
        }
    }
}

extension URL.Query {
    // FIXME: remove
    // FIXME: [Concurrency]
    public func encode() -> [UInt8] {
        var result = [UInt8]()

        var isFirst = true
        for (key, value) in values {
            switch isFirst {
            case true: isFirst = false
            case false: result.append(.ampersand)
            }
            result.append(contentsOf: URL.encode(key, allowedCharacters: .queryPartAllowed))
            result.append(.equal)
            result.append(contentsOf: URL.encode(value, allowedCharacters: .queryPartAllowed))
        }

        return result
    }

    public func encode(to stream: StreamWriter) async throws {
        var isFirst = true
        for (key, value) in values {
            switch isFirst {
            case true: isFirst = false
            case false: try await stream.write(.ampersand)
            }

            try await stream.write(URL.encode(key, allowedCharacters: .queryPartAllowed))
            try await stream.write(.equal)
            try await stream.write(URL.encode(value, allowedCharacters: .queryPartAllowed))
        }
    }
}

extension URL.Host {
    public func encode(to stream: StreamWriter) async throws {
        try await stream.write(Punycode.encode(domain: address))
        try await _encodePort(to: stream)
    }

    // FIXME: [Concurrency] build crash
    private func _encodePort(to stream: StreamWriter) async throws {
        if let port = port {
            try await stream.write(.colon)
            try await stream.write("\(port)")
        }
    }
}
