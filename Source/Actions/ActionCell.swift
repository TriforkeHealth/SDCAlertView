import UIKit
import SnapKit

final class ActionCell: UICollectionViewCell {

    private(set) var titleLabel = UILabel()
    private var highlightedBackgroundView = UIView()

    private var textColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(highlightedBackgroundView)
        
        highlightedBackgroundView.alpha = 0.7
        highlightedBackgroundView.isHidden = true
        highlightedBackgroundView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.size.equalTo(snp.size)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(12.0)
            make.trailing.equalTo(snp.trailing).offset(-12.0)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    var isEnabled = true {
        didSet { self.titleLabel.isEnabled = self.isEnabled }
    }

    override var isHighlighted: Bool {
        didSet { self.highlightedBackgroundView.isHidden = !self.isHighlighted }
    }

    func set(_ action: AlertAction, with visualStyle: AlertVisualStyle) {
        action.actionView = self

        self.titleLabel.font = visualStyle.font(for: action)
        
        self.textColor = visualStyle.textColor(for: action)
        self.titleLabel.textColor = self.textColor ?? self.tintColor
        
        self.titleLabel.attributedText = action.attributedTitle

        self.highlightedBackgroundView.backgroundColor = visualStyle.actionHighlightColor

        self.setupAccessibility(using: action)
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.titleLabel.textColor = self.textColor ?? self.tintColor
    }
}

final class ActionSeparatorView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        if let attributes = layoutAttributes as? ActionsCollectionViewLayoutAttributes {
            self.backgroundColor = attributes.backgroundColor
        }
    }
}
