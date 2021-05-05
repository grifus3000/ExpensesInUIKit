//
//  ViewController.swift
//  ExpensesInUIKit
//
//  Created by Grifus on 24.04.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    var worker = mainWork()
    
    var dataForTable: [SuperStract] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelForSum: UILabel!
    @IBOutlet weak var VStackForTotalSum: UIStackView!
    let tableId = "cell"
    @IBOutlet weak var tableForContent: UITableView!

    @IBOutlet weak var leftField: UITextField!
    @IBOutlet weak var rightField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableForContent.delegate = self
        tableForContent.dataSource = self
        
        leftField.delegate = self
        rightField.delegate = self
        
        tableForContent.layer.cornerRadius = 0
        
        worker.loadData()
        
        VStackForTotalSum.layer.cornerRadius = 10
        
        worker.sum(lable: labelForSum)
        
        dataToNewVar()
    }
    
    func dataToNewVar() {
        dataForTable = worker.structData
    }
    
    //скрыть клавиатуру при нажатии в любом месте
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    //скрыть клавиатуру при нажатии клавиши return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        leftField.resignFirstResponder()
        return true
    }
    
    //переопределение функции для количества ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForTable.count
    }
    
    //переопределение функции для создания ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableForContent.dequeueReusableCell(withIdentifier: tableId, for: indexPath) as? MyCellTableViewCell {
            
            cell.nameOne.text = dataForTable[indexPath.row].titleOfStruct
            cell.nameTwo.text = dataForTable[indexPath.row].priceOfStruct

        return cell
        }
        return UITableViewCell()
    }
    
    //переопределение функции для возможности удаления ячеек
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //убираем выделение ячейки цветом при выборе
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    //вызов алерта на редактирование ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(worker.alertFunc(index: indexPath.row, view: self) , animated: true, completion: nil)
    }
    
    //удаление ячеек
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            worker.deleteItem(index: indexPath.row, view: self, indexP: indexPath)
            worker.sum(lable: labelForSum)

        }
    }
    
    //кнопка "добавить"
    @IBAction func addItemButton(_ sender: Any) {
        if worker.onlyNumbers(str: rightField.text ?? "") {
            worker.addToStruct(title: leftField.text!, price: rightField.text!)
            worker.saveData(view: self, forDelete: false)
            leftField.text = ""
            rightField.text = ""
        } else {
            let alert = UIAlertController(title: nil, message: "You should only enter numbers", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
    }
        worker.sum(lable: labelForSum)
    }
    
    //переопределяем метод для поиска в SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let data = worker.structData
        //записываем данные, которые будут в таблице, после ввода символов
        dataForTable = searchText.isEmpty ? data : data.filter({ (dataString) -> Bool in
            return dataString.titleOfStruct.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableForContent.reloadData()
    }
    
}

