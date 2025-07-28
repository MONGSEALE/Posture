//
//  GradientColor.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import Foundation
import UIKit

final class BackgroundGradient {
    
    static func onboardingGradientLayer(frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.2).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.1).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = frame
        return gradientLayer
    }
    
}
