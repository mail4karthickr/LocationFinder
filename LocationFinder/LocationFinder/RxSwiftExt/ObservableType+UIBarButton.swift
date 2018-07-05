//
//  ObservableType+UIBarButton.swift
//  LocationFinder
//
//  Created by karthick on 7/4/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// New rx property for hiding and showing the save or delete button.
extension Reactive where Base: UIBarButtonItem {
    var hidden: Binder<Bool> {
        return Binder(self.base) { barButtonItem, val in
            if val {
                barButtonItem.isEnabled = false
                barButtonItem.tintColor = .clear
            } else {
                barButtonItem.isEnabled = true
                barButtonItem.tintColor = UIColor(displayP3Red: 0/255.0, green: 111/255.0, blue: 255/255.0, alpha: 1.0)
            }
        }
    }
}
