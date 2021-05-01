//
//  ViewController.swift
//  ExpensesInUIKit
//
//  Created by Grifus on 24.04.2021.
//

//some
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var worker = mainWork()
    
    
    @IBOutlet weak var labelForSum: UILabel!
    @IBOutlet weak var VStackForTotalSum: UIStackView!
    let tableId = "cell"
    @IBOutlet weak var tableForContent: UITableView!

    @IBOutlet weak var leftField: UITextField!
    @IBOutlet weak var rightField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableForContent.delegate = self
        tableForContent.dataSource = self
        leftField.delegate = self
        rightField.delegate = self
        tableForContent.layer.cornerRadius = 0
        worker.loadData()
        VStackForTotalSum.layer.cornerRadius = 10
        worker.sum(lable: labelForSum)
    }
    
    //скрыть клавиатуру при нажатии в любом месте
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    //скрытть клавиатуру при нажатии клавиши return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        leftField.resignFirstResponder()
        return true
    }
    
    //переопределение функции для количества ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worker.allDataInStruct.count
    }
    
    //переопределение функции для создания ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableForContent.dequeueReusableCell(withIdentifier: tableId, for: indexPath) as? MyCellTableViewCell {
            
            cell.nameOne.text = worker.allDataInStruct[indexPath.row].titleOfStruct
            cell.nameTwo.text = worker.allDataInStruct[indexPath.row].priceOfStruct

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

}

