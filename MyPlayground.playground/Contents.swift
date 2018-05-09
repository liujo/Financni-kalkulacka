import UIKit

//MARK: - replacing occurences of string
//let urokCarka = str.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
//let carka = str.replacingOccurrences(of: ",", with: ".")

var str = "slovo123456"
let count = 3
let index = str.index(str.endIndex, offsetBy: -count)
let substring = str[..<index]
print(String(substring))

//return self.substringToIndex(self.endIndex.advancedBy(-count))






