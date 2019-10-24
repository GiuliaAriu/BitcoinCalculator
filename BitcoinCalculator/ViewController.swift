//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var currentSymbol = ""
    var finalURL = ""

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //We have to set this class as the delegate of the UIPickerView and as the data source
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

    
    
    //In this method we set the number of components (the columns) of the picker as 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //This method returns the number of elements in the array, so that we know the number of rows we need in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return currencyArray.count
    }
    
    
    //This method is needed to set the text of each row of the picker as the string it returns
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return currencyArray[row]
    }
 

    //This method will get called every time the picker is scrolled. When that happens it will record the row that was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //We create the URL that will be passed to getBitcoinData in order to make the data request:
        //the final URL is obtained by adding to the base URL string the name of the currency chosen from the picker
        finalURL = baseURL + currencyArray[row]
        
        
        currentSymbol = symbolArray[row]
        
        getBitcoinData(url: finalURL)
    }
    

    
    
    
    
    //MARK: - Networking
    /**************************************************************/
    
    
    // If the request we made to the URL is successful then we can save the result of that response in our variable of type JSON, that'll be used to update the data in the price label
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON {
            response in if response.result.isSuccess {

                    let bitcoinJSON : JSON = JSON(response.result.value!)
                
                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
        
        //Optional binding: if it's not nil we want to update the price label as the price converted, otherwise it'll display a message of error
        if let bitcoinResult = json["ask"].double
        {
            bitcoinPriceLabel.text = currentSymbol + " \(bitcoinResult)"
        }
        else
        {
            bitcoinPriceLabel.text = "Conversion unavailable"
        }

    }
    




}

