import UIKit
import SnapKit

final class ActionCell: UICollectionViewCell {

    private(set) var titleLabel = UILabel()
    private var highlightedBackgroundView = UIView()
    private var iconView: UIImageView?

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
        
        titleLabel.textAlignment = .center
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
        self.titleLabel.textAlignment = visualStyle.buttonTextAlignment
        
        if let icon = action.icon {
            let iconView = UIImageView(image: icon)
            iconView.contentMode = .scaleAspectFit
            iconView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            addSubview(iconView)
            self.iconView = iconView
        }
        
        self.highlightedBackgroundView.backgroundColor = visualStyle.actionHighlightColor

        self.setupConstraints(visualStyle: visualStyle)
        self.setupAccessibility(using: action)
    }
    
    private func setupConstraints(visualStyle: AlertVisualStyle) {
        highlightedBackgroundView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.size.equalTo(snp.size)
        }
        
        if let iconView = iconView {
            iconView.snp.makeConstraints { make in
                make.leading.equalTo(snp.leading).offset(visualStyle.buttonTitleMargin)
                make.centerY.equalTo(snp.centerY)
                make.height.lessThanOrEqualTo(snp.height)
            }
        }
        
        titleLabel.snp.makeConstraints { make in
            if let iconView = self.iconView {
                make.leading.equalTo(iconView.snp.trailing).offset(visualStyle.buttonTitleMargin)
            } else {
                make.leading.equalTo(snp.leading).offset(visualStyle.buttonTitleMargin)
            }
            make.trailing.equalTo(snp.trailing).offset(0.0 - visualStyle.buttonTitleMargin)
            make.centerY.equalTo(snp.centerY)
        }
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
