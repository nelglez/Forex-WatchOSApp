//
//  TodayViewController.swift
//  ForexWidget
//
//  Created by Andrew R Madsen on 10/22/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import NotificationCenter
import ForexCore

class TodayViewController: UIViewController, NCWidgetProviding {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        fetcher.fetchCurrentExchangeRate(for: symbol) { (rate, error) in
            if let error = error {
                NSLog("Error fetching current exchange rate for \(self.symbol): \(error)")
                completionHandler(NCUpdateResult.failed)
                return
            }
            guard let rate = rate else {
                completionHandler(NCUpdateResult.failed)
                return
            }
            
            self.updateLabel(with: rate)
        }
        
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        var components = DateComponents()
        components.calendar = calendar
        components.year = -1
        let aYearAgo = calendar.date(byAdding: components, to: now)!
        
        fetcher.fetchExchangeRates(startDate: aYearAgo, symbols: [symbol]) { (rates, error) in
            if let error = error {
                NSLog("Error fetching exchange rates: \(error)")
                return
            }
            self.rates = rates ?? []
        }
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = maxSize
            self.rateHistoryView.isHidden = true
        case .expanded:
            preferredContentSize = CGSize(width: maxSize.width, height: 200)
            self.rateHistoryView.isHidden = false
        }
    }
    
    // MARK: - Private
    
    private func updateLabel(with rate: ExchangeRate) {
        DispatchQueue.main.async {
            self.exchangeRateLabel.text = (self.currencyFormatter.string(from: rate.rate as NSNumber) ?? "") + " \(rate.symbol) = 1 \(rate.base)"
        }
    }
    
    // MARK: - Properties
    
    private var symbol: String {
        return sharedUserDefaults?.value(forKey: "LastViewedSymbol") as? String ?? "EUR"
    }
    
    private var rates = [ExchangeRate]() {
        didSet {
            DispatchQueue.main.async {
                self.rateHistoryView?.exchangeRates = self.rates
            }
        }
    }
    
    private let fetcher = ExchangeRateFetcher()
    
    private var currencyFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        result.maximumFractionDigits = 2
        result.minimumIntegerDigits = 1
        return result
    }()
    
    private let sharedUserDefaults = UserDefaults(suiteName: "group.com.lambdaschool.Forex")
    
    @IBOutlet var exchangeRateLabel: UILabel!
    @IBOutlet var rateHistoryView: RateHistoryView!
}
