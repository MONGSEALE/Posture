//
//  ThirdIntroductionViewController.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import Foundation
import UIKit

class ThirdIntroductionViewController : UIViewController {
    
    override func viewDidLoad() {
          super.viewDidLoad()
         
          
          let label = UILabel()
          label.text = "3"
          label.font = .systemFont(ofSize: 40, weight: .bold)
          label.textAlignment = .center
          
          view.addSubview(label)
          label.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
          ])
      }
    
}
