

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import PencilKit


class DrawingViewController: UIViewController {
    
    //MARK: 컴포넌트
    
    private let disposeBag = DisposeBag()
    
    private var canvasView: PKCanvasView = {
        let view = PKCanvasView()
        view.backgroundColor = .white
        view.isOpaque = false
        view.tool = PKInkingTool(.pen, color: .black, width: 3)
        view.drawingPolicy = .anyInput // 손가락으로도 그리기 가능
        return view
    }()

    private var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("지우기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("뒤로", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private var screenshotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("공유", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindActions()
    }
    
    
    //MARK: setup함수
    private func setupViews() {
        view.backgroundColor = .systemBackground
    
        view.addSubview(canvasView)
        view.addSubview(clearButton)
        view.addSubview(backButton)
        view.addSubview(screenshotButton)
        view.addSubview(shareButton)
    }
    
    private func setupConstraints() {
        canvasView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(clearButton.snp.top).offset(-20)
        }
        
        clearButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.centerX).offset(-50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.centerX).offset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        screenshotButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        shareButton.snp.makeConstraints { make in
              make.leading.equalTo(screenshotButton.snp.trailing).offset(15)
              make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
              make.width.equalTo(70)
              make.height.equalTo(44)
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
                self?.saveCanvasScreenshot()
            })
            .disposed(by: disposeBag)
        shareButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.shareCanvasImage()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: 이벤트 함수
    private func saveCanvasScreenshot() {
        // 캔버스 뷰만 이미지로 변환
        let renderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
        let image = renderer.image { context in
            // 흰색 배경 먼저 그리기
            UIColor.white.setFill()
            context.fill(canvasView.bounds)
            
            // 캔버스의 그림 그리기
            canvasView.layer.render(in: context.cgContext)
        }
        
        // 사진 앱에 저장
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
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
    
    private func shareCanvasImage() {
        // 캔버스 뷰만 이미지로 변환
        let renderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
        let image = renderer.image { context in
            // 흰색 배경 먼저 그리기
            UIColor.white.setFill()
            context.fill(canvasView.bounds)
            
            // 캔버스의 그림 그리기
            canvasView.layer.render(in: context.cgContext)
        }
        
        // 공유할 아이템들
        let activityItems: [Any] = [image, "내가 그린 그림을 공유합니다!"]
        
        // UIActivityViewController 생성
        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        // iPad에서 팝오버 설정 (iPhone에서는 무시됨)
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        // 공유 화면 표시
        present(activityViewController, animated: true)
    }

}



#Preview{
    DrawingViewController()
}

