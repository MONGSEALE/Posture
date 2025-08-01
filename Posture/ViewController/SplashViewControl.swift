//
//  SplashViewControl.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import Foundation
import UIKit
import SnapKit


class SplashViewControl : UIViewController{
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Posture"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        view.addSubview(label)
        label.snp.makeConstraints{make in
            make.center.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self,
                  let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            let request = User.fetchRequest()
            //User 엔티티가 존재하는지 여부
            if let users = try? context.fetch(request), !users.isEmpty {
                    let VC = MainViewController()
                    VC.modalPresentationStyle = .fullScreen
                self.present(VC, animated: false)
            } else {
                let VC = IntroductionViewController()
                VC.modalPresentationStyle = .fullScreen
                self.present(VC, animated: false)
            }
        }
    }
    
}

#Preview{
    SplashViewControl()
}
