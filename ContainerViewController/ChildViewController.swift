import UIKit

class ChildViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green

        addChild()
    }

    func addChild() {
        let grandChildVC = GrandChildViewController()

        // 1. VCの親子関係を設定
        addChildViewController(grandChildVC)

        // 2. 子のルートビューをコンテナ(self)のビュー階層に追加
        view.addSubview(grandChildVC.view)
        // 3. ビュー階層に追加したら制約を追加
        grandChildVC.view.translatesAutoresizingMaskIntoConstraints = false
        grandChildVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        view.bottomAnchor.constraint(equalTo: grandChildVC.view.bottomAnchor, constant: 80).isActive = true
        grandChildVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
        view.trailingAnchor.constraint(equalTo: grandChildVC.view.trailingAnchor, constant: 80).isActive = true

        // 4. 子のdidMove(toParentViewController:)を呼び出す
        grandChildVC.didMove(toParentViewController: self)
    }
}
