import Foundation

func randomAlphanumericString(length: Int) -> String {

    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let lettersLength = UInt32(count(letters))

    var result = ""

    for (var i = 0; i < length; i++) {
        let randomIndex = Int(arc4random_uniform(lettersLength))
        let c = letters[advance(letters.startIndex, randomIndex)]
        result.append(c)
    }

    return result
}

assert(randomAlphanumericString(10) != randomAlphanumericString(10))
assert(count(randomAlphanumericString(10)) == 10)

