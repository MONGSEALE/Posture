//
//  MainViewController.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/26/25.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxCocoa
import AVKit
import MobileCoreServices

class MainViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    private let disposeBag = DisposeBag()
    
    private var videoPlayerVC: AVPlayerViewController?
    private var currentVideoURL: URL?

    
    // MARK: - UI 컴포넌트
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "자세 분석"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진이나 영상을 업로드하여 자세를 분석해보세요"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let uploadContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private let uploadIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let uploadLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 또는 영상 업로드"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private let uploadDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "탭하여 갤러리에서 선택하거나\n카메라로 촬영하세요"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let mediaPreviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.systemGray6
        imageView.isHidden = true
        return imageView
    }()
    
    private let analysisButton = PrimaryButton(title: "자세 분석 시작", isHidden: true)
    
    private let analysisResultView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.isHidden = true
        return view
    }()
    
    private let resultTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "분석 결과"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let scoreContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "자세 점수"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let scoreValueLabel: UILabel = {
        let label = UILabel()
        label.text = "85/100"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    
    private let feedbackLabel: UILabel = {
        let label = UILabel()
        label.text = "전반적으로 좋은 자세입니다.\n어깨를 조금 더 펴시면 더욱 완벽해집니다."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let improveButton = SecondaryButton(title: "개선 방법 보기", isHidden: false)
    
    private let retryButton = PrimaryButton(title: "다시 분석하기", isHidden: false)
    
    private let saveButton = PrimaryButton(title: "저장하기", isHidden: true)
    
    private let resetButton = SecondaryButton(title: "되돌리기", isHidden: true)
    
    
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindRx()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    // MARK: -  setup함수
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(uploadContainerView)
        contentView.addSubview(mediaPreviewImageView)
        contentView.addSubview(analysisButton)
        contentView.addSubview(analysisResultView)
        contentView.addSubview(saveButton)
        contentView.addSubview(resetButton)
        
        uploadContainerView.addSubview(uploadIconImageView)
        uploadContainerView.addSubview(uploadLabel)
        uploadContainerView.addSubview(uploadDescriptionLabel)
        
        analysisResultView.addSubview(resultTitleLabel)
        analysisResultView.addSubview(scoreContainerView)
        analysisResultView.addSubview(feedbackLabel)
        analysisResultView.addSubview(improveButton)
        analysisResultView.addSubview(retryButton)
        
        scoreContainerView.addSubview(scoreLabel)
        scoreContainerView.addSubview(scoreValueLabel)
        
   
    }
    
    private func setupGradient() {
        view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
          let gradient = BackgroundGradient.onboardingGradientLayer(frame: view.bounds)
          view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        uploadContainerView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        uploadIconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
            make.size.equalTo(60)
        }
        
        uploadLabel.snp.makeConstraints { make in
            make.top.equalTo(uploadIconImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        uploadDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(uploadLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        mediaPreviewImageView.snp.makeConstraints { make in
            make.edges.equalTo(uploadContainerView)
        }
        
        analysisButton.snp.makeConstraints { make in
            make.top.equalTo(uploadContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        analysisResultView.snp.makeConstraints { make in
            make.top.equalTo(analysisButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        scoreContainerView.snp.makeConstraints { make in
            make.top.equalTo(resultTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        scoreValueLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        feedbackLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        improveButton.snp.makeConstraints { make in
            make.top.equalTo(feedbackLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(analysisResultView.snp.centerX).offset(-8)
            make.height.equalTo(52)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(feedbackLabel.snp.bottom).offset(20)
            make.leading.equalTo(analysisResultView.snp.centerX).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        saveButton.snp.makeConstraints{ make in
            make.top.equalTo(analysisResultView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        resetButton.snp.makeConstraints{ make in
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func bindRx() {
        // 업로드 컨테이너 탭 제스처
        let uploadTapGesture = UITapGestureRecognizer()
        uploadContainerView.addGestureRecognizer(uploadTapGesture)
        uploadContainerView.isUserInteractionEnabled = true
        
        uploadTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.showMediaSelectionAlert()
            })
            .disposed(by: disposeBag)
        
        // 분석 버튼
        analysisButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleAnalysisButtonTap()
            })
            .disposed(by: disposeBag)
        
        // 개선 방법 버튼
        improveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleImproveButtonTap()
            })
            .disposed(by: disposeBag)
        
        // 다시 분석 버튼
        retryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleRetryButtonTap()
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleSaveButtonTap()
            })
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleResetButtonTap()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 이벤트 함수
    
    private func handleAnalysisButtonTap() {
        // 여기에 AI 분석 로직 구현
        print("Analysis button tapped")
    }
    
    private func handleImproveButtonTap() {
        // 여기에 개선 방법 표시 로직 구현
        print("Improve button tapped")
    }
    
    private func handleRetryButtonTap() {
        // 여기에 재분석 로직 구현
        print("Retry button tapped")
    }
    
    private func showMediaSelectionAlert() {
          let alertController = UIAlertController(title: "미디어 선택", message: "", preferredStyle: .actionSheet)
          
          // 촬영하기
          let cameraAction = UIAlertAction(title: "촬영하기", style: .default) { [weak self] _ in
              self?.openCamera()
          }
          cameraAction.setValue(UIImage(systemName: "camera"), forKey: "image")
          
          // 갤러리에서 선택
          let galleryAction = UIAlertAction(title: "갤러리에서 선택", style: .default) { [weak self] _ in
              self?.openGallery()
          }
          galleryAction.setValue(UIImage(systemName: "photo.on.rectangle"), forKey: "image")
          
          // 취소
          let cancelAction = UIAlertAction(title: "취소", style: .cancel)
          
          alertController.addAction(cameraAction)
          alertController.addAction(galleryAction)
          alertController.addAction(cancelAction)
          
          present(alertController, animated: true)
      }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                 print("카메라 사용 불가")
                 return
             }
             let picker = UIImagePickerController()
             picker.sourceType = .camera
             picker.delegate = self
             present(picker, animated: true)
      }
      
      private func openGallery() {
          guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                  print("포토 라이브러리 사용 불가")
                  return
              }
              let picker = UIImagePickerController()
              picker.sourceType = .photoLibrary
              picker.delegate = self
              //이미지랑 영상 둘다
              picker.mediaTypes = ["public.image", "public.movie"]
              present(picker, animated: true)
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // 1. 기존에 있던 AVPlayerViewController 제거 (중복 제거)
        if let videoPlayerVC = videoPlayerVC {
            videoPlayerVC.willMove(toParent: nil)
            videoPlayerVC.view.removeFromSuperview()
            videoPlayerVC.removeFromParent()
            self.videoPlayerVC = nil
        }
        mediaPreviewImageView.isHidden = true
        
        if let image = info[.originalImage] as? UIImage {
            // 사진 업로드시 기존대로 이미지뷰에 표시
            mediaPreviewImageView.image = image
            mediaPreviewImageView.isHidden = false
        } else if let videoURL = info[.mediaURL] as? URL {
            // 영상 업로드시 AVPlayerViewController로 영상 재생
            let player = AVPlayer(url: videoURL)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            playerVC.view.frame = uploadContainerView.bounds
            playerVC.showsPlaybackControls = true
            playerVC.videoGravity = .resizeAspectFill

            // 미리보기 영역에 embed
            uploadContainerView.addSubview(playerVC.view)
            playerVC.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.addChild(playerVC)
            playerVC.didMove(toParent: self)
            player.play() // 자동재생

            self.videoPlayerVC = playerVC
            self.currentVideoURL = videoURL
        }
        
        // 공통 UI 처리
        uploadIconImageView.isHidden = true
        uploadLabel.isHidden = true
        uploadDescriptionLabel.isHidden = true
        analysisButton.isHidden = false
        analysisResultView.isHidden = false
        saveButton.isHidden = false
        resetButton.isHidden = false
    }

    
    private func handleSaveButtonTap(){
        
    }
    
    private func handleResetButtonTap(){
        mediaPreviewImageView.image = nil
        mediaPreviewImageView.isHidden = true

        // 업로드 안내 UI 다시 노출
        uploadIconImageView.isHidden = false
        uploadLabel.isHidden = false
        uploadDescriptionLabel.isHidden = false

        // 분석 버튼, 저장/되돌리기, 결과 뷰 숨기기
        analysisButton.isHidden = true
        analysisResultView.isHidden = true
        saveButton.isHidden = true
        resetButton.isHidden = true

        // 만약 영상 플레이어 뷰가 있다면 제거
        if let videoPlayerVC = videoPlayerVC {
            videoPlayerVC.willMove(toParent: nil)
            videoPlayerVC.view.removeFromSuperview()
            videoPlayerVC.removeFromParent()
            self.videoPlayerVC = nil
            self.currentVideoURL = nil
        }
    }


}

#Preview{
    MainViewController()
}
