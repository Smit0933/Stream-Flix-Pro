

import UIKit
protocol HeroHeaderUIViewDelegate: AnyObject {
    func heroHeaderViewDidTapPlayButton(_ header: HeroHeaderUIView)
    func heroHeaderViewDidTapDownloadButton(_ header: HeroHeaderUIView)
}
final class HeroHeaderUIView: UIView {
    weak var delegate: HeroHeaderUIViewDelegate?
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "extraction")
        return imageView
        
    }()
    
    private lazy var playButton: UIButton = HeroHeaderUIView.createButton(name: "Play")
    private lazy var downloadButton: UIButton = HeroHeaderUIView.createButton(name: "Download")
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
                downloadButton.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func didTapPlayButton() {
           delegate?.heroHeaderViewDidTapPlayButton(self)
       }
       
       @objc private func didTapDownloadButton() {
           delegate?.heroHeaderViewDidTapDownloadButton(self)
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    private func applyConstraints() {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    private static func createButton(name: String) -> UIButton {
        let button = UIButton()
        button.setTitle(name, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }
    
    private var currentViewModel: TitleViewModel?
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
        
        heroImageView.sd_setImage(with: url)
    }
}

