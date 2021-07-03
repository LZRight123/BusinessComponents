////
////  SourceVC.swift
////  BusinessDeer
////
////  Created by 梁泽 on 2021/3/23.
////
//
//import UIKit
//import IQKeyboardManagerSwift
//
//public class SourceVC: UIViewController {
//    lazy var tableView = UITableView(style:.plain).then {
//        $0.dataSource = self
//        $0.delegate = self
//        $0.register(CaijiBaseCell.self)
//    }
//
//    lazy var stack = UIStackView(arrangedSubviews: [tableView], spacing: 10, alignment: .fill, distribution: .fill, axis: .vertical)
//
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "BusinessDeer模块"
//
//
//        view.add(stack).snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//
//        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
//        IQKeyboardManager.shared.toolbarPreviousBarButtonItemText = "上一题"
//        IQKeyboardManager.shared.toolbarNextBarButtonItemText = "下一题"
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
//        rx.viewWillAppear
//            .subscribe(onNext: { _ in
//                IQKeyboardManager.shared.enable = true
//            })
//            .disposed(by: disposeBag)
//
//        rx.viewWillDisappear
//            .subscribe(onNext: { _ in
//                IQKeyboardManager.shared.enable = false
//            })
//            .disposed(by: disposeBag)
//    }
//
//
//
//
//
//
//
//
//}
//
//
////MARK: - UITableViewDataSource, UITableViewDelegate
//extension SourceVC: UITableViewDataSource, UITableViewDelegate {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withClass: CaijiBaseCell.self)
//        var arr = [CaijiITemModel]()
//        for _ in 0...20 {
//            var m = CaijiITemModel()
//            m.key =  .random(ofLength: 6)
//            m.value = .random(ofLength: 5)
//            m.style = .左标题_请选择_右箭头
//            arr.append(m)
//        }
//
//        cell.bind(arr)
//        return cell
//
//    }
//}
//
//
//
