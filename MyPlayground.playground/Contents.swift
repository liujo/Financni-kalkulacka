import UIKit

//MARK: - replacing occurences of string
//let urokCarka = str.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
let carka = str.replacingOccurrences(of: ",", with: ".")

//MARK: - should
func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    var result = true
    let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
    
    if textField.tag == 3 || textField.tag == 5 {
        
        if string.characters.count > 0 {
            
            var disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789.,").invertedSet
            var resultingStringLengthIsLegal = Bool()
            
            if textField.tag == 3 {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 2
                
            } else {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 1
                disallowedCharacterSet = NSCharacterSet(charactersInString: "01234").invertedSet
            }
            
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            
            let scanner:NSScanner = NSScanner.localizedScannerWithString(prospectiveText) as! NSScanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
    }
    
    return result
    
}
