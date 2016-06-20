//
//  AnalyticsViewController.swift
//  smokEnd
//
//  Created by Aldo Mateos on 26/3/16.
//  Copyright © 2016 Aldo Kyoto. All rights reserved.
//

import UIKit
import CoreData


protocol DestinationViewDelegate {
    func setTobacoPrice(tobacoPrice:String);
    
}

class AnalyticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    
   
    
    let textCellIdentifier = "TextCell"
    
    @IBOutlet var precioCigarros: UILabel!
    @IBOutlet var nCigarrosFumados: UILabel!
    @IBOutlet var dineroAhorraMes: UILabel!
    @IBOutlet var dineroAhorradoAno: UILabel!
    @IBOutlet var cigarrosFumados: UILabel!
    @IBOutlet var heFumado: UILabel!
    @IBOutlet var dineroDisponible: UILabel!
    @IBOutlet var tableView: UITableView!

   let moc = AppDelegate().managedObjectContext
    let consulta = NSFetchRequest(entityName: "DatosBD")
   // var fetchedResultsController: NSFetchedResultsController!
    
    
    var labelText = String()
    var labelNcigarros = String()
    var labelAhorradoMes = String()
    var labelAhorradoAno = String()
    var labelCigarrosFumados = String()
    
    
    
    var cigarettesSomokedMonthly = 0
    var cigarettesPacks = 0
    var expendMoneyMothly = Float(0)
    var expendMoneyAnual = Float(0)
    var cigarrettePrice = Float(0)
    var moneySpendCigarettesSmokeDaily = Float(0)
    var contador = 0
    var error: NSError? = nil
 
  
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()

    var fetchedResultsController: NSFetchedResultsController!
    
       
    
    
    func viewWillAppear() {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        precioCigarros.text = labelText
        //nCigarrosFumados.text = labelNcigarros
        dineroAhorraMes.text = labelAhorradoMes
        dineroAhorradoAno.text = labelAhorradoAno
        cigarrosFumados.text = labelCigarrosFumados
        
        
        //1
        let fetchRequest = NSFetchRequest(entityName: "DatosBD")
        let fetchSort = NSSortDescriptor(key: "cigarrosFumados", ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        
        //2
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        //3
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
        
        
          }

    
    override func viewDidAppear(animated: Bool) {
        
        readData()
        //self.tableView.reloadData()
        
        
    }

  
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      //  return 1
       if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return swiftBlogs.count
        
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
        
    }
        
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
     //   let row = indexPath.row
     //   cell.textLabel?.text = swiftBlogs[row]
        
    //    return cell
        
       
        let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! DatosBD
        
       // let cell = tableView.dequeueReusableCellWithIdentifier("movieCell")!
        
        cell.textLabel?.text = String(movie.cigarrosPulsados!)
        return cell
        
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        //tableView.reloadData()
        tableView.endUpdates()
        
       // let indexPath = NSIndexPath(forRow: 1, inSection: 0)
       // self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        // 1
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        // 2
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        default: break
        }
    }
    
    //Optional, solo si quieres pulsar una celda
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
       // let row = indexPath.row
       // print(swiftBlogs[row])
        print("Has pulsado la celda")
    }
    
    
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hola cabezera"
    }
    
    //Header de la tabla
  /*  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.greenColor()
        
        return vw
    }*/
    
    
    
    func readData(){
        
        print("Estamos leyendo datos")
        let consulta = NSFetchRequest(entityName: "DatosBD")
        
        do {
            
            //Leémos los datos
            
            let leerDatos = try moc.executeFetchRequest(consulta) as! [DatosBD]
            print(leerDatos.first!.cigarrosFumados!)
            print(leerDatos.first!.precioPaquete!)
            print(leerDatos.first!.cigarrosPulsados!)
            
            
            //Cálculos
            
            cigarettesSomokedMonthly = ((leerDatos.first!.cigarrosFumados! as Int) * 30)
            cigarettesPacks = (cigarettesSomokedMonthly/20)
            expendMoneyMothly = (Float(cigarettesPacks) * (leerDatos.first!.precioPaquete! as Float))
            expendMoneyAnual = (expendMoneyMothly * 12)
            cigarrettePrice = ((leerDatos.first!.precioPaquete! as Float)/20)
            moneySpendCigarettesSmokeDaily = (cigarrettePrice * (leerDatos.first!.cigarrosPulsados! as Float))
            
            
            
            
            // Mostramos los datos
            precioCigarros.text = String(leerDatos.first!.precioPaquete!)
            cigarrosFumados.text = String(leerDatos.first!.cigarrosFumados!)
            dineroAhorraMes.text = String(expendMoneyMothly)
            dineroAhorradoAno.text = String(expendMoneyAnual)
            heFumado.text = String(leerDatos.first!.cigarrosPulsados!)
            dineroDisponible.text = String(expendMoneyAnual - moneySpendCigarettesSmokeDaily)
            
        }
        catch {
            fatalError("No se ha podido leer los datos \(error)")
        }
        
        
        
    }
    
    
    
    @IBAction func botonFumado(sender: AnyObject) {
        
       
     print("HE FUMADO, CONTABILIZA")
        
        let count = moc.countForFetchRequest(consulta, error: &error)
        
        print("registros contabilizados: \(count)")
        
        if count == 0 {

        contador += 1
        let entity = NSEntityDescription.insertNewObjectForEntityForName("DatosBD", inManagedObjectContext: moc) as! DatosBD
        entity.setValue(contador, forKey: "cigarrosPulsados")
        
        do{
            try moc.save()
        }
        catch{
            fatalError("Failure to add a cigarette smoked: \(error)")
        }
            

        }
        else{
            
            print("Actualiza las pulsaciones de cigarros")
            
            do {
                
                let result = try moc.executeFetchRequest(consulta) as! [DatosBD]
                let user = result[0] as NSManagedObject
                contador = (Int(result.first!.cigarrosPulsados!) + 1)
                
                
                user.setValue(contador, forKey: "cigarrosPulsados")
                
                
                
                try user.managedObjectContext?.save()
                
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
            
           
            
            
        }
       
        readData()
        
        
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
