
import UIKit

class MainViewController: UIViewController {

    var users = [User]()
//    var presenter = Presenter?

//    MARK: - Outlets
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .lightGray
        textField.textColor = .systemGray
        textField.placeholder = "Print your name here"
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var pressButton: UIButton = {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

    }


}

