//
//  KlarnaUiViewExtensions.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-10-06.
//

import UIKit

extension UIViewController {

    func embed(subview: UIView, toBottomAnchor bottomAnchor: NSLayoutYAxisAnchor) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(subview)
        self.view.sendSubviewToBack(subview)

        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),

            bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 8)
        ])
    }

}
