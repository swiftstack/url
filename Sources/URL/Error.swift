extension URL {
    enum Error: Swift.Error {
        case invalidScheme
        case invalidHost
        case invalidPort
        case invalidPath
        case invalidQuery
    }
}
