//
//  CurrenciesTableInterfaceController.swift
//  Forex-WatchOS Extension
//
//  Created by Nelson Gonzalez on 4/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import WatchKit
import Foundation


class CurrenciesTableInterfaceController: WKInterfaceController {

    @IBOutlet weak var currencyTable: WKInterfaceTable!
    
    private let symbols = ["BGN",
                           "CAD",
                           "BRL",
                           "HUF",
                           "DKK",
                           "JPY",
                           "ILS",
                           "TRY",
                           "RON",
                           "GBP",
                           "PHP",
                           "HRK",
                           "NOK",
                           "USD",
                           "MXN",
                           "AUD",
                           "IDR",
                           "KRW",
                           "HKD",
                           "ZAR",
                           "ISK",
                           "CZK",
                           "THB",
                           "MYR",
                           "NZD",
                           "PLN",
                           "SEK",
                           "RUB",
                           "CNY",
                           "SGD",
                           "CHF",
                           "INR"].sorted()
    
    //ViewDidLoad of interfaceController
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
       //"pulling info is how we are used to in UITableView to get info.
        
        //WKInterfaceTables use a "push" info onto the WKInterfacetable
        //The type should say "row"
        //This takes  the place of number of rows in section.
        currencyTable.setNumberOfRows(symbols.count, withRowType: "currencyRow")
        
        //tell each row what should be displayed.
        //Loop through sybmol and pass one to one row that it corresponds to.
        
        
        for (index, symbol) in symbols.enumerated() {
            
            let rowController = currencyTable.rowController(at: index) as! CurrencyRowController
            
            rowController.symbol = symbol
        }
        
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        //return the thing you would like to pass to the new interface controller
        return symbols[rowIndex]
    }

    //View WIll Appear
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
//ViewDidDisappear
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
