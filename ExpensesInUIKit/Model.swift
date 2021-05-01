//
//  Model.swift
//  ExpensesInUIKit
//
//  Created by Grifus on 25.04.2021.
//

import Foundation
import UIKit

struct SuperStract: Codable, Hashable {
    var titleOfStruct: String
    var priceOfStruct: String
    var id: Int
}

class mainWork: ObservableObject {
    var allDataInStruct: [SuperStract] = []
    var fileName = "fileOfStructData.json"
    var changedTitle = ""

    func sum(lable: UILabel) {
        var sum = 0
        for i in allDataInStruct {
            sum = sum + Int(i.priceOfStruct)!
        }
        lable.text = String(sum)
    }
    
    func updateTable(view: ViewController) {
        view.tableForContent.reloadData()
    }
    
    func addToStruct(title: String, price: String) {
        allDataInStruct.append(SuperStract(titleOfStruct: title, priceOfStruct: price, id: allDataInStruct.count))
    }
    
    func deleteItem(index: Int, view: ViewController, indexP: IndexPath) {
        allDataInStruct.remove(at: index)
        for i in 0..<allDataInStruct.count {
            allDataInStruct[i].id = i
        }
        view.tableForContent.deleteRows(at: [indexP], with: .automatic)
        saveData(view: view, forDelete: true)
    }
    
    func onlyNumbers(str: String) -> Bool {
        let newStr = str.filter { $0.isNumber }
        if str == newStr && str != "" {
            return true
        }
        return false
    }
    
    func saveData(view: ViewController, forDelete: Bool) {
        let dirUrl = FileManager.default.temporaryDirectory
        let fileUrl = dirUrl.appendingPathComponent(fileName)
        let json = try? JSONEncoder().encode(allDataInStruct)
        do {
            try json!.write(to: fileUrl)
        } catch {
            print("can't write data in file")
        }
        if !forDelete {
            updateTable(view: view)
        }
    }
    
    func loadData() {
        let dirUrl = FileManager.default.temporaryDirectory
        let fileUrl = dirUrl.appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            let some = ""
            let json = try? JSONEncoder().encode(some)
            do {
                try json!.write(to: fileUrl)
            } catch {
                print("can't write data in file")
            }
        }
        let data = try? Data(contentsOf: fileUrl, options: [])
        guard let array = try? JSONDecoder().decode([SuperStract].self, from: data!) else {return}
        allDataInStruct = array
    }
    
    func alertFunc(index: Int, view: ViewController) -> UIAlertController {
        let alert = UIAlertController(title: "Change values", message: "", preferredStyle: .alert)
    
        alert.addTextField { textField in
            textField.text = self.allDataInStruct[index].titleOfStruct
        }
        alert.addTextField { textField in
            textField.text = self.allDataInStruct[index].priceOfStruct
        }
        
        alert.textFields?[1].keyboardType = .phonePad
        
        let change = UIAlertAction(title: "Change", style: .default) { _ in
            if self.onlyNumbers(str: alert.textFields?[1].text ?? "") {
                self.allDataInStruct[index].titleOfStruct = alert.textFields?[0].text ?? ""
                self.allDataInStruct[index].priceOfStruct = alert.textFields?[1].text ?? ""
                self.saveData(view: view, forDelete: false)
            } else {
                
            }
            self.sum(lable: view.labelForSum)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        
        alert.addAction(change)
        alert.addAction(cancel)
        
        return alert
    }
    
}
