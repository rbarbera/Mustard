//
//  CustomTokenTests.swift
//  Mustard
//
//  Created by Mathew Sanders on 12/30/16.
//  Copyright © 2016 Mathew Sanders. All rights reserved.
//

import XCTest
import Mustard

struct NumberToken: TokenType {
    
    static private let numberCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
    
    // number token can include any character in 0...9 + '.'
    func canInclude(scalar: UnicodeScalar) -> Bool {
        return NumberToken.numberCharacters.contains(scalar)
    }
    
    // numbers must start with character 0...9
    func isRequiredToStart(with scalar: UnicodeScalar) -> Bool? {
        return CharacterSet.decimalDigits.contains(scalar)
    }
}

struct WordToken: TokenType {
    
    // word token can include any character in a...z + A...Z
    func canInclude(scalar: UnicodeScalar) -> Bool {
        return CharacterSet.letters.contains(scalar)
    }
}

struct SpecialFormatToken: TokenType {
    
    private let internalCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
    
    // can include any numbers, letters, and - character
    func canInclude(scalar: UnicodeScalar) -> Bool {
        return internalCharacters.contains(scalar)
    }
    
    // must start with # 
    func isRequiredToStart(with scalar: UnicodeScalar) -> Bool? {
        return CharacterSet(charactersIn: "#").contains(scalar)
    }
}

class CustomTokenTests: XCTestCase {
    
    func testSpecialFormat() {
        
        let tokens = "Serial: #YF-1942-B 12/01/27 (Scanned)".tokens(from: SpecialFormatToken.tokenizer)
        
        XCTAssert(tokens.count == 1, "Unexpected number of tokens [\(tokens.count)]")
        
        XCTAssert(tokens[0].tokenType is SpecialFormatToken)
        XCTAssert(tokens[0].text == "#YF-1942-B")
        
    }
    
    func testNumberToken() {
        
        let tokens = "123Hello world&^45.67".tokens(from: NumberToken.tokenizer, WordToken.tokenizer)
        
        XCTAssert(tokens.count == 4, "Unexpected number of tokens [\(tokens.count)]")
        
        XCTAssert(tokens[0].tokenType is NumberToken)
        XCTAssert(tokens[0].text == "123")
        
        XCTAssert(tokens[1].tokenType is WordToken)
        XCTAssert(tokens[1].text == "Hello")
        
        XCTAssert(tokens[2].tokenType is WordToken)
        XCTAssert(tokens[2].text == "world")
        
        XCTAssert(tokens[3].tokenType is NumberToken)
        XCTAssert(tokens[3].text == "45.67")
    }
}
