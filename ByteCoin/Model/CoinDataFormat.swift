//
//  CoinDataFormat.swift
//  ByteCoin
//

//

import Foundation
struct CoinDataFormat {
    var bitCoinRate: Double
    var currencyName: String
    
    var bitCoinRateInTwoDecimal: String{
        return String(format: "%.2f", bitCoinRate)
    }
}
