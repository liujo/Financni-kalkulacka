import UIKit

extension Int {
    
    func currencyFormattingWithSymbol(currencySymbol: String) -> String {
        
        let customFormatter = NSNumberFormatter()
        
        customFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        customFormatter.locale = NSLocale.init(localeIdentifier: "cs")
        customFormatter.currencySymbol = currencySymbol
        customFormatter.maximumFractionDigits = 0
        
        return customFormatter.stringFromNumber(self)!
        
    }
}

1000.currencyFormattingWithSymbol("Kč")