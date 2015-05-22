class Debouncer {
    
    var time: Double
    var delay: Double
    
    init(delay: Double) {
        self.delay = delay
        self.time = 0.0
    }
    
    func call(block: () -> ()) {
        let ts = timestamp()
        
        if (time + delay < ts) {
            time = ts
            block()
        }
    }
    
    internal func timestamp() -> Double {
        return NSDate().timeIntervalSince1970 * 1000
    }
    
}

let instance = Debouncer(delay: 250)
var counter = 0

for i in 1...100 {
    instance.call() {
		// the closure will be executed at most once every 250ms
        counter++
    }
}

assert(counter == 1)
