//
//  EmeraldSelectorFormFieldError.swift
//  EmeraldIOS
//
//  Created by Genesis Sanguino on 5/13/19.
//  Copyright © 2019 Condor Labs. All rights reserved.
//

public enum EmeraldSelectorFormFieldError: FormFieldErrorType, Error {
    case missingSelectedValue
    case uiSelectedValueMismatch
}

public extension EmeraldSelectorFormFieldError {
    var description: String? {
        switch self {
        case .missingSelectedValue:
            return "Missing selected value."
        case .uiSelectedValueMismatch:
            return "The text showed in UI does not match any selectable."
        }
    }
}
