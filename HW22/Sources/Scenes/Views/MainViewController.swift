
import UIKit

class MainViewController: UIViewController {

    var users = [User]()
    var presenter: UsersPresenter?

    //    MARK: - Outlets
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .lightGray
        textField.textColor = .systemGray
        textField.placeholder = "Print name user here"
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var pressButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.setTitle("Add user", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonCreateUserPress), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = UsersPresenter(view: self)
        presenter?.presentUsers()

    }

    // MARK: - Actions
    @objc
    private func buttonCreateUserPress(_ sender: UIButton) {

        guard let userName = textField.text, !userName.isEmpty else {
            let alert = UIAlertController(title: "Name not entered", message: "Enter name", preferredStyle: .alert)

            let saveNewUser = UIAlertAction(title: "Add", style: .default) { action in
                let tfName = alert.textFields?.first
                tfName?.placeholder = "Name"
                if let task = tfName?.text {
                    self.presenter?.createUser(name: task, phoneNumber: nil, dateOfBirth: nil)
                    self.tableView.reloadData()
                }
                alert.addTextField()

                let cancelAction = UIAlertAction(title: "Cancel", style: .default)

                alert.addAction(saveNewUser)
                alert.addAction(cancelAction)

                self.present(alert, animated: true, completion: nil)
            }
        }

        presenter?.createUser(name: userName, phoneNumber: nil, dateOfBirth: nil)
        presenter?.presentUsers()
        textField.text = ""
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

    // MARK: - Extension

    extension MainViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            <#code#>
        }


    }

    extension MainViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            <#code#>
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            <#code#>
        }


    }

extension MainViewController: PresenterView {
    func fetch(usersData: [User]) {
        users = usersData
    }
}


