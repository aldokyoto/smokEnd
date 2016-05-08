//
//  AnalyticsViewController.swift
//  smokEnd
//
//  Created by Aldo Mateos on 26/3/16.
//  Copyright © 2016 Aldo Kyoto. All rights reserved.
//

import UIKit



protocol DestinationViewDelegate {
    func setTobacoPrice(tobacoPrice:String);
    
}

class AnalyticsViewController: UIViewController {

    @IBOutlet var precioCigarros: UILabel!
    
    var labelText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        precioCigarros.text = labelText
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
