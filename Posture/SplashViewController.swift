//
//  SplashViewControl.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import Foundation
import UIKit
import SnapKit


class SplashViewController : UIViewController{
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        // 붓 아이콘
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .light)
        imageView.image = UIImage(systemName: "paintbrush.fill", withConfiguration: config)
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints{make in
            make.center.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.navigateToNextScreen()
        }
    }
    
    private func navigateToNextScreen() {
        // UserDefaults로 온보딩 완료 여부 확인
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if hasCompletedOnboarding {
            
            if UIDevice.current.isiPhone {
                let VC = DrawingViewController_iPhone()
                VC.modalPresentationStyle = .fullScreen
                self.present(VC, animated: false)
            }
            else{
                let VC = DrawingViewController_iPad()
                VC.modalPresentationStyle = .fullScreen
                self.present(VC, animated: false)
            }
            
           
        } else {
           
            if UIDevice.current.isiPhone {
                let VC = IntroductionViewController_iPhone()
                VC.modalPresentationStyle = .fullScreen
                self.present(VC, animated: false)
            }
            else{
                let VC = IntroductionViewController_iPad()
                VC.modalPresentationStyle = .fullScreen
                self.present(VC, animated: false)
            }
        }
    }
}

#Preview{
    SplashViewController()
}

extension UIDevice {
    var isiPad: Bool {
        return userInterfaceIdiom == .pad
    }
    
    var isiPhone: Bool {
        return userInterfaceIdiom == .phone
    }
}
