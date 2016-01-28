import Foundation

class PersistentSetting<T>: CustomStringConvertible { // Int, Double, String, Bool and Anything?

    let defaults = NSUserDefaults.standardUserDefaults()

    var key: String!

    var description: String {
        return "\(key): \(get())"
    }

    init(key: String) {
        self.key = key
    }

    init(key: String, defaultValue: T) {
        self.key = key
        if (self.isUndefined) {
            set(defaultValue)
        }
    }

    private func get() -> T {
        if (T.self == Double.self) {
            return defaults.doubleForKey(key) as! T
        } else if (T.self == Int.self) {
            return defaults.integerForKey(key) as! T
        } else if (T.self == Bool.self) {
            return defaults.boolForKey(key) as! T
        } else if (T.self == String.self) {
            return defaults.stringForKey(key) as! T
        }

        return defaults.objectForKey(key) as! T
    }

    private func set(value: T) {
        if (T.self == Double.self) {
            defaults.setDouble(value as! Double, forKey: key)
        } else if (T.self == Int.self) {
            defaults.setInteger(value as! Int, forKey: key)
        } else if (T.self == Bool.self) {
            defaults.setBool(value as! Bool, forKey: key)
        } else if (T.self == String.self) {
            defaults.setObject(value as! String, forKey: key)
        } else {
            defaults.setObject(value as? AnyObject, forKey: key)
        }
    }

    var value: T {
        get {
            return get()
        }
        set {
            set(newValue)
        }
    }

    var isUndefined: Bool {
        return defaults.objectForKey(key) == nil
    }

    func erase() {
        defaults.removeObjectForKey(key)
    }

    deinit {
        defaults.synchronize()
    }
}

let settingA = PersistentSetting<Bool>(key: "a")
let settingB = PersistentSetting<String>(key: "b")
//settingA.value = "compile time error, it expects Bool type"
settingA.value = true
assert(settingA.value)
assert(settingB.isUndefined)
settingB.value = "xyz"
assert(settingB.value == "xyz")
assert(!settingB.isUndefined)
settingB.erase()
assert(settingB.isUndefined)

let settingC = PersistentSetting<Int>(key: "c", defaultValue: 42)
assert(settingC.value == 42)
