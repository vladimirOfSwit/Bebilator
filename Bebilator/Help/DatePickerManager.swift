//
//  DatePickerManager.swift
//  Bebilator
//
//  Created by Vladimir Savic on 10.10.24..
//

import UIKit

class DatePickerManager: UIView {
    private let datePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    var onDateSelected: ((String) -> Void)?
    
    func setupDatePicker(for textFields: [UITextField], view: UIView, target: Any) {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        datePicker.setValue(UIColor.black, forKey: "textColor")
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Gotovo", style: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: true)
        
        for textField in textFields {
            textField.inputAccessoryView = toolBar
            textField.inputView = datePicker
        }
    }
    
    func configureDatePicker(for textField: UITextField) {
        if textField.tag == 1 {
            datePicker.maximumDate = nil
        } else if textField.tag == 2 {
            datePicker.maximumDate = Date()
        } else if textField.tag == 3 {
            datePicker.date = Date()
            datePicker.minimumDate = Date()
        }
    }
    
    @objc func donePressed() {
        let selectedDate = datePicker.date
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        onDateSelected?(formattedDate)
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
