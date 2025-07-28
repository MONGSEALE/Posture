//
//  PrimaryButton.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import Foundation
import UIKit

class PrimaryButton : UIButton {
    
    init(title:String,isHidden:Bool){
        super.init(frame: .zero)
        configure(title: title,isHidden: isHidden )
    }
    
    required init?(coder:NSCoder){
        super.init(coder: coder)
        configure(title: "",isHidden: false)
    }
    
    private func configure(title: String ,isHidden: Bool){
        setTitle(title,for: .normal)
        setTitleColor(.white, for: .normal)
        self.backgroundColor = .systemBlue
        titleLabel?.font = .systemFont(ofSize: 18,weight: .semibold)
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.systemBlue.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
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
