//
//  AlertView.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 05.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    convenience init(alertText: String) {
        self.init()
        alertLabel.text = alertText
    }
    
    // MARK: - Setup Views
    private func commonInit() {
        loadXib()
        setupViews()
    }
    
    private func loadXib() {
        // загружаем xib из какого-то Boundle (можно чекнуть документацию)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupViews() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 15
        //alertLabel.textColor = Colors.contentColor
        setupLabels()
    }
    
    private func setupLabels() {
        alertLabel.textColor = .gray
        alertLabel.textAlignment = .center
        alertLabel.numberOfLines = 0
        alertLabel.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Скрытие view с анимацией
    func hideWithAnimation() {
        UIView.animate(
            withDuration: 2.0,
            animations: {
                self.alpha = 0.0
            },
            completion: { finished in
                if finished { self.isHidden = true }
            }
        )
    }
    
}
