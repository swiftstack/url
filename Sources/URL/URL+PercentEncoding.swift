let hexchars: [UInt8] = [
    .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine,
    .A, .B, .C, .D, .E, .F
]

extension URL {
    static func encode(
        _ string: String,
        allowedCharacters: Set<UInt8>
    ) -> [UInt8] {
        guard !string.isEmpty else {
            return []
        }
        var string = string
        return string.withUTF8 { buffer in
            return encode(buffer, allowedCharacters: allowedCharacters)
        }
    }

    // TODO: Handle special cases & Opmtimize using ascii table
    static func encode(
        _ bytes: UnsafeBufferPointer<UInt8>,
        allowedCharacters: Set<UInt8>
    ) -> [UInt8] {
        var result = [UInt8]()
        for byte in bytes {
            if allowedCharacters.contains(byte) {
                result.append(byte)
            } else {
                result.append(.percent)
                result.append(hexchars[Int(byte >> 4)])
                result.append(hexchars[Int(byte & 0x0f)])
            }
        }
        return result
    }
}

extension URL {
    static func decode<T: StringProtocol>(
        _ string: T
    ) throws -> String {
        let encoded = try decode([UInt8](string.utf8))
        return String(decoding: encoded, as: UTF8.self)
    }

    static func decode<T: RandomAccessCollection>(
        _ bytes: T
    ) throws -> [UInt8] where T.Element == UInt8, T.Index == Int {
        var result = [UInt8]()
        result.reserveCapacity(bytes.count)

        var index = bytes.startIndex
        while index < bytes.endIndex {
            guard bytes[index] == .percent else {
                result.append(bytes[index])
                index += 1
                continue
            }
            guard index + 3 <= bytes.endIndex else {
                throw URL.Error.invalidPath
            }
            let hex1 = hexTable[Int(bytes[index + 1])]
            let hex2 = hexTable[Int(bytes[index + 2])]
            guard (hex1 | hex2) & 0x80 == 0 else {
                throw URL.Error.invalidPath
            }
            result.append((hex1 << 4) + hex2)
            index += 3
        }

        return result
    }
}

private let hexTable: [UInt8] = [
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,

    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
]
