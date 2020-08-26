//
//  ViewController.swift
//  ByteCoin
//

//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
}
//MARK: - UIPickerViewDataSource
//.......................For Specifying Rows And Columns..................................

extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    
}

//MARK: - UIPickerViewDelegate
//.................ForSettingOurTitleToDataPickerAndSelectingTheRequired.......................

extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
//        currencyLabel.text = selectedCurrency
        coinManager.getCoinPrice(for: selectedCurrency)
        
    }
    
}
//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoinRate(CoinData:CoinDataFormat){
        DispatchQueue.main.async {
            self.bitCoinLabel.text = CoinData.bitCoinRateInTwoDecimal
            self.currencyLabel.text = CoinData.currencyName

        }
    }
    func didFailWithErrorInInternet(error:Error){
        DispatchQueue.main.async {
            self.bitCoinLabel.text = "CheckInternetConnection"
        }
        
    }
    
   

    
    func didFailWithErrorInCurrencyEntered(error: Error) {
        DispatchQueue.main.async {
            self.bitCoinLabel.text = "SelectedCurrencyTypeIsNotAvaiable"
            print(error)
        }
        
    }
}
