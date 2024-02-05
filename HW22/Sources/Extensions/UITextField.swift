

import UIKit

extension UITextField {
    func setInputPicker(target: Any, selector: Selector) {

        let widthScreen = UIScreen.main.bounds.width

        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 200))
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        self.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 44))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: selector)

        toolBar.setItems([flexible, barButton], animated: true)
        self.inputAccessoryView = toolBar
    }
}
