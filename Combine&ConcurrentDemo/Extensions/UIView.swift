//
//  View.swift
//  Combine&ConcurrentDemo
//
//  Created by alexander.ivanchenko on 14.02.2023.
//

import UIKit.UIView

// MARK: - Show hide animations in StackViews
extension UIView {
    func hideAnimated(in stackView: UIStackView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = true
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func showAnimated(in stackView: UIStackView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = false
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
}
