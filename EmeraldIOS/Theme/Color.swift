//
//  Color.swift
//  EmeraldIOS
//
//  Created by Genesis Sanguino on 5/3/19.
//  Copyright © 2019 Condor Labs. All rights reserved.
//

import UIKit

enum Color: String, Inspectable {
    case white
    case black
    case green
    case blue
    case red
    case yellow
    case gray
    case darkGray
    case extraDarkGray
    case lightGray
    case extraLightGray
    
    case primary
    case secondary
    case background
    case darkTint
    case lightTint
    case text
    case darkText
    case lightText
    case extraLightText
    case link
    case border
    case chevron
    case warning
    case success
    case error
    
    case mainNavigationTint
    case mainNavigationBarTint
    case skeletonBackground
    case progressCompleted
    case progressNotCompleted
    case elevatedViewPrimary
    case elevatedViewSecondary
    
    var IBInspectable: String {
        return rawValue
    }
    
    init(IBInspectable: String) {
        self.init(stringValue: IBInspectable)
    }
    
    var uiColor: UIColor {
        switch self {
        case .white:
            return EmeraldTheme.whiteColor
        case .black:
            return EmeraldTheme.blackColor
        case .green:
            return EmeraldTheme.greenColor
        case .blue:
            return EmeraldTheme.blueColor
        case .red:
            return EmeraldTheme.redColor
        case .yellow:
            return EmeraldTheme.yellowColor
        case .gray:
            return EmeraldTheme.grayColor
        case .darkGray:
            return EmeraldTheme.darkGrayColor
        case .extraDarkGray:
            return EmeraldTheme.extraDarkGrayColor
        case .lightGray:
            return EmeraldTheme.lightGrayColor
        case .extraLightGray:
            return EmeraldTheme.extraLightGrayColor
        case .primary:
            return EmeraldTheme.primaryColor
        case .secondary:
            return EmeraldTheme.secondaryColor
        case .background:
            return EmeraldTheme.backgroundColor
        case .darkTint:
            return EmeraldTheme.darkTintColor
        case .lightTint:
            return EmeraldTheme.lightTintColor
        case .text:
            return EmeraldTheme.textColor
        case .darkText:
            return EmeraldTheme.darkTextColor
        case .lightText:
            return EmeraldTheme.lightTextColor
        case .extraLightText:
            return EmeraldTheme.extraLightTextColor
        case .link:
            return EmeraldTheme.linkColor
        case .border:
            return EmeraldTheme.borderColor
        case .chevron:
            return EmeraldTheme.chevronColor
        case .warning:
            return EmeraldTheme.warningColor
        case .success:
            return EmeraldTheme.successColor
        case .error:
            return EmeraldTheme.errorColor
        case .mainNavigationTint:
            return EmeraldTheme.mainNavigationTintColor
        case .mainNavigationBarTint:
            return EmeraldTheme.mainNavigationBarTintColor
        case .skeletonBackground:
            return EmeraldTheme.skeletonBackgroundColor
        case .progressCompleted:
            return EmeraldTheme.progressCompletedColor
        case .progressNotCompleted:
            return EmeraldTheme.progressNotCompletedColor
        case .elevatedViewPrimary:
            return EmeraldTheme.elevatedViewPrimaryColor
        case .elevatedViewSecondary:
            return EmeraldTheme.elevatedViewSecondaryColor
            
        }
    }
    
    static func uiColor(_ IBInspectable: InspectableType) -> UIColor {
        return Color(IBInspectable: IBInspectable).uiColor
    }
    
    var cgColor: CGColor {
        return uiColor.cgColor
    }
    
    static func cgColor(_ IBInspectable: InspectableType) -> CGColor {
        return Color(IBInspectable: IBInspectable).cgColor
    }
}
