//
//  Selectable.swift
//  EmeraldIOS
//
//  Created by Luis David Goyes Garces on 3/6/19.
//  Copyright © 2019 Condor Labs. All rights reserved.
//

public protocol Selectable: class {
    func getSelectableText() -> String
}

public class MultipleSelectionGroupItem: Selectable {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    public func getSelectableText() -> String {
        return title
    }
}
