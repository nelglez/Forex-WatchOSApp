//
//  RateHistoryView.swift
//  Forex
//
//  Created by Andrew R Madsen on 10/21/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

public class RateHistoryView: UIView {
    
    override public func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        renderer?.draw(in: context, bounds: bounds)
    }
    
    public var exchangeRates = [ExchangeRate]() {
        didSet {
            renderer = RateHistoryRenderer(exchangeRates: exchangeRates)
            setNeedsDisplay(bounds)
        }
    }
    
    private var renderer: RateHistoryRenderer?
}
