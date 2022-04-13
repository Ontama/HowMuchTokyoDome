//
//  UIScreen+Extension.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/04/13.
//

import UIKit

public extension UIScreen {
    static let _width = UIScreen.main.bounds.size.width
    class var width: CGFloat {
        return _width
    }
    
    static let _height = UIScreen.main.bounds.size.height
    class var height: CGFloat {
        return _height
    }
    
    static let _scale = UIScreen.main.scale
    class var scaleValue: CGFloat {
        return _scale
    }
    
    static let _size = UIScreen.main.bounds.size
    class var size: CGSize {
        return _size
    }
}
