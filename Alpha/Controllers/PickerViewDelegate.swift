//
//  weightPickerViewDelegate.swift
//  Alpha
//
//  Created by Aiden Garipoli on 26/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class PickerViewDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var data: [String]
    
    var textField: UITextField!
    
    init(data: [String]) {
        self.data = data
        super.init()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Component: \(component) selected. Row: \(row) selected")
        textField.text = data[row]
    }
    
}
