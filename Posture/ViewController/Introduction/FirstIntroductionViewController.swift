//
//  ViewController.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FirstIntroductionViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        // SF Symbol 사용 (나중에 로고로 교체)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        imageView.image = UIImage(systemName: "figure.walk", withConfiguration: config)
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PostureAI"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "AI 기반 자세 분석으로\n건강한 생활을 시작하세요"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let featureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        return stackView
    }()
    
   
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupFeatures()
    }
    
    
    // MARK: - Setup함수
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [logoImageView, titleLabel, subtitleLabel, featureStackView].forEach {
            contentView.addSubview($0)
        }
    }
    

    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        featureStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
    }
    
    private func setupFeatures() {
        let features = [
            ("camera.fill", "실시간 자세 분석", "카메라를 통해 실시간으로 자세를 분석합니다"),
            ("brain.head.profile", "AI 기반 분석", "고도화된 AI 알고리즘으로 정확한 분석을 제공합니다"),
            ("chart.line.uptrend.xyaxis", "개선 추적", "시간에 따른 자세 개선 과정을 추적합니다")
        ]
        
        features.forEach { iconName, title, description in
            let featureView = createFeatureView(iconName: iconName, title: title, description: description)
            featureStackView.addArrangedSubview(featureView)
        }
    }
    
    private func createFeatureView(iconName: String, title: String, description: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.secondarySystemBackground
        containerView.layer.cornerRadius = 16
        
        let iconImageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        iconImageView.image = UIImage(systemName: iconName, withConfiguration: config)
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        
        [iconImageView, titleLabel, descriptionLabel].forEach {
            containerView.addSubview($0)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        
        return containerView
    }
    
    

    
}

#Preview{
    FirstIntroductionViewController()
}
