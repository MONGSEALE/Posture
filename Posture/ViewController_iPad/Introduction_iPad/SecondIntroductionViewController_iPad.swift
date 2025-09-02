//
//  SecondIntroductionViewController.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import UIKit
import SnapKit

class SecondIntroductionViewController_iPad: UIViewController {
    
   
    private let scrollView = UIScrollView()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
  
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "자유로운 캔버스"
        label.font = UIFont.systemFont(ofSize: 72, weight: .bold)  // iPad에 맞게 폰트 크기 증가
        label.textColor = .black
        label.textAlignment = .center
        
        // 텍스트 그림자 효과
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.3
        label.layer.shadowRadius = 4
        
        return label
    }()
    
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "상상력을 마음껏 펼쳐보세요"
        label.font = UIFont.systemFont(ofSize: 40, weight: .medium)  // iPad에 맞게 폰트 크기 증가
        label.textColor = UIColor.black.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        
        // 텍스트 그림자
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.2
        label.layer.shadowRadius = 2
        
        return label
    }()
    
    // 이미지 컨테이너 뷰 (그림자와 둥근 모서리를 위한)
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 28  // iPad에 맞게 모서리 둥글기 증가
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 12)  // iPad에 맞게 그림자 증가
        view.layer.shadowOpacity = 0.15  // 그림자 투명도 약간 증가
        view.layer.shadowRadius = 24  // 그림자 반경 증가
        return view
    }()
    
    // UIImageView 프로퍼티
    private let introductionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "IntroductionImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 28  // iPad에 맞게 모서리 둥글기 증가
        return imageView
    }()
    
    // 설명 라벨
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text =  "붓, 펜슬, 색연필 등 다양한 도구로\n나만의 예술 작품을 만들어보세요"
        label.font = UIFont.systemFont(ofSize: 40, weight: .medium)  // iPad에 맞게 폰트 크기 증가
        label.textColor = UIColor.black.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        
        // 텍스트 그림자
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.2
        label.layer.shadowRadius = 2
        
        return label
    }()
    
    
    // 특징 스택뷰
    private let featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30  // iPad에 맞게 간격 증가
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        // 컨테이너 뷰 추가
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        // 서브뷰들 추가
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(imageContainerView)
        imageContainerView.addSubview(introductionImageView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(featuresStackView)
        
        // 제약조건 설정
        setupConstraints()
        
        // 애니메이션 효과
        setupAnimations()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)  // 스크롤뷰와 동일한 너비
            make.height.greaterThanOrEqualTo(scrollView)  // 최소한 스크롤뷰 높이
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)  // iPad에 맞게 상단 여백 증가
            make.leading.trailing.equalToSuperview().inset(40)  // 좌우 여백 추가
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)  // iPad에 맞게 간격 증가
            make.leading.trailing.equalToSuperview().inset(40)  // 좌우 여백 추가
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(60)  // iPad에 맞게 간격 증가
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(280)  // iPad에 맞게 좌우 여백 증가
            make.height.equalTo(imageContainerView.snp.width).multipliedBy(1.3)  // 이미지 비율 조정
        }
        
        introductionImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(50)  // iPad에 맞게 간격 증가
            make.leading.trailing.equalToSuperview().inset(60)  // iPad에 맞게 좌우 여백 증가
        }
        
        featuresStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(60)  // iPad에 맞게 간격 증가
            make.leading.trailing.equalToSuperview().inset(80)  // iPad에 맞게 좌우 여백 증가
            make.bottom.equalToSuperview().offset(-60)  // 하단 여백 추가
        }
    }
    
    private func setupAnimations() {
        // 초기 상태 설정 - iPad에 맞게 애니메이션 거리 증가
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -30)
        
        subtitleLabel.alpha = 0
        subtitleLabel.transform = CGAffineTransform(translationX: 0, y: -30)
        
        imageContainerView.alpha = 0
        imageContainerView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)  // 스케일 약간 더 작게 시작
        
        descriptionLabel.alpha = 0
        descriptionLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        
        featuresStackView.alpha = 0
        featuresStackView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        // 순차적 애니메이션
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.subtitleLabel.alpha = 1
            self.subtitleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [.curveEaseOut]) {
            self.imageContainerView.alpha = 1
            self.imageContainerView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.descriptionLabel.alpha = 1
            self.descriptionLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.featuresStackView.alpha = 1
            self.featuresStackView.transform = .identity
        }
    }
}

#Preview {
    SecondIntroductionViewController_iPad()
}
