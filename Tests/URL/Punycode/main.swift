import Test
import URL

test("Encode") {
    let encoded = Punycode.encode(domain: "привет.рф")
    expect(encoded == "xn--b1agh1afp.xn--p1ai")
}

test("Decode") {
    let decoded = Punycode.decode(domain: "xn--b1agh1afp.xn--p1ai")
    expect(decoded == "привет.рф")
}

test("EncodeMixedCase") {
    let encoded = Punycode.encode(domain: "Привет.рф")
    expect(encoded == "xn--r0a2bjk3bp.xn--p1ai")
}

test("DecodeMixedCase") {
    let decoded = Punycode.decode(domain: "xn--r0a2bjk3bp.xn--p1ai")
    expect(decoded == "Привет.рф")
}

test("EncodeMixedASCII") {
    let encoded = Punycode.encode(domain: "hello-мир.рф")
    expect(encoded == "xn--hello--upf5a1b.xn--p1ai")
}

test("DecodeMixedASCII") {
    let decoded = Punycode.decode(domain: "xn--hello--upf5a1b.xn--p1ai")
    expect(decoded == "hello-мир.рф")
}

await run()
