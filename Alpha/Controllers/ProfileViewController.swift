//
//  ProfileViewController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 27/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var agePickerView: UIPickerView!
    var heightPickerView: UIPickerView!
    var weightPickerView: UIPickerView!
    
    var pickerViewToolBar: UIToolbar!
    
    var activeTextField: UITextField?
    
    var ageData = Array(13...99)
    var heightData = Array(50...200)
    var weightData = Array(30...300)
    
    // MARK: - Outlets
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var ageField: UITextField!
    
    @IBOutlet var heightField: UITextField!
    
    @IBOutlet var weightField: UITextField!
    
    // MARK: - Actions
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // age pickerview init
        agePickerView = UIPickerView()
        agePickerView.tag = 1
        agePickerView.backgroundColor = UIColor.white
        agePickerView.accessibilityIdentifier = "agePickerView"
        
        agePickerView.dataSource = self
        agePickerView.delegate = self
        
        // reps pickerview init
        heightPickerView = UIPickerView()
        heightPickerView.tag = 2
        heightPickerView.backgroundColor = UIColor.white
        heightPickerView.accessibilityIdentifier = "heightPickerView"
        
        heightPickerView.dataSource = self
        heightPickerView.delegate = self
        
        // weight pickerview init
        weightPickerView = UIPickerView()
        weightPickerView.tag = 3
        weightPickerView.backgroundColor = UIColor.white
        weightPickerView.accessibilityIdentifier = "weightPickerView"
        
        weightPickerView.dataSource = self
        weightPickerView.delegate = self
        
        pickerViewToolBar = UIToolbar()
        pickerViewToolBar.barStyle = .default
        pickerViewToolBar.isTranslucent = true
        pickerViewToolBar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker(sender:)))
        
        pickerViewToolBar.setItems([spacer, doneButton], animated: true)
        pickerViewToolBar.isUserInteractionEnabled = true
        
        ageField.delegate = self
        ageField.inputView = agePickerView
        ageField.inputAccessoryView = pickerViewToolBar
        
        heightField.delegate = self
        heightField.inputView = heightPickerView
        heightField.inputAccessoryView = pickerViewToolBar
        
        weightField.delegate = self
        weightField.inputView = weightPickerView
        weightField.inputAccessoryView = pickerViewToolBar
    }
    
    // MARK: - Instance Methods
    
    @objc func donePicker(sender: UIBarButtonItem) {
        activeTextField?.resignFirstResponder()
        activeTextField = nil
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension PickerViewDataSoure

extension ProfileViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return ageData.count
        case 2:
            return heightData.count
        case 3:
            return weightData.count
        default:
            return 0
        }
    }
    
}

// MARK: - Extension PickerViewDelegate

extension ProfileViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return "\(ageData[row])"
        case 2:
            return "\(heightData[row]) cms"
        case 3:
            return "\(weightData[row]) kgs"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let currentTextField = activeTextField {
            switch pickerView.tag {
            case 1:
                currentTextField.text = "\(ageData[row])"
            case 2:
                currentTextField.text = "\(heightData[row]) cms"
            case 3:
                currentTextField.text = "\(weightData[row]) kgs"
            default:
                currentTextField.text = ""
            }
        }
    }
    
}

// MARK: - Extension TextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        
        return true
    }
    
}
