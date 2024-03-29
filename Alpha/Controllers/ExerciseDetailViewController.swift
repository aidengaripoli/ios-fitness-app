//
//  ExerciseDetailViewController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 24/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit
import CoreData

class ExerciseDetailViewController: UIViewController {
    
    // MARK: - Properties

    var exerciseInstance: ExerciseInstance! {
        didSet {
            navigationItem.title = exerciseInstance.exercise?.name
        }
    }
    
    var model: Model!
    
    private var weightPickerView: UIPickerView!
    private var repsPickerView: UIPickerView!
    
    private var pickerViewToolBar: UIToolbar!
    
    private var activeTextField: UITextField?
    
    private let weightData = Array(0...250)
    private let repsData = Array(1...20)
    
    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Actions
    
    @IBAction func addSet(_ sender: UIBarButtonItem) {
        model.workoutStore.createSet(weight: 0, reps: 0, exerciseInstance: exerciseInstance)
        
        tableView.reloadData()
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        tableView.dataSource = self
        
        // weight pickerview init
        weightPickerView = UIPickerView()
        weightPickerView.tag = 1
        weightPickerView.backgroundColor = UIColor.white
        weightPickerView.accessibilityIdentifier = "weightPickerView"
        
        weightPickerView.dataSource = self
        weightPickerView.delegate = self
        
        // reps pickerview init
        repsPickerView = UIPickerView()
        repsPickerView.tag = 2
        repsPickerView.backgroundColor = UIColor.white
        repsPickerView.accessibilityIdentifier = "repsPickerView"
        
        repsPickerView.dataSource = self
        repsPickerView.delegate = self
        
        pickerViewToolBar = UIToolbar()
        pickerViewToolBar.barStyle = .default
        pickerViewToolBar.isTranslucent = true
        pickerViewToolBar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker(sender:)))

        pickerViewToolBar.setItems([spacer, doneButton], animated: true)
        pickerViewToolBar.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK: - Instance Methods

    @objc private func donePicker(sender: UIBarButtonItem) {
        activeTextField?.resignFirstResponder()
        activeTextField = nil
    }
    
}

// MARK: - Extension TableViewDataSource

extension ExerciseDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseInstance.sets!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseSetCell", for: indexPath) as! ExerciseSetCell
        
        cell.weightField.delegate = self
        cell.weightField.tag = indexPath.row
        cell.weightField.inputView = weightPickerView
        cell.weightField.inputAccessoryView = pickerViewToolBar
        
        cell.repsField.delegate = self
        cell.repsField.tag = indexPath.row
        cell.repsField.inputView = repsPickerView
        cell.repsField.inputAccessoryView = pickerViewToolBar
        
        let setsArray = exerciseInstance.sets?.allObjects as! [ExerciseSet]

        cell.setLabel.text = "\(indexPath.row + 1)"
        cell.weightField.text = "\(setsArray[indexPath.row].weight) kgs"
        cell.repsField.text = "\(setsArray[indexPath.row].reps) reps"
        
        return cell
    }
    
}

// MARK: - Extension CollectionViewDataSource

extension ExerciseDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exerciseInstance.exercise!.muscles!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseMuscleCell", for: indexPath) as! ExerciseMuscleCell
    
        // convert relationship to array and display mucles
        let muscles = exerciseInstance.exercise?.muscles?.allObjects as! [Muscle]
        
        cell.nameLabel.text = muscles[indexPath.row].name?.capitalized
        
        return cell
    }
    
}

// MARK: - Extension PickerViewDataSoure

extension ExerciseDetailViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 1 ? weightData.count : repsData.count
    }
    
}

// MARK: - Extension PickerViewDelegate

extension ExerciseDetailViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 1 ? "\(weightData[row]) kgs" : "\(repsData[row]) reps"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let currentTextField = activeTextField {
            let setsArray = exerciseInstance.sets?.allObjects as! [ExerciseSet]
            
            if pickerView.tag == 1 {
                currentTextField.text = "\(weightData[row]) kgs"
                
                setsArray[currentTextField.tag].weight = Int32(weightData[row])

                model.workoutStore.save()
            } else {
                currentTextField.text = "\(repsData[row]) reps"
                setsArray[currentTextField.tag].reps = Int32(repsData[row])
                
                model.workoutStore.save()
            }
        }
    }
    
}

// MARK: - Extension TextFieldDelegate

extension ExerciseDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        
        return true
    }
    
}
