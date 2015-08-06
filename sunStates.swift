import Foundation

func toRadians(angleInDegrees: Double) -> Double {
    return angleInDegrees * M_PI / 180.0
}

func toDegrees(angleInRadians: Double) -> Double {
    return angleInRadians * 180.0 / M_PI
}

func sindeg(x: Double) -> Double {
    return sin(toRadians(x))
}

func cosdeg(x: Double) -> Double {
    return cos(toRadians(x))
}

func tandeg(x: Double) -> Double {
    return tan(toRadians(x))
}

func asindeg(x: Double) -> Double {
    return toDegrees(asin(x))
}

func acosdeg(x: Double) -> Double {
    return toDegrees(acos(x))
}

func calculateSolarStates(long: Double, lat: Double, date: NSDate, tz: NSTimeZone = NSTimeZone.localTimeZone()) -> (sunrise: NSDate?, solarnoon: NSDate?, sunset: NSDate?) {

    // Ported from: http://michelanders.blogspot.ru/2010/12/calulating-sunrise-and-sunset-in-python.html
    // More info: https://en.wikipedia.org/wiki/Sunrise_equation

    let timezoneHoursDelta: Double = Double(tz.secondsFromGMT / 3600)

    let formatter = NSDateFormatter()
    formatter.dateFormat = "g"
    let jdate = (formatter.stringFromDate(date) as NSString).doubleValue // it is not super accurate, but it should be good enough
    let jcent = (jdate - 2451545) / 36525

    let MAnom = 357.52911 + jcent * (35999.05029 - 0.0001537 * jcent)
    let MLong = 280.46646 + jcent * (36000.76983 + jcent * 0.0003032) % 360
    let EcCent = 0.016708634 - jcent * (0.000042037 + 0.0001537 * jcent)
    let MObliq = 23 + (26 + ((21.448 - jcent * (46.815 + jcent * (0.00059 - jcent * 0.001813)))) / 60) / 60

    let obliq  = MObliq + 0.00256 * cosdeg(125.04 - 1934.136 * jcent)
    let vary   = tandeg(obliq / 2) * tandeg(obliq / 2)

    let SeqCent = sindeg(MAnom) * (1.914602 - jcent * (0.004817 + 0.000014 * jcent)) + sindeg(2 * MAnom) * (0.019993 - 0.000101 * jcent) + sindeg(3 * MAnom) * 0.000289
    let StrueLong = MLong + SeqCent
    let SappLong  = StrueLong - 0.00569 - 0.00478 * sindeg(125.04 - 1934.136 * jcent)
    let SolarDeclination = asindeg( sindeg(obliq) * sindeg(SappLong) )

    let EqTime  = 4 * toDegrees( vary * sindeg(2 * MLong) - 2 * EcCent * sindeg(MAnom) + 4 * EcCent * vary * sindeg(MAnom) * cosdeg(2 * MLong) - 0.5 * vary * vary * sindeg(4 * MLong) - 1.25 * EcCent * EcCent * sindeg(2 * MAnom))

    let HourAngle = acosdeg( cosdeg(90.833) / (cosdeg(lat) * cosdeg(SolarDeclination)) - tandeg(lat) * tandeg(SolarDeclination))

    let solarnoon: Double = (720 - 4 * long - EqTime + Double(timezoneHoursDelta) * 60) / 1440
    let sunrise: Double   = solarnoon - HourAngle * 4 / 1440
    let sunset: Double    = solarnoon + HourAngle * 4 / 1440

    if (sunrise.isNormal && solarnoon.isNormal && sunset.isNormal) {

        let midnight = date.dateByAddingTimeInterval(-date.timeIntervalSince1970 % (24 * 60 * 60))

        let sunriseDate = midnight.dateByAddingTimeInterval(sunrise * 24 * 60 * 60)
        let solarnoonDate = midnight.dateByAddingTimeInterval(solarnoon * 24 * 60 * 60)
        let sunsetDate = midnight.dateByAddingTimeInterval(sunset * 24 * 60 * 60)

        return (sunrise: sunriseDate, solarnoon: solarnoonDate, sunset: sunsetDate)
    }
    
    return (sunrise: nil, solarnoon: nil, sunset: nil)
}


let (sunrise, solarnoon, sunset) = calculateSolarStates(17.990292, 59.320362, NSDate(timeIntervalSince1970: 1438877028), tz: NSTimeZone(abbreviation: "CEST")!)

assert(abs(sunrise!.timeIntervalSince1970 - 1438836300) < 600, "Stockholm sunrise at 6th of August 2015 - 4:45am")

assert(abs(sunset!.timeIntervalSince1970 - 1438895340) < 600, "Stockholm sunset at 6th of August 2015 - 21:09pm")

