//
//  SecondIntroductionViewController.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import Foundation
import UIKit
import SnapKit

class SecondIntroductionViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "2"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .center

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

