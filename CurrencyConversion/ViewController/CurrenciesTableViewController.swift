//
//  CurrenciesTableViewController.swift
//  CurrencyConversion
//
//  Created by javra on 4/12/19.
//  Copyright © 2019 javra. All rights reserved.
//

import UIKit

class CurrenciesTableViewController: UITableViewController {
    
    var codes: [String] = []
    
    var delegate: CurrencySelectionDelegate!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.codes = Array(Currencies.shared.items.keys).sorted()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.codes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        let code = self.codes[indexPath.row]
        cell.textLabel?.text = code
        cell.detailTextLabel?.text = Currencies.shared.items[code]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let code = self.codes[indexPath.row]
         self.delegate.currencySelected(code, Currencies.shared.items[code]!)
        
        self.dismiss(animated: true) {
            self.delegate.refreshData()
        }
        
    }
    

}
