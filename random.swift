import Foundation

func randomAlphanumericString(length: Int) -> String {

    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters
    let lettersLength = UInt32(letters.count)

    let randomCharacters = (0..<length).map { i -> String in
        let offset = Int(arc4random_uniform(lettersLength))
        let c = letters[letters.startIndex.advancedBy(offset)]
        return String(c)
    }

    return randomCharacters.joinWithSeparator("")
}

assert(randomAlphanumericString(10) != randomAlphanumericString(10))
assert(randomAlphanumericString(10).characters.count == 10)

