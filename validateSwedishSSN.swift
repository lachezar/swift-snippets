func isValidSSN(ssn: String) -> Bool {

    if (count(ssn) != 10) {
        return false
    }

    let regex = NSRegularExpression(pattern: "^\\d{10}$", options: nil, error: nil)!
    let digitsOnly = (regex.numberOfMatchesInString(ssn, options: nil, range: NSMakeRange(0, count(ssn))) > 0)

    if (!digitsOnly) {
        return false
    }

    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyMMdd"
    let datePart = ssn.substringToIndex(advance(ssn.startIndex, 6))
    let isValidDate = (dateFormatter.dateFromString(datePart) != nil)

    if (!isValidDate) {
        return false
    }

    let digits = map(ssn) { String($0) }

    let sum = reduce(0..<9, 0) {
        let product = digits[$1].toInt()! * (($1+1) % 2 + 1)
        return $0 + product / 10 + product % 10
    }

    let isValidChecksum = ((10 - sum % 10) % 10 == digits.last!.toInt())

    return isValidChecksum
}


assert(isValidSSN("1212231235"))

