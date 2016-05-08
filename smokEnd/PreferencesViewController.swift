//
//  PreferencesViewController.swift
//  smokEnd
//
//  Created by Aldo Mateos on 26/3/16.
//  Copyright © 2016 Aldo Kyoto. All rights reserved.
//

import UIKit




class PreferencesViewController: UIViewController, UIPickerViewDelegate{

    
    var cigarrettesSmoked = [Int](1...100)
    var cigarrettesSelected = 0
    
    @IBOutlet var numberOfCigarrettes: UITextField!
     var delegate: DestinationViewDelegate! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
    
    return 1
    
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return cigarrettesSmoked.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return cigarrettesSmoked[row].description
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        cigarrettesSelected = row
    }
    
    
    func setTobacoPrice(tobacoPrice:String){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ( segue.identifier == "putTobaccoPriceSegue"){
            
            let destination = segue.destinationViewController as! AnalyticsViewController
            destination.labelText = numberOfCigarrettes.text!
        }
    }
    
    


   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
