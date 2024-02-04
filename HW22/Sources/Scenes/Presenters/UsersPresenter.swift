
import Foundation

class UsersPresenter {
    
    private let coreDataManager = CoreDaraManager.shared

    weak var view: PresenterView?

    init(view: PresenterView) {
        self.view = view
    }

    func createUser(name: String, phoneNumber: String?, dateOfBirth: Date?) {
        coreDataManager.createUser(name: name, phoneNumber: phoneNumber, dateOfBirth: dateOfBirth)
    }

    func updateUser(user: User, newName: String, newPhoneNumber: String, newDateOfBirth: Date) {
        coreDataManager.updateUser(user: user, newName: newName, newPhoneNumber: newPhoneNumber, newDateOfBirth: newDateOfBirth)
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
