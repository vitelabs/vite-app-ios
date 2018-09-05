//
//  Ed25519.swift
//  libEd25519Blake2b
//
//  Created by Stone on 2018/9/3.
//

import Foundation

public struct Ed25519 {

    public static let secretKeyLength = 32;
    public static let publicKeyLength = 32;
    public static let signatureLength = 64;

    public static func generateKeypair() -> (secretKey: Bytes, publicKey: Bytes) {
        let s = randombytesUnsafe(length: secretKeyLength)
        let p = publicKey(secretKey: s)
        return (s, p)
    }

    public static func randombytesUnsafe(length: Int) -> Bytes {
        var numbers = Bytes(count: length);
        ed25519_randombytes_unsafe(&numbers, length);
        return numbers
    }

    public static func publicKey(secretKey: Bytes) -> Bytes {
        var publickey = Bytes(count: publicKeyLength);
        ed25519_publickey(secretKey, &publickey);
        return publickey;
    }

    public static func sign(message: Bytes, secretKey: Bytes, publicKey: Bytes) -> Bytes {
        var signature = Bytes(count: signatureLength)
        ed25519_sign(message, Int(message.count), secretKey, publicKey, &signature)
        return signature;
    }

    public static func signOpen(message: Bytes, publicKey: Bytes, signature: Bytes) -> Bool {
        return ed25519_sign_open(message, Int(message.count), publicKey, signature) == 0
    }

}
