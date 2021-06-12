//
//  CaijiCells.swift
//  BusinessDeer
//
//  Created by 梁泽 on 2021/3/23.
//

import UIKit
import SwiftComponents
import YYText



public class CaijiBaseCell: LZTableViewCell {
    let indictor = IndictorTitleView(title: "基础信息")
    let stack = UIStackView(arrangedSubviews: [], spacing: 0, alignment: .fill, distribution: .fill, axis: .vertical)
    public override func setupUI() {
        contentView.add(indictor).snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(14.5)
        }
        
        contentView.add(stack).snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(indictor.snp.bottom).offset(13)
        }
    }
    
    public func bind(_ model: [CaijiITemModel]) {
        stack.removeArrangedSubviews()
        stack.removeSubviews()
        
        for i in model {
            let view = Item1View()
            view.bind(i)
            stack.addArrangedSubview(view)
        }
    }
    
}

//MARK: - 子视图
extension CaijiBaseCell {
    /// cell大小
    public class Item1View: LZView {
        public let titleLabel = UILabel(font: .font16, textColor: .hex888888, text: "标题", numberOfLines: 0)
        public let rightLabel = UILabel(font: UIFont.font16.PF_Medium, textColor: .hex333333, text: "请选择", textAlignment: .right)
        public let textField = UITextField(font: UIFont.font16.PF_Medium, textColor: .hex333333, textAlignment: .right).then {
            $0.attributedPlaceholder = "请填写".colored(with: .hex999999).font(with: .font16)
            $0.setupContentPriority(.fittingSizeLevel, for: .horizontal)
        }
        public let arrowImageView = UIImageView(image: R.right014.image).then {
            $0.setupContentPriority(.required, for: .horizontal)
        }
        
        private lazy var subs: [UIView] = [titleLabel, textField, rightLabel, arrowImageView]
        public lazy var stack = UIStackView(arrangedSubviews: [titleLabel, textField, rightLabel, arrowImageView], spacing: 6, alignment: .center, distribution: .fill, axis: .horizontal)
        public let lineView = UIView(color: UIColor.hexE5E5E5.withAlphaComponent(0.5))
        
        public override func setupUI() {
            add(stack).snp.makeConstraints {
                $0.left.equalToSuperview().offset(18)
                $0.right.equalToSuperview().offset(-13)
                $0.top.equalToSuperview().offset(18)
                $0.bottom.equalToSuperview().offset(-18)
            }
            
            add(lineView).snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(0.5)
            }
            
            let labelHeight: CGFloat = 18
//            rightLabel.snp.makeConstraints { $0.height.equalTo(labelHeight) }
//            textField.snp.makeConstraints({ $0.height.equalTo(labelHeight) })
            titleLabel.snp.makeConstraints {
//                $0.height.greaterThanOrEqualTo(labelHeight)
                $0.width.equalTo(ScreenWidth * 0.5)
            }
            arrowImageView.snp.makeConstraints {
                $0.height.equalTo(labelHeight)
            }
            
            textField.addTarget(self, action: #selector(valueEditingChanged(_:)), for: .editingChanged)
        }
        
        @objc func valueEditingChanged(_ sender: UITextField) {
            lzprint(sender.text)
        }
        
        func bind(_ model: CaijiITemModel) {
            titleLabel.text = model.key * 8
            textField.text = model.value
            
            subs.forEach { $0.isHidden = true }
            titleLabel.isHidden = false
            textField.isHidden = false
            switch model.style {
            case .左标题_右标题:
                textField.isUserInteractionEnabled = false
            case .左标题_输入框:
                textField.isUserInteractionEnabled = true
            case .左标题_输入框_右标题:
                textField.isUserInteractionEnabled = true
                rightLabel.isHidden = false
            case .左标题_请选择_右箭头:
                textField.attributedPlaceholder = "请选择".colored(with: .hex999999).font(with: .font16)
                textField.isUserInteractionEnabled = false
                arrowImageView.isHidden = false
            }
        }
    }
    
    
    
    
}


//MARK: - 指示器View
class IndictorTitleView: LZView {
    let indictorView = UIView(color: .main)
    let titleLabel = UILabel(font: UIFont.font18.PF_Medium, textColor: .hex333333)
    lazy var stack = UIStackView(arrangedSubviews: [indictorView, titleLabel], spacing: 12, alignment: .center, distribution: .fill, axis: .horizontal)
    override func setupUI() {
        add(stack).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indictorView.cornerRadius = 1.5
        indictorView.snp.makeConstraints {
            $0.width.equalTo(3)
            $0.height.equalTo(23)
        }
    }
    
    convenience init(title: String) {
        self.init()
        self.titleLabel.text = title
    }

}
