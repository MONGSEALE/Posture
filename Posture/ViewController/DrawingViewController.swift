import UIKit
import SnapKit
import RxCocoa
import RxSwift
import PencilKit
import Photos


class DrawingViewController: UIViewController {
    
    //MARK: 컴포넌트
    private let disposeBag = DisposeBag()
    
    private var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        return toolPicker
    }()
    
    private var canvasView: PKCanvasView = {
        let view = PKCanvasView()
        view.backgroundColor = .white
        view.isOpaque = false
        view.tool = PKInkingTool(.pen, color: .black, width: 3)
        view.drawingPolicy = .anyInput // 손가락으로도 그리기 가능
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        return view
    }()

    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        stackView.layer.cornerRadius = 25
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOffset = CGSize(width: 0, height: -2)
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.shadowRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        return stackView
    }()

    private var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.systemRed.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        
        // 버튼 눌림 효과
        button.addTarget(nil, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(nil, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()
    
    private var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("지우기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.systemOrange.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        
        // 버튼 눌림 효과
        button.addTarget(nil, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(nil, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()
     
    private var screenshotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.systemGreen.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        
        // 버튼 눌림 효과
        button.addTarget(nil, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(nil, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("공유", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        
        // 버튼 눌림 효과
        button.addTarget(nil, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(nil, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()
    
    private var toolToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("도구", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.systemPurple.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        
        // 버튼 눌림 효과
        button.addTarget(nil, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(nil, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()
    
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 뷰가 나타날 때 툴피커를 캔버스뷰와 연결
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        toolPicker.overrideUserInterfaceStyle = .light
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 3)
    }
    
    
    //MARK: setup함수
    private func setupGradient() {
        view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
          let gradient = BackgroundGradient.onboardingGradientLayer(frame: view.bounds)
          view.layer.insertSublayer(gradient, at: 0)
    }
    
    
    private func setupViews() {
        view.backgroundColor = .systemGray6
    
        view.addSubview(canvasView)
        view.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(clearButton)
        buttonStackView.addArrangedSubview(backButton)
        buttonStackView.addArrangedSubview(screenshotButton)
        buttonStackView.addArrangedSubview(shareButton)
    }
    
    private func setupConstraints() {
        canvasView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(500)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(canvasView.snp.bottom).offset(20)
            make.height.equalTo(74)
        }
        
        // 각 버튼의 높이 설정
        [clearButton, backButton, screenshotButton, shareButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
        }
    }
    
    //MARK: 버튼 애니메이션 효과
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
    //MARK: 바인딩
    private func bindActions() {
        clearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.canvasView.drawing = PKDrawing()
            })
            .disposed(by: disposeBag)
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.canvasView.undoManager?.undo()
            })
            .disposed(by: disposeBag)
        screenshotButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.checkPhotoLibraryPermissionAndSave()
            })
            .disposed(by: disposeBag)
        shareButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.shareCanvasImage()
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: 이벤트 함수
    
    private func checkPhotoLibraryPermissionAndSave() {
          let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
          
          switch status {
          case .authorized, .limited:
              print("1")
              // 권한이 있는 경우 바로 저장
              saveCanvasScreenshot()
          case .denied, .restricted:
              print("2")
              // 권한이 거부된 경우 설정으로 이동하도록 안내
              showPermissionDeniedAlert()
          case .notDetermined:
              print("3")
              // 권한을 아직 요청하지 않은 경우 권한 요청
              PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] newStatus in
                  DispatchQueue.main.async {
                      switch newStatus {
                      case .authorized, .limited:
                          self?.saveCanvasScreenshot()
                      case .denied, .restricted:
                          self?.showPermissionDeniedAlert()
                      default:
                          break
                      }
                  }
              }
          @unknown default:
              break
          }
      }
    
//    private func saveCanvasScreenshot() {
//        // 캔버스 뷰만 이미지로 변환
//        let renderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
//        let image = renderer.image { context in
//            // 흰색 배경 먼저 그리기
//            UIColor.white.setFill()
//            context.fill(canvasView.bounds)
//            
//            // 캔버스의 그림 그리기
//            canvasView.layer.render(in: context.cgContext)
//        }
//        
//        // 사진 앱에 저장
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
    
    private func saveCanvasScreenshot() {
        let drawing = canvasView.drawing
        let bounds = drawing.bounds
        let scale = UIScreen.main.scale

        let image = drawing.image(from: bounds, scale: scale)

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "사진 접근 권한 필요",
            message: "그림을 저장하려면 사진 라이브러리 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert: UIAlertController
        
        if let error = error {
            alert = UIAlertController(title: "저장 실패", message: error.localizedDescription, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "저장 완료", message: "그림이 사진 앱에 저장되었습니다.", preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
//    private func shareCanvasImage() {
//        // 캔버스 뷰만 이미지로 변환
//        let renderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
//        let image = renderer.image { context in
//            // 흰색 배경 먼저 그리기
//            UIColor.white.setFill()
//            context.fill(canvasView.bounds)
//            
//            // 캔버스의 그림 그리기
//            canvasView.layer.render(in: context.cgContext)
//        }
//        
//        // 공유할 아이템들
//        let activityItems: [Any] = [image]
//        
//        // UIActivityViewController 생성
//        let activityViewController = UIActivityViewController(
//            activityItems: activityItems,
//            applicationActivities: nil
//        )
//        
//        // iPad에서 팝오버 설정 (iPhone에서는 무시됨)
//        if let popover = activityViewController.popoverPresentationController {
//            popover.sourceView = shareButton
//            popover.sourceRect = shareButton.bounds
//        }
//        
//        // 공유 화면 표시
//        present(activityViewController, animated: true)
//    }
    
    private func shareCanvasImage() {
        let drawing = canvasView.drawing
        let bounds = drawing.bounds
        let scale = UIScreen.main.scale

        let image = drawing.image(from: bounds, scale: scale)

        let activityItems: [Any] = [image]
        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )

        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }

        present(activityViewController, animated: true)
    }

    
}



#Preview{
    DrawingViewController()
}
