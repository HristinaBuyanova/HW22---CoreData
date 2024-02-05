

import UIKit
import CoreData

public final class CoreDaraManager: NSObject {

    public  static let shared = CoreDaraManager()

    private override init() {}

    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    private var contex: NSManagedObjectContext {
        appDelegate.persistantContainer.viewContext
    }

    public func createUser(name: String, gender: String?, dateOfBirth: Date?) {
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: contex) else { return }
        let user = User(entity: userEntityDescription, insertInto: contex)
        user.name = name
        user.gender = gender
        user.dateOfBirth = dateOfBirth

        appDelegate.saveContex()
    }

    public func fetchAllUser() -> [User] {
        do {
            return try contex.fetch(User.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
        return [User()]
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        do {
//            return try contex.fetch(fetchRequest) as! [User]
//        } catch {
//            print(error.localizedDescription)
//        }
//        return []
    }

    public func fetchUser(_ name: String) -> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let users = try? contex.fetch(fetchRequest) as? [User]
            return users?.first(where: { $0.name == name })
        }
    }

    public func updateUser(user: User,
                           newName: String,
                           newGender: String,
                           newDateOfBirth: Date) {
        user.name = newName
        user.gender = newGender
        user.dateOfBirth = newDateOfBirth

        do {
            try contex.save()
        } catch {
            print(error)
        }
    }

    public func deleteUser(user: User) {
        contex.delete(user)

        do {
            try contex.save()
        } catch {
            print(error)
        }
    }


}
