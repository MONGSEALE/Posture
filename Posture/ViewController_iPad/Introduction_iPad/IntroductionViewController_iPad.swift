//
//  IntroductionViewController.swift
//  Posture
//
//  Created by DongHyeokHwang on 7/25/25.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import AVFoundation
import CoreData


class IntroductionViewController_iPad : UIViewController{
    
    // MARK: 컴포넌트
    
    private let disposeBag = DisposeBag()
    
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        control.currentPage = 0
        control.pageIndicatorTintColor = UIColor.systemGray4
        control.currentPageIndicatorTintColor = UIColor.systemBlue
        control.hidesForSinglePage = false
        return control
    }()
    
    private lazy var nextButton = PrimaryButton(title: "다음",isHidden: false, isiphone: false)
    
    private var currentPageIndex = 0
    
    private lazy var introductionPages : [UIViewController] = [
        FirstIntroductionViewController_iPad(),
        SecondIntroductionViewController_iPad(),
        ThirdIntroductionViewController_iPad()
        
    ]
    
    // MARK: 생명주기
    override func viewDidLoad() {
        setupUI()
        setupConstraints()
        setupPageViewController()
        setupRx()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    // MARK: setup함수
    private func setupUI(){
        view.backgroundColor = .systemBackground
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        pageViewController.didMove(toParent: self)
    }
    
    private func setupGradient() {
        view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
          let gradient = BackgroundGradient.onboardingGradientLayer(frame: view.bounds)
          view.layer.insertSublayer(gradient, at: 0)
    }

    private func setupConstraints() {
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(108)
        }
    }
    
    private func setupPageViewController() {
          pageViewController.dataSource = self
          pageViewController.delegate = self
          
          // 첫 번째 페이지 설정
          if let firstPage = introductionPages.first {
              pageViewController.setViewControllers(
                  [firstPage],
                  direction: .forward,
                  animated: false,
                  completion: nil
              )
          }
      }
    
  
    
      private func setupRx() {
          // 다음 버튼 탭 처리
          nextButton.rx.tap
              .subscribe(onNext: { [weak self] in
                  self?.handleNextButtonTapped()
              })
              .disposed(by: disposeBag)
          
          // 페이지 컨트롤 탭 처리 (옵션)
          pageControl.rx.controlEvent(.valueChanged)
              .subscribe(onNext: { [weak self] in
                  guard let self = self else { return }
                  self.goToPage(self.pageControl.currentPage)
              })
              .disposed(by: disposeBag)
      }
    
  
    
    
    
    // MARK: - 이벤트 함수
    private func handleNextButtonTapped() {
        if currentPageIndex < introductionPages.count - 1 {
            // 다음 페이지로 이동
            goToPage(currentPageIndex + 1)
        } else {
            // 마지막 페이지에서 "시작하기" 버튼 클릭
            handleStartButtonTapped()
        }
    }
    
    private func goToPage(_ index: Int) {
        guard index >= 0 && index < introductionPages.count else { return }
        
        let direction: UIPageViewController.NavigationDirection = index > currentPageIndex ? .forward : .reverse
        
        pageViewController.setViewControllers(
            [introductionPages[index]],
            direction: direction,
            animated: true,
            completion: { [weak self] _ in
                self?.updateCurrentPage(index)
            }
        )
    }
    
    
    private func updateCurrentPage(_ index: Int) {
        currentPageIndex = index
        pageControl.currentPage = index
        
        // 마지막 페이지에서 버튼 텍스트 변경
        let buttonTitle = index == introductionPages.count - 1 ? "시작하기" : "다음"
        nextButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func handleStartButtonTapped() {
        print("시작하기 버튼이 탭되었습니다")
        
        // 온보딩 완료 표시
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        let VC = DrawingViewController_iPad()
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: false)
    }
    
}

#Preview{
    IntroductionViewController_iPad()
}


// MARK: - UIPageViewControllerDataSource
extension IntroductionViewController_iPad: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = introductionPages.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        return introductionPages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = introductionPages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        
        guard nextIndex < introductionPages.count else { return nil }
        return introductionPages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension IntroductionViewController_iPad: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed,
              let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = introductionPages.firstIndex(of: currentViewController) else { return }
        
        updateCurrentPage(currentIndex)
    }
}




