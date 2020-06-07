//
//  ImageDetailViewController+Actions.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 06.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

extension ImageDetailViewController {
    
    // MARK: - Add Gesture Recognizers
    func addTapGestureToToggleHideToolBar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleHideToolBar))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleHideToolBar() {
        toolBar.isHidden = !toolBar.isHidden
    }
    
    func addSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            showNextImage()
        } else if gesture.direction == .right {
            showPreviousImage()
        }
    }
    
    // MARK: - Actions
    @IBAction func showPreviousImageTapped(_ sender: UIBarButtonItem) {
        showPreviousImage()
    }
    
    @IBAction func showNextImageTapped(_ sender: UIBarButtonItem) {
        showNextImage()
    }
    
    @IBAction func openLinkTapped(_ sender: UIBarButtonItem) {
        openLink()
    }
    
    // MARK: - Methods
    private func showPreviousImage() {
        let previousImage = delegate?.previousImage(from: currIndex)
        
        if let previousImage = previousImage {
            currIndex = previousImage.index
            imageInfo = previousImage.info
            task?.cancel()
            imageView.image = nil
            setImage()
        } else {
            showAlertView(withText: "Больше нет изображений")
        }
    }
       
    private func showNextImage() {
        let nextImage = delegate?.nextImage(from: currIndex)
        
        if let nextImage = nextImage {
            currIndex = nextImage.index
            imageInfo = nextImage.info
            task?.cancel()
            imageView.image = nil
            setImage()
        } else {
            showAlertView(withText: "Загружается...")
        }
    }
       
    private func openLink() {
        let webViewController = WebViewController()
        webViewController.link = imageInfo.link
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
