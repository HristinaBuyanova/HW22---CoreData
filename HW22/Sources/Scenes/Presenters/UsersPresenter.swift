
import Foundation

class UsersPresenter {
    
    private let coreDataManager = CoreDaraManager.shared

    weak var view: PresenterView?

    init(view: PresenterView) {
        self.view = view
    }

    func createUser(name: String, gender: String?, dateOfBirth: Date?) {
        coreDataManager.createUser(name: name, gender: gender, dateOfBirth: dateOfBirth)
    }

    func updateUser(user: User, newName: String, newGender: String, newDateOfBirth: Date) {
        coreDataManager.updateUser(user: user, newName: newName, newGender: newGender, newDateOfBirth: newDateOfBirth)
    }

    func deleteUser(user: User) {
        coreDataManager.deleteUser(user: user)
    }

    func presentUsers() {
        self.view?.fetch(usersData: coreDataManager.fetchAllUser())
    }
}

protocol PresenterView: AnyObject {
    func fetch(usersData: [User])
}
