//
//  ViewController.swift
//  HW3_Reference
//
//  Created by Владимир Мацнев on 21.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let gradientView = GradientView(colors: [AppColor.firstBackgroundColor, AppColor.secondBackgroundColor], duration: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup Layouts

private extension ViewController {
    func setup() {
        setupGradualView()
    }
    
    func setupGradualView() {
        view.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientView.heightAnchor.constraint(equalTo: view.heightAnchor),
            gradientView.widthAnchor.constraint(equalTo: view.widthAnchor),
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

