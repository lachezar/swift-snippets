class CircularBuffer<T> {

    var buffer: [T]!
    var pointer: Int
    var size: Int {
        return buffer.count
    }

    init(size: Int, defaultElement: T) {
        buffer = Array<T>(count: max(size, 1), repeatedValue: defaultElement)
        pointer = -1
    }

    subscript(index: Int) -> T {
        get {
            return buffer[(pointer + index + 1) % buffer.count]
        }
    }

    func add(item: T) {
        pointer = (pointer + 1) % buffer.count
        buffer[pointer] = item
    }
}


var buffer = CircularBuffer<String>(size: 2, defaultElement: "")
buffer.add("hi")
buffer.add("hello")
buffer.add("world")
assert(buffer[0] == "hello")
assert(buffer[1] == "world")
assert(buffer[2] == "hello")
assert(buffer[3] == "world")

