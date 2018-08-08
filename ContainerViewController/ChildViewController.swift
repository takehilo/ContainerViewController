import UIKit

class ChildViewController: UIViewController {
    let childVC1: UIViewController = {
        let vc = GrandChildViewController()
        vc.view.backgroundColor = UIColor.gray
        return vc
    }()
    
    let childVC2: UIViewController = {
        let vc = GrandChildViewController()
        vc.view.backgroundColor = UIColor.yellow
        return vc
    }()
    
    lazy var currentChildVC = childVC1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        
        childVC1.view.addGestureRecognizer(tapGesture())
        childVC1.view.addGestureRecognizer(twoFingerTapGesture())
        childVC2.view.addGestureRecognizer(tapGesture())
        childVC2.view.addGestureRecognizer(twoFingerTapGesture())

        addChild()
    }

    func addChild() {
        // 1. VCの親子関係を設定
        addChildViewController(childVC1)

        // 2. 子のルートビューをコンテナ(self)のビュー階層に追加
        view.addSubview(childVC1.view)
        let origin = view.frame.origin
        let size = view.frame.size
        childVC1.view.frame = CGRect(x: origin.x + 50, y: origin.y + 50,
                                     width: size.width - 100, height: size.height - 100)

        // 4. 子のdidMove(toParentViewController:)を呼び出す
        childVC1.didMove(toParentViewController: self)
    }
    
    func tapGesture() -> UIGestureRecognizer {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.tapped(_:)))
        return gesture
    }
    
    func twoFingerTapGesture() -> UIGestureRecognizer {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTouchesRequired = 2
        gesture.addTarget(self, action: #selector(self.twoFingerTapped(_:)))
        return gesture
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        currentChildVC.willMove(toParentViewController: nil)
        currentChildVC.view.removeFromSuperview()
        currentChildVC.removeFromParentViewController()
    }
    
    @objc func twoFingerTapped(_ sender: UITapGestureRecognizer) {
        let oldVC = currentChildVC
        let newVC = toggleChildVC()
        oldVC.willMove(toParentViewController: nil)
        addChildViewController(newVC)
        
        newVC.view.frame = CGRect.zero

        transition(
            from: oldVC,
            to: newVC,
            duration: 0.25,
            animations: { () in
                newVC.view.frame = oldVC.view.frame
                oldVC.view.frame = CGRect.zero
            },
            completion: { [unowned self] isFinished in
                oldVC.removeFromParentViewController()
                newVC.didMove(toParentViewController: self)
            }
        )
    }
    
    func toggleChildVC() -> UIViewController {
        if currentChildVC === childVC1 {
            currentChildVC = childVC2
        } else {
            currentChildVC = childVC1
        }
        return currentChildVC
    }
}
