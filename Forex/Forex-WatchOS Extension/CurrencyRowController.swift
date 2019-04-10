//
//  CurrencyRowController.swift
//  Forex-WatchOS Extension
//
//  Created by Nelson Gonzalez on 4/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import WatchKit

//This is the parallel to a "UITableViewCell" though its just a subclass of NSObject.

class CurrencyRowController: NSObject {

    @IBOutlet weak var symbolLabel: WKInterfaceLabel!
    
    var symbol: String? {
        didSet {
            symbolLabel.setText(symbol)
        }
    }
    
}
