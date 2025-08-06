import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FirstIntroductionViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    
    // 메인 로고/아이콘 컨테이너
    private let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        view.layer.cornerRadius = 60
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 20
        
        // 블러 효과
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 60
        blurView.clipsToBounds = true
        view.addSubview(blurView)
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        // 붓 아이콘
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        imageView.image = UIImage(systemName: "paintbrush.fill", withConfiguration: config)
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캔버스 그리기"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
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
        label.text = "당신의 창의력을 마음껏 표현하세요\n무제한 캔버스에서 꿈을 그려보세요"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
    
    private let featureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()
    
    // 떠다니는 아이콘들
    private var floatingIcons: [UIImageView] = []
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupFeatures()
        setupFloatingAnimation()
        
    }

    
    // MARK: - Setup함수
    private func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        logoContainerView.addSubview(logoImageView)
        
        [logoContainerView, titleLabel, subtitleLabel, featureStackView].forEach {
            contentView.addSubview($0)
        }
    
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 떠다니는 아이콘들의 위치를 뷰가 완전히 로드된 후 설정
        floatingIcons.enumerated().forEach { index, icon in
            icon.snp.remakeConstraints { make in
                make.size.equalTo(30)
                make.centerX.equalToSuperview().offset(CGFloat.random(in: -150...150))
                make.centerY.equalToSuperview().offset(CGFloat.random(in: -200...200))
            }
        }
        
        view.layoutIfNeeded()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        logoContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoContainerView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        featureStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    
    }
    
    private func setupFeatures() {
        let features = [
            ("🎨", "무제한 캔버스", "마음껏 그리고 창작하세요"),
            ("✏️", "다양한 도구", "펜, 연필, 붓 등 다양한 도구 지원"),
            ("💾", "간편한 저장", "작품을 사진앱에 저장하고 공유하세요")
        ]

        
        features.forEach { emoji,title, description in
            let featureView = createFeatureView( emoji: emoji, title: title, description: description)
            featureStackView.addArrangedSubview(featureView)
        }
    }
    
    private func createFeatureView(emoji: String, title: String, description: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        // 블러 효과
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        containerView.insertSubview(blurView, at: 0)
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 28)
        emojiLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        descriptionLabel.numberOfLines = 2
        
        [emojiLabel, titleLabel, descriptionLabel].forEach {
            containerView.addSubview($0)
        }
        
        emojiLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(emojiLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        // 호버 효과를 위한 제스처 추가
        let tapGesture = UITapGestureRecognizer()
        containerView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { _ in
                self.animateFeatureView(containerView)
            })
            .disposed(by: disposeBag)
        
        return containerView
    }
    
    // MARK: - 애니메이션
    private func setupFloatingAnimation() {
        // 애니메이션은 viewDidAppear에서 시작
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startFloatingAnimations()
        }
    }
    
    private func startFloatingAnimations() {
        floatingIcons.enumerated().forEach { index, icon in
            UIView.animate(withDuration: Double.random(in: 3...6),
                          delay: Double(index) * 0.2,
                          options: [.repeat, .autoreverse, .curveEaseInOut]) {
                icon.transform = CGAffineTransform(translationX: CGFloat.random(in: -50...50),
                                                 y: CGFloat.random(in: -30...30))
                    .rotated(by: CGFloat.random(in: -0.3...0.3))
            }
        }
    }
    
    
    private func animateFeatureView(_ view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                view.transform = CGAffineTransform.identity
            }
        }
    }
}

#Preview{
    FirstIntroductionViewController()
}
