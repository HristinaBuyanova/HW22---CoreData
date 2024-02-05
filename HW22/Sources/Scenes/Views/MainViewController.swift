
import UIKit

class MainViewController: UIViewController {

    var users = [User]()
    var presenter: UsersPresenter?

    //    MARK: - Outlets
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 20
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

//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        hideKeyboard()
        presenter = UsersPresenter(view: self)
        presenter?.presentUsers()

    }

//    MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupHierarchy() {
        view.addSubview(textField)
        view.addSubview(pressButton)
        view.addSubview(tableView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 100),

            pressButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            pressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            pressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            pressButton.heightAnchor.constraint(equalToConstant: 42),
//            pressButton.widthAnchor.constraint(equalToConstant: 100),

            tableView.topAnchor.constraint(equalTo: pressButton.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    // MARK: - Actions
    @objc
    private func buttonCreateUserPress(_ sender: UIButton) {

        guard let userName = textField.text, !userName.isEmpty else {
            let alert = UIAlertController(title: "Attention", message: "To add a user, enter a name in the field and click on the button.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            self.present(alert, animated: true)
            return
        }

        let gender = ""
        presenter?.createUser(name: userName, gender: gender, dateOfBirth: nil)
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
            tableView.deselectRow(at: indexPath, animated: true)
            let detail = DetailViewController()
            detail.name.text = users[indexPath.row].name
            detail.selectedUser = users[indexPath.row]
            self.navigationController?.pushViewController(detail, animated: true)
        }

        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let delete = UIContextualAction(style: .destructive, title: "delete") { action, view, completion in
                self.presenter?.deleteUser(user: self.users[indexPath.row])
                self.presenter?.presentUsers()

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                completion(true)
            }
            let swipe = UISwipeActionsConfiguration(actions: [delete])
            swipe.performsFirstActionWithFullSwipe = false
            return swipe
        }


    }

    extension MainViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            users.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            cell.textLabel?.text = users[indexPath.row].name
            return cell
        }

    }

extension MainViewController: PresenterView {
    func fetch(usersData: [User]) {
        users = usersData
    }
}


