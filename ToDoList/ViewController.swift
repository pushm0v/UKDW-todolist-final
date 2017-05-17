//
//  ViewController.swift
//  ToDoList
//
//  Created by Bherly Novrandy on 5/1/17.
//  Copyright © 2017 Bherly Novrandy. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    
    var arrayData: [JSON] = []
    var dataToSave: JSON?
    let networkService: NetworkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        self.buttonSave.addTarget(self, action: #selector(ViewController.doSave), for: .touchUpInside)
        self.fetchData()
    }

    func fetchData() {
        networkService.getTodoList(success: { results in
            self.arrayData = results
            self.myTableView.reloadData()
        }, failure: { error in
            self.showAlert(title: "Error", message: error)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell {
            let data = arrayData[indexPath.row]
            
            if let name = data["name"].string {
                cell.myCustomLabel.text = name
            }
            cell.customButton.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
            
            cell.customButton.addTarget(self, action: #selector(ViewController.editTodo), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(ViewController.deleteTodo), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editTodo(sender: UIButton) {
        let rowNumber = sender.tag
        self.dataToSave = self.getDataFromArray(rowNumber: rowNumber)
        
        if let data = self.dataToSave, let name = data["name"].string {
            self.textField.text = name
            self.buttonSave.setTitle("Save", for: .normal)
        }
    }
    
    func deleteTodo(sender: UIButton) {
        let rowNumber = sender.tag
        let data = self.getDataFromArray(rowNumber: rowNumber)
        if let id = data["id"].int {
            self.networkService.deleteTodoList(id: id, success: { _ in
                self.showAlert(title: "Success", message: "Data has been deleted!")
                self.resetForm()
            }, failure: { error in
                self.showAlert(title: "Error", message: error)
            })
        }
    }
    
    func getDataFromArray(rowNumber: Int) -> JSON {
        let data = self.arrayData[rowNumber]
        
        return data
    }
    
    func resetForm() {
        self.dataToSave = nil
        self.buttonSave.setTitle("Submit", for: .normal)
        self.textField.text = ""
        self.fetchData()
    }
    
    func doSave() {
        if let title = self.buttonSave.title(for: .normal) {
            if title == "Save" {
                if let data = self.dataToSave, let id = data["id"].int, let name = self.textField.text {
                   self.networkService.putTodoList(id: id, name: name, success: { _ in
                    self.showAlert(title: "Success", message: "Data has been updated!")
                    self.resetForm()
                   }, failure: { error in
                        self.showAlert(title: "Error", message: error)
                   })
                }
            }
            else if title == "Submit" {
                if let name = self.textField.text {
                    self.networkService.postTodoList(name: name, success: { _ in
                        self.showAlert(title: "Success", message: "Data has been created!")
                        self.resetForm()
                    }, failure: { error in
                        self.showAlert(title: "Error", message: error)
                    })
                }
            }
        }
    }
    
}
