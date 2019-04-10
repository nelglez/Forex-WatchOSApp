//
//  ExchangeRateDetailInterfaceController.swift
//  Forex-WatchOS Extension
//
//  Created by Nelson Gonzalez on 4/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import WatchKit
import Foundation
import ForexCore


class ExchangeRateDetailInterfaceController: WKInterfaceController {
    @IBOutlet weak var exchangeRateLabel: WKInterfaceLabel!
    @IBOutlet weak var historyImage: WKInterfaceImage!
    
    private let fetcher = ExchangeRateFetcher()
    private var exchangeRate: ExchangeRate? {
        didSet {
            updateViews()
        }
    }
    
    private let currencyFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        result.maximumFractionDigits = 2
        result.minimumIntegerDigits = 1
        return result
    }()
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        //Fetch the symbol that we tap on from the cell
        //Which symbol did we tap on?
        
        let symbol = context as! String
        
        setTitle(symbol)
        
        //Fetch the exchange rates
        fetcher.fetchCurrentExchangeRate(for: symbol) { (rate, error) in
            if let error = error {
                print("Error fetching exchange rate: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.exchangeRate = rate
            }
        }
        
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        var components = DateComponents()
        components.calendar = calendar
        components.year = -1
        let aYearAgo = calendar.date(byAdding: components, to: now)!
        
        fetcher.fetchExchangeRates(startDate: aYearAgo, symbols: [symbol]) { (rates, error) in
            if let error = error {
                print("Error fetching exchange rate for:\(symbol): \(error.localizedDescription)")
                return
            }
            guard let rates = rates else {return}
            let renderer = RateHistoryRenderer(exchangeRates: rates)
            let graphImage = renderer?.image(with: CGSize(width: 300, height: 300))
            
            
            DispatchQueue.main.async {
                self.historyImage.setImage(graphImage)
            }
        }
        
    }

    private func updateViews() {
        guard let exchangeRate = exchangeRate else {return}
        
        let rateString = currencyFormatter.string(from: exchangeRate.rate as NSNumber) ?? "N/A"
        
        let rateLabelText = "\(rateString) \(exchangeRate.symbol) = 1 \(exchangeRate.base)"
        
        exchangeRateLabel.setText(rateLabelText)
        
    }
   

}
