
import UIKit

class DetailViewController: UIViewController, PresenterView {

    var presenter: UsersPresenter?
    var selectedUser: User?
    var isEditingMode = false
    let genders = ["Male", "Female", "Other"]
    var selectGender: String?


    func fetch(usersData: [User]) {

    }
    
    //    MARK: - Outlets
    private lazy var imageUser: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.artframe")
        image.tintColor = .darkGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var nameImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.fill")
        image.tintColor = .blue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var name: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private lazy var dateOfBirthImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "calendar")
        image.tintColor = .blue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var dateOfBirth: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "unknown"
        return tf
    }()

    private lazy var genderImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "figure.dress.line.vertical.figure")
        image.tintColor = .blue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var gender: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "unknown"
        return tf
    }()

    private lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        backButton()
        editButton()
        hideKeyboard()
        disableTextFieldInteraction()
        userInfo()
        presenter = UsersPresenter(view: self)
        setPicker()
    }

//    MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    private func setupHierarchy() {
        view.addSubview(imageUser)
        view.addSubview(nameImage)
        view.addSubview(name)
        view.addSubview(dateOfBirthImage)
        view.addSubview(dateOfBirth)
        view.addSubview(genderImage)
        view.addSubview(gender)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageUser.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageUser.widthAnchor.constraint(equalToConstant: 100),
            imageUser.heightAnchor.constraint(equalToConstant: 100),
            imageUser.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameImage.topAnchor.constraint(equalTo: imageUser.bottomAnchor, constant: 30),
            nameImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameImage.widthAnchor.constraint(equalToConstant: 25),
            nameImage.heightAnchor.constraint(equalToConstant: 25),

            name.leadingAnchor.constraint(equalTo: nameImage.leadingAnchor, constant: 35),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            name.heightAnchor.constraint(equalToConstant: 25),
            name.topAnchor.constraint(equalTo: nameImage.topAnchor),

            dateOfBirthImage.topAnchor.constraint(equalTo: nameImage.bottomAnchor, constant: 30),
            dateOfBirthImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateOfBirthImage.widthAnchor.constraint(equalToConstant: 25),
            dateOfBirthImage.heightAnchor.constraint(equalToConstant: 25),

            dateOfBirth.leadingAnchor.constraint(equalTo: dateOfBirthImage.leadingAnchor, constant: 35),
            dateOfBirth.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateOfBirth.heightAnchor.constraint(equalToConstant: 25),
            dateOfBirth.topAnchor.constraint(equalTo: dateOfBirthImage.topAnchor),

            genderImage.topAnchor.constraint(equalTo: dateOfBirthImage.bottomAnchor, constant: 30),
            genderImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderImage.widthAnchor.constraint(equalToConstant: 25),
            genderImage.heightAnchor.constraint(equalToConstant: 25),

            gender.leadingAnchor.constraint(equalTo: genderImage.leadingAnchor, constant: 35),
            gender.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gender.heightAnchor.constraint(equalToConstant: 25),
            gender.topAnchor.constraint(equalTo: genderImage.topAnchor)
        ])
    }

    private func disableTextFieldInteraction() {
        name.isUserInteractionEnabled = false
        dateOfBirth.isUserInteractionEnabled = false
        gender.isUserInteractionEnabled = false
    }

    private func enableTextFieldInteraction() {
        name.isUserInteractionEnabled = true
        dateOfBirth.isUserInteractionEnabled = true
        gender.isUserInteractionEnabled = true
    }

    private func userInfo() {
        name.text = selectedUser?.name
        dateOfBirth.text = formatToString(date: selectedUser?.dateOfBirth ?? Date())
        gender.text = selectedUser?.gender
    }

    private func setPicker() {
        dateOfBirth.setInputPicker(target: self, selector: #selector(setDate))
        setInputGenderPicker(target: self, selector: #selector(genderButton))
    }

    private func backButton() {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backAction(sender:)))
        button.tintColor = .systemGray
        button.imageInsets = UIEdgeInsets(top: 2, left: -8, bottom: 0, right: 0)
        button.customView?.transform = CGAffineTransformMakeScale(100, 100)
        navigationItem.leftBarButtonItem = button
    }

    private func editButton() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 88, height: 44))
        customView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editAction))
        customView.addGestureRecognizer(tapGesture)
        customView.layer.cornerRadius = 20
        customView.layer.borderWidth = 2
        customView.layer.borderColor = UIColor.gray.cgColor

        let label = UILabel(frame: CGRect(x: 17, y: 10, width: 50, height: 20))
        label.text = "Edit"
        label.textAlignment = .center
        customView.addSubview(label)

        if isEditingMode {
            label.text = "Save"
            customView.backgroundColor = .green
            enableTextFieldInteraction()
        } else {
            label.text = "Edit"
            disableTextFieldInteraction()
        }

        let editButton = UIBarButtonItem(customView: customView)
        navigationItem.rightBarButtonItem = editButton
    }

    private func formatToString(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        dateFormatter.dateStyle = .medium
        let formattedData = dateFormatter.string(from: date)
        return formattedData
    }

    private func formatTodata(stringDate: String) -> Date? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "dd MMM yyyy"

        if let date = inputDateFormatter.date(from: stringDate) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

            _ = outputDateFormatter.string(from: date)
            return date
        } else {
            print("Error")
        }
        return Date()
    }

    private func setInputGenderPicker(target: Any, selector: Selector) {
        let widthScreen = UIScreen.main.bounds.width
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 44))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: true)
        gender.inputAccessoryView = toolBar
        gender.inputView = genderPicker
    }

    @objc
    func setDate() {
        if let datePicker = self.dateOfBirth.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yyyy"
            dateFormatter.dateStyle = .medium
            self.dateOfBirth.text = dateFormatter.string(from: datePicker.date)
        }
        self.dateOfBirth.resignFirstResponder()
    }

    @objc
    func backAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func editAction(sender: UIGestureRecognizer) {
        if isEditingMode {
            guard let selectedUser = selectedUser,
                    let newName = name.text,
                    !newName.isEmpty,
                  let newDateOfBirth = dateOfBirth.text
            else { return }
            self.presenter?.updateUser(user: selectedUser, newName: newName, newGender: gender.text ?? "Not", newDateOfBirth: formatTodata(stringDate: newDateOfBirth) ?? Date())
        }
        isEditingMode.toggle()
        editButton()
    }
}


extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        genders.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectGender = genders[row]
    }

    @objc
    func genderButton() {
        let selectIndex = genderPicker.selectedRow(inComponent: 0)
        gender.text = genders[selectIndex]
        gender.resignFirstResponder()
        view.endEditing(true)
    }
}
