//
//  PDFRendering.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 05.03.16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit
import CoreText

class PDFRendering: NSObject {
    
    let rect = CGRect(x: 0, y: 0, width: 612, height: 792)
    
    func drawText(textToDraw: String, inFrame frameRect: CGRect) {
        
        let stringRef: CFString = textToDraw as CFString
        
        // prepare the text using a core text framesetter
        let currentText : CFAttributedString = CFAttributedStringCreate(nil, stringRef, nil)
        let framesetter : CTFramesetter = CTFramesetterCreateWithAttributedString(currentText)
        
        let framePath = CGMutablePath()
        framePath.addRect(frameRect)
        
        let currentRange = CFRangeMake(0, 0)
        let frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else { return }
        
        currentContext.textMatrix = CGAffineTransform.identity
        currentContext.translateBy(x: 0, y: frameRect.origin.y*2)
        currentContext.scaleBy(x: 1.0, y: -1.0)
        
        CTFrameDraw(frameRef, currentContext)
        
        currentContext.scaleBy(x: 1.0, y: -1.0)
        currentContext.translateBy(x: 0, y: (-1)*frameRect.origin.y*2)
    }
    
    func drawImage(imageToDraw: UIImage, inRect rect: CGRect) {
        
        imageToDraw.draw(in: rect)
    }
    
    func drawPDF(fileName: String) {
        
        UIGraphicsBeginPDFContextToFile(fileName, CGRect(), nil)
        
        UIGraphicsBeginPDFPageWithInfo(rect, nil)
        
        self.drawLabels()
        
        UIGraphicsBeginPDFPageWithInfo(rect, nil)
        
        let img = UIImage(named: "text")
        self.drawImage(imageToDraw: img!, inRect: rect)
        
        UIGraphicsEndPDFContext()
    }
    
    func drawLabels() {
        
        guard let objects = Bundle.main.loadNibNamed("pdf1", owner: nil, options: nil) else { return }
        let mainView = objects[0] as! UIView
        
        for view in mainView.subviews {
            
            if view.isKind(of: UILabel.self) {
                
                let label : UILabel = view as! UILabel
                
                if label.tag == 14 {
                    
                    label.text = "Hokej"
                }
                
                self.drawText(textToDraw: label.text!, inFrame: label.frame)
                
            }
            
        }
    }
    
    

}
