// MARK: ASCII

typealias ASCII = [UInt8]
extension Array where Element == UInt8 {
    init(_ value: String) {
        self = [UInt8](value.utf8)
    }
}

