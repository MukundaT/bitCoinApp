//
//  CoinManager.swift
//  ByteCoin
//

//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinRate(CoinData:CoinDataFormat)
    func didFailWithErrorInInternet(error:Error)
    func didFailWithErrorInCurrencyEntered(error:Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let bitCoinUrl = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let bitCoinKey = "?apikey=141EBA10-3384-4129-8540-99E4A66AA15A"
    
    
    let currencyArray = ["----" ,"AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SUD","MUK"
        ,"SAG","RAV","RAJ","SGD","USD","ZAR"]
    
    
    
    
    func getCoinPrice(for Currency: String)-> String  {
        let urlWIthCurrency = "\(bitCoinUrl)\(Currency)\(bitCoinKey)"
                print(urlWIthCurrency)
        
        performRequest(Rate: urlWIthCurrency)
        return Currency
    }
    
    func performRequest(Rate: String){
        
        if let url = URL(string: Rate){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data:Data?, urlResponse:URLResponse?, error:Error?) in

                    if error != nil{
                        self.delegate?.didFailWithErrorInInternet(error: error!)
                    }
                    
                
                if let safeData = data{
//                    .....dataWillBeReturnedHere....
    /*  ...................................................................................................................CoinData conists of both currencyName And Pricing Which ever ne need we can Access while Accessing................*/
                    
                    
                    if let CoinData = self.praseJSON(dataJSON: safeData){
                        self.delegate?.didUpdateCoinRate(CoinData: CoinData)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func praseJSON(dataJSON: Data) -> CoinDataFormat? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode( CoinData.self, from: dataJSON)
            let coinRate = decodedData.rate
            let currencyName = decodedData.asset_id_quote
            let coinDataFormat = CoinDataFormat(bitCoinRate: coinRate, currencyName: currencyName)
            //            print(coinDataFormat.bitCoinRateInTwoDecimal)
            return coinDataFormat
        }
        catch{
            self.delegate?.didFailWithErrorInCurrencyEntered(error: error)
            return nil
        }
    }
}
