//
//  PreferencesViewController.swift
//  smokEnd
//
//  Created by Aldo Mateos on 26/3/16.
//  Copyright © 2016 Aldo Kyoto. All rights reserved.
//

import UIKit
import CoreData



class PreferencesViewController: UIViewController, UIPickerViewDelegate{

    let moc = AppDelegate().managedObjectContext
    let consulta = NSFetchRequest(entityName: "DatosBD")
    
    
    var cigarettesSomokedMonthly = 0
    var cigarettesPacks = 0
    var expendMoneyMothly = Float(0)
    var expendMoneyAnual = Float(0)
    var cigarrettesSmoked = [Int](1...100)
    var cigarrettesSelected = 0
    var priceCigarro = Float(0)
    var delegate: DestinationViewDelegate! = nil
    var error: NSError? = nil
    
    
    @IBOutlet var priceCigarettesPack: UITextField!
    @IBOutlet var MyPicker: UIPickerView!
    
    
   
    override func viewDidAppear(animated: Bool) {
     
        readData()
        
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       //subir pantalla cuando sale el teclado
        
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PreferencesViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PreferencesViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PreferencesViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func sendInfo(sender: UIButton) {
        
       
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
        
        cigarrettesSelected = (row+1)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if ( segue.identifier == "putTobaccoPriceSegue"){
            
                
            priceCigarro = Float(priceCigarettesPack.text!)!
            
            
            //Cálculos 
            
            cigarettesSomokedMonthly = (cigarrettesSelected * 30)
            cigarettesPacks = (cigarettesSomokedMonthly/20)
            expendMoneyMothly = (Float(cigarettesPacks) * priceCigarro)
            expendMoneyAnual = (expendMoneyMothly * 12)
           
            
            //Pasar datos a la vista AnalyticsViewController
            
            let destination = segue.destinationViewController as! AnalyticsViewController
            destination.labelText = priceCigarettesPack.text!
            destination.labelNcigarros = String(cigarrettesSelected)
            
            destination.labelAhorradoMes = String(expendMoneyMothly)
            destination.labelAhorradoAno = String(expendMoneyAnual)
            
            saveData()
          
            }
    }
    
    
    
    func saveData() {
        
        print("Guardamos los datos")
        
        
        let count = moc.countForFetchRequest(consulta, error: &error)
        
        print("registros contabilizados: \(count)")
        
        if count == 0 {
        
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName("DatosBD", inManagedObjectContext: moc) as! DatosBD
        
        
        entity.setValue(Int(cigarrettesSelected), forKey: "cigarrosFumados")
        entity.setValue(Float(priceCigarro), forKey: "precioPaquete")
        
        
        do{
            try moc.save()
        }
        catch{
            fatalError("Failure to save content: \(error)")
        }
            
        }
        else
        {
            print("ACTUALIZAMOS DATOS")
            
            
            do {
               
                let result = try moc.executeFetchRequest(consulta) as! [DatosBD]
                let user = result[0] as NSManagedObject
                
                user.setValue(Int(cigarrettesSelected), forKey: "cigarrosFumados")
                user.setValue(Float(priceCigarro), forKey: "precioPaquete")
                
                
                try user.managedObjectContext?.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
            
        }

    }
   
    
    
    func readData(){
        
        var error: NSError? = nil
        let count = moc.countForFetchRequest(consulta, error: &error)
        
        print("registros contabilizados: \(count)")
        
        if count > 0 {
            
            print("Estamos leyendo datos")
            let leerPrecio = NSFetchRequest(entityName: "DatosBD")
            
            do {
                
                let precioLeido = try moc.executeFetchRequest(leerPrecio) as! [DatosBD]
                
                print(precioLeido.first!.cigarrosFumados!)
                print(precioLeido.first!.precioPaquete!)
                
                priceCigarettesPack.text = String(precioLeido.first!.precioPaquete!)
                cigarrettesSelected = Int(precioLeido.first!.cigarrosFumados!)
                
                MyPicker.selectRow((cigarrettesSelected-1), inComponent: 0, animated: true)
                
                
                
            }
            catch {
                fatalError("No se ha podido leer los datos \(error)")
            }
            
        }
            
        else{
            
            print("No hay datos para leer")
            
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
