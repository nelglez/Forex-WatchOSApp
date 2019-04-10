//
//  RateHistoryRenderer.swift
//  ForexCore
//
//  Created by Andrew R Madsen on 10/23/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import CoreGraphics

public class RateHistoryRenderer {
    
    public init?(exchangeRates: [ExchangeRate]) {
        let rates = exchangeRates.sorted { $0.date < $1.date }
        
        let calendar = Calendar.current
        
        guard let minDate = rates.first?.date,
            let maxDate = rates.last?.date,
            let minRate = rates.min(by: { $0.rate < $1.rate })?.rate,
            let maxRate = rates.max(by: { $0.rate < $1.rate })?.rate,
            let numDays = calendar.dateComponents([.day], from: minDate, to: maxDate).day,
            maxDate != minDate,
            minRate != maxRate else {
                return nil
        }
        
        self.exchangeRates = rates
        self.minDate = minDate
        self.maxDate = maxDate
        self.minRate = minRate
        self.maxRate = maxRate
        self.numDays = numDays
        self.rateRange = maxRate - minRate
    }
    
    public func draw(in context: CGContext, bounds: CGRect) {
        let path = CGMutablePath()
        if let first = exchangeRates.first {
            path.move(to: point(for: first, in: bounds))
        }
        for exchangeRate in exchangeRates.dropFirst() {
            path.addLine(to: point(for: exchangeRate, in: bounds))
        }
        
        context.addPath(path)
        let color = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 1.0, 1.0, 1.0])!
        context.setStrokeColor(color)
        context.setLineWidth(1.5)
        context.strokePath()
    }
    
    private func point(for exchangeRate: ExchangeRate, in bounds: CGRect) -> CGPoint {
        
        let calendar = Calendar.current
        
        var (minX, maxY) = (bounds.minX, bounds.maxY)
        #if os(watchOS)
        maxY -= 50 // Gross Hack
        #endif
        let rateStep = (maxY - bounds.minY) / CGFloat(rateRange)
        let dayStep = bounds.width / CGFloat(numDays)
        
        let yPosition = maxY - rateStep * CGFloat(exchangeRate.rate - minRate)
        guard let daysSinceBeginning = calendar.dateComponents([.day], from: minDate, to: exchangeRate.date).day else { return .zero }
        let xPosition = minX + CGFloat(daysSinceBeginning) * dayStep
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    public func image(with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: context, bounds: rect)
        guard let cgImage = context.makeImage() else { return nil }
        return UIImage(cgImage: cgImage)
    }

    public let exchangeRates: [ExchangeRate]

    private let minDate: Date
    private let maxDate: Date
    private let minRate: Double
    private let maxRate: Double
    private let rateRange: Double
    private let numDays: Int
}
