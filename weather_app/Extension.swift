//
//  Extension.swift
//  weather_app
//
//  Created by Марина on 24.08.2023.
//

import Foundation
import UIKit
extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
//        self.distribution = 
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach{ self.addArrangedSubview($0) }
    }
}
