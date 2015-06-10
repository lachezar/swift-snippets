// the emoji swaperoo operator

infix operator ♻️  { }
func ♻️  <T>(inout left: T, inout right: T) {
    var tmp = left
	left = right
	right = tmp
}

var a = 3
var b = 2
a ♻️  b

assert(a == 2 && b == 3)

var s1 = "world"
var s2 = "hello"
s1 ♻️  s2

assert(s1 == "hello" && s2 == "world")

