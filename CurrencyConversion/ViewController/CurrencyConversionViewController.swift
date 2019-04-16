//
//  CurrencyViewController.swift
//  CurrencyConversion
//
//  Created by javra on 4/11/19.
//  Copyright © 2019 javra. All rights reserved.
//

import UIKit

protocol CurrencySelectionDelegate {
    func currencySelected(_ code: String, _ country: String)
    func refreshData()
}


class CurrencyConversionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    var currency: Currency!
    var convesions:[String: Double] = [:]
    var codes:[String] = []
    var exchangeDate: String = Date().today()
    //#MARK:-
    //#MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currency =  Currency(code: "USD", country: Currencies.shared.items["USD"]!)
        self.dateBtn.setTitle(self.exchangeDate, for: .normal)
        self.dateBtn.isEnabled = false
        self.currencyBtn.setTitle(currency.title(), for: .normal)
        self.activityIndicator.isHidden = true
        makeRequest()
    }
   
    
    //#MARK:-
    //#MARK: General Methods
    
    func refreshConversionRates() {
        DispatchQueue.main.async {
            self.codes = Array(self.convesions.keys).sorted()
            self.tableView.reloadData()
        }
    }
    
    func showActivityIndicator(){
        DispatchQueue.main.async {
            self.currencyBtn.isEnabled = false
           
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    func dismissActivityIndicator(){
        DispatchQueue.main.async {
            self.currencyBtn.isEnabled = true
          
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
     func showAlertMessage(_ code: Int, message: String)  {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error \(code)", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }

    func makeRequest(){
        if let cachedConversions = ApiHandler.conversionFromCached(currency.code)  {
            //have cached data
            self.convesions = cachedConversions
            self.refreshConversionRates()
        }else{
            //no cached data
            
            guard let request = ApiHandler.asLiveRequest(.post, source: self.currency.code) else{
                print("Improper End Point")
                return
            }
            
            self.showActivityIndicator()
            ApiHandler.call(request: request, { (data) in
                self.dismissActivityIndicator()
                let response = data  as! [String: Any]
               
                let conversions = response[Constant.String.quotes] as! [String: Double]
                self.convesions = conversions
                ApiHandler.cachedConversion(for: self.currency.code, conversion: conversions)
                self.refreshConversionRates()
               
                
            }) { (error) in
                self.dismissActivityIndicator()
                self.showAlertMessage(error.code, message: error.localizedDescription)
            }
        }
        
        
    }
    
    //#MARK:-
    //#MARK: IBActions
    
    @IBAction func currencySelectHandler(_ sender: Any) {
        
        self.convesions = [:]
        self.codes = []
        self.tableView.reloadData()
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CurrenciesTableViewController") as! CurrenciesTableViewController
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = sender as! UIButton
        //popover.barButtonItem = (sender as! UIBarButtonItem)
        present(vc, animated: true, completion:nil)
        
    }
    
    @IBAction func dateSelectHandler(_ sender: Any) {
        makeRequest()
    }
    
}


//#MARK:-
//#MARK: CurrencySelectionDelegate

extension CurrencyConversionViewController: CurrencySelectionDelegate {
    func refreshData() {
        makeRequest()
    }
    
    func currencySelected(_ code: String, _ country: String) {
        
        self.currency = Currency(code: code, country: country)
        self.currencyBtn.setTitle(currency.title(), for: .normal)
    }
}

extension CurrencyConversionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.codes.count == 0 {
            let view = UIView(frame: tableView.bounds)
            let label = UILabel(frame: view.bounds)
            label.text = "No exchange rates available"
            label.textAlignment = .center
            view.addSubview(label)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.codes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath)
        let code = String(self.codes[indexPath.row].dropFirst(3))
        cell.textLabel?.text = String(format: "%@ = %f", code, self.convesions[self.codes[indexPath.row]]!)
        cell.detailTextLabel?.text = Currencies.shared.items[code]
        return cell
    }
    
    
}
