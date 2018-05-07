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
    
    func drawText(textToDraw: String, inFrame frameRect: CGRect) {
        
        let stringRef: CFStringRef = textToDraw
        
        // prepare the text using a core text framesetter
        let currentText : CFAttributedStringRef = CFAttributedStringCreate(nil, stringRef, nil)
        let framesetter : CTFramesetterRef = CTFramesetterCreateWithAttributedString(currentText)
        
        let framePath = CGPathCreateMutable()
        CGPathAddRect(framePath, nil, frameRect)
        
        let currentRange = CFRangeMake(0, 0)
        let frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
        
        let currentContext = UIGraphicsGetCurrentContext()
        
        CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity)
        
        CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2)
        CGContextScaleCTM(currentContext, 1.0, -1.0)
        
        CTFrameDraw(frameRef, currentContext!)
        
        CGContextScaleCTM(currentContext, 1.0, -1.0)
        CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2)
        
    }
    
    func drawImage(imageToDraw: UIImage, inRect rect: CGRect) {
        
        imageToDraw.drawInRect(rect)
    }
    
    func drawPDF(fileName: String) {
        
        UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil)
        
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
        
        self.drawLabels()
        
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
        
        let img = UIImage(named: "text")
        let frame = CGRectMake(0, 0, 612, 792)
        self.drawImage(img!, inRect: frame)
        
        UIGraphicsEndPDFContext()
    }
    
    func drawLabels() {
        
        let objects = NSBundle.mainBundle().loadNibNamed("pdf1", owner: nil, options: nil)
        let mainView = objects[0] as! UIView
        
        for view in mainView.subviews {
            
            if view.isKindOfClass(UILabel) {
                
                let label : UILabel = view as! UILabel
                
                if label.tag == 14 {
                    
                    label.text = "Hokej"
                }
                
                self.drawText(label.text!, inFrame: label.frame)
                
            }
            
        }
    }
    
    

}
