//
//  ImageDetailViewController.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 03.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: - Properties
    var delegate: ImageDetailViewProtocol?
    var imageInfo: ImageResult!
    var currIndex: Int!
    
    private var task: URLSessionDataTask?
    
    private let alertViewNoImages = AlertView(alertText: "Больше нет изображений")
    private let viewWithLabel = WrapperViewWithLabel()
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGestureToToggleHideToolBar()
        addSwipeGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setImage()
    }
    
    // MARK: - Add View With Label To Search
    private func showViewWithLabel(text: String) {
        if !view.subviews.contains(viewWithLabel) {
            view.addSubview(viewWithLabel)
            viewWithLabel.translatesAutoresizingMaskIntoConstraints = false
            viewWithLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            viewWithLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            viewWithLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            viewWithLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6 * 8).isActive = true
        }
        
        viewWithLabel.label.text = text
        viewWithLabel.isHidden = false
    }
    
    // MARK: - Show Alert
    private func showAlertView(alertView: AlertView) {
        if !view.subviews.contains(alertView) {
            view.addSubview(alertView)

            alertView.translatesAutoresizingMaskIntoConstraints = false
            alertView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
            alertView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        }
        
        alertView.alpha = 1.0
        alertView.isHidden = false
        
        alertView.hideWithAnimation()
    }
    
    // MARK: - Set Image
    private func setImage() {
        navigationItem.title = imageInfo.title
        
        viewWithLabel.isHidden = true
        
        // Пытаемся установить из Original,
        // Если что-то пойдет не так - оттуда вызовется setImageFromThumbnail
        setImageFromOriginal()
    }
    
    private func setImageFromOriginal() {
        // Прекращаем прошлое скачивание
        task?.cancel()
        
        // Если ссылки на оригинал нет - устанавливаем из thumbnail
        guard let original = imageInfo.original else {
            setImageFromThumbnail()
            return
        }
        
        // Если есть в кэше - устанавливаем оттуда
        if let originalFromCache = ImagesManager.shared.getCachedImage(urlString: original) {
            self.imageView.image = originalFromCache
            return
        }
        
        task = ImagesManager.shared.loadImage(urlString: original) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                self.setImageFromThumbnail()
            }
        }
        task?.resume()
    }
    
    private func setImageFromThumbnail() {
        // Прекращаем прошлое скачивание
        task?.cancel()
        
        guard let thumbnail = imageInfo.thumbnail else {
            return
        }
        
        if let thumbnailFromCache = ImagesManager.shared.getCachedImage(urlString: thumbnail) {
            DispatchQueue.main.async {
                self.imageView.image = thumbnailFromCache
            }
            return
        }
        
        task = ImagesManager.shared.loadImage(urlString: thumbnail) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.showViewWithLabel(text: "Что-то пошло не так")
                }
            }
        }
        task?.resume()
    }
    
    // MARK: - Add Gesture Recognizers
    private func addTapGestureToToggleHideToolBar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleHideToolBar))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc private func toggleHideToolBar() {
        toolBar.isHidden = !toolBar.isHidden
    }
    
    private func addSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeLeft.direction = .left
        imageView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeRight.direction = .right
        imageView.addGestureRecognizer(swipeRight)
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
    
    private func showPreviousImage() {
        let previousImage = delegate?.previousImage(from: currIndex)
        
        if let previousImage = previousImage {
            currIndex = previousImage.index
            imageInfo = previousImage.info
            imageView.image = nil
            setImage()
        } else {
            showAlertView(alertView: alertViewNoImages)
        }
    }
    
    private func showNextImage() {
        let nextImage = delegate?.nextImage(from: currIndex)
        
        if let nextImage = nextImage {
            currIndex = nextImage.index
            imageInfo = nextImage.info
            imageView.image = nil
            setImage()
        } else {
            showAlertView(alertView: alertViewNoImages)
        }
    }
    
    private func openLink() {
        let webViewController = WebViewController()
        webViewController.link = imageInfo.link
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
