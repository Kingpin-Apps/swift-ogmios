import Testing
@testable import SwiftOgmios

@Test func testBlockEBBCreation() throws {
    let ebb = Block.EBB(
        id: try DigestBlake2b256("abcd1234567890abcd1234567890abcd1234567890abcd1234567890abcd1234"),
        ancestor: try DigestBlake2b256("1234567890abcd1234567890abcd1234567890abcd1234567890abcd12345678"),
        height: 12345
    )
    
    #expect(ebb.type == "ebb")
    #expect(ebb.era == "byron")
    #expect(ebb.height == 12345)
}

@Test func testBlockBFTCreation() throws {
    let bftProtocol = Block.BFT.BFTProtocol(
        id: 764824073,
        version: ProtocolVersion(major: 1, minor: 0),
        software: SoftwareVersion(appName: "cardano-sl", number: 1)
    )
    
    let issuer = Block.BFT.BFTIssuer(verificationKey: "test-verification-key-issuer")
    let delegate = Block.BFT.BFTDelegate(verificationKey: "test-verification-key-delegate")
    
    let bft = Block.BFT(
        id: try DigestBlake2b256("abcd1234567890abcd1234567890abcd1234567890abcd1234567890abcd1234"),
        ancestor: try DigestBlake2b256("1234567890abcd1234567890abcd1234567890abcd1234567890abcd12345678"),
        height: 12345,
        slot: 54321,
        size: NumberOfBytes(bytes: 1024),
        protocol: bftProtocol,
        issuer: issuer,
        delegate: delegate
    )
    
    #expect(bft.type == "bft")
    #expect(bft.era == "byron")
    #expect(bft.height == 12345)
    #expect(bft.slot == 54321)
}

@Test func testBlockPraosCreation() throws {
    let praosProtocol = Block.Praos.PraosProtocol(
        version: ProtocolVersion(major: 2, minor: 0)
    )
    
    let operationalCert = OperationalCertificate(
        count: 1,
        sigma: "test-sigma",
        kes: OperationalCertificate.KesInfo(period: 123, verificationKey: "test-kes-key")
    )
    
    let issuer = Block.Praos.PraosIssuer(
        verificationKey: try VerificationKey("1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"),
        vrfVerificationKey: try VerificationKey("abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890"),
        operationalCertificate: operationalCert,
        leaderValue: CertifiedVrf(output: "test-output", proof: "test-proof")
    )
    
    let praos = Block.Praos(
        era: .shelley,
        id: try DigestBlake2b256("abcd1234567890abcd1234567890abcd1234567890abcd1234567890abcd1234"),
        ancestor: .hash(try DigestBlake2b256("1234567890abcd1234567890abcd1234567890abcd1234567890abcd12345678")),
        height: 12345,
        size: NumberOfBytes(bytes: 2048),
        slot: 98765,
        protocol: praosProtocol,
        issuer: issuer
    )
    
    #expect(praos.type == "praos")
    #expect(praos.era == .shelley)
    #expect(praos.height == 12345)
    #expect(praos.slot == 98765)
}

@Test func testPraosAncestorGenesis() throws {
    let ancestor: Block.Praos.PraosAncestor = .genesis
    
    // Test encoding to JSON-like structure
    let jsonData = try ancestor.toJSONData()
    let jsonString = String(data: jsonData, encoding: .utf8)
    
    #expect(jsonString == "\"genesis\"")
}

@Test func testPraosAncestorHash() throws {
    let hash = try DigestBlake2b256("1234567890abcd1234567890abcd1234567890abcd1234567890abcd12345678")
    let ancestor: Block.Praos.PraosAncestor = .hash(hash)
    
    // Test encoding to JSON-like structure 
    let jsonData = try ancestor.toJSONData()
    let jsonString = String(data: jsonData, encoding: .utf8)
    
    #expect(jsonString?.contains("1234567890abcd1234567890abcd1234567890abcd12345678") == true)
}
