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
            // 기존 사용자 → 바로 그리기 화면
            let VC = DrawingViewController()
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: false)
        } else {
            // 신규 사용자 → 온보딩 화면
            let VC = IntroductionViewController()
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: false)
        }
    }
}

#Preview{
    SplashViewController()
}
