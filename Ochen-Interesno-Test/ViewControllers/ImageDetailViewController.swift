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
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGestureToToggleHideToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setImage()
        
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - Methods
    private func setImage() {
        navigationItem.title = imageInfo.title
        
        // Пытаемся установить из Original,
        // Если что-то пойдет не так - оттуда вызовется setImageFromThumbnail
        setImageFromOriginal()
    }
    
    private func setImageFromOriginal() {
        // Прекращаем прошлое скачивание
        task?.cancel()
        
        print("original")
        // Если ссылки на оригинал нет - устанавливаем из thumbnail
        guard let original = imageInfo.original else {
            print("нет original")
            setImageFromThumbnail()
            return
        }
        
        // Если есть в кэше - устанавливаем оттуда
        if let originalFromCache = ImagesManager.shared.getCachedImage(urlString: original) {
            print("originalFromCache")
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
        
        print("thumbnail")
        guard let thumbnail = imageInfo.thumbnail else {
            print("нет thumbnail")
            return
        }
        
        if let thumbnailFromCache = ImagesManager.shared.getCachedImage(urlString: thumbnail) {
            print("thumbnailFromCache")
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
            }
        }
        task?.resume()
    }
    
    // MARK: - Add Gesture Recognizer
    private func addTapGestureToToggleHideToolBar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleHideToolBar))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc private func toggleHideToolBar() {
        toolBar.isHidden = !toolBar.isHidden
    }
    
    // MARK: - Actions
    @IBAction func showPreviousImage(_ sender: UIBarButtonItem) {
        let previousImage = delegate?.previousImage(from: currIndex)
        
        if let previousImage = previousImage {
            currIndex = previousImage.index
            imageInfo = previousImage.info
            imageView.image = nil
            setImage()
        } else {
            print("Нету больше")
        }
    }
    
    @IBAction func showNextImage(_ sender: UIBarButtonItem) {
        let nextImage = delegate?.nextImage(from: currIndex)
        
        if let nextImage = nextImage {
            currIndex = nextImage.index
            imageInfo = nextImage.info
            imageView.image = nil
            setImage()
        } else {
            print("Нету больше")
        }
    }
    
    @IBAction func openLink(_ sender: UIBarButtonItem) {
        let webViewController = WebViewController()
        webViewController.link = imageInfo.link
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
