//
//  SecondaryButton.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import Foundation
import UIKit

class SecondaryButton: UIButton {
    init(title: String,isHidden:Bool) {
        super.init(frame: .zero)
        configure(title: title,isHidden:isHidden)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(title: "건너뛰기",isHidden: false)
    }
    
    private func configure(title: String,isHidden:Bool) {
        setTitle(title, for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.cornerRadius = 10
        self.isHidden = isHidden
    }
    // 터치 시작 시 (살짝 축소)
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches, with: event)
           UIView.animate(withDuration: 0.1) {
               self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
           }
       }
       
       // 터치 끝/취소 시 (원래 크기로 복원)
       override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesEnded(touches, with: event)
           UIView.animate(withDuration: 0.1) {
               self.transform = .identity
           }
       }
       
       override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesCancelled(touches, with: event)
           UIView.animate(withDuration: 0.1) {
               self.transform = .identity
           }
       }
}

