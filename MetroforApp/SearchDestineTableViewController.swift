//
//  SearchDestineTableViewController.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 05/04/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit
import MapKit

class SearchDestineTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var mySearchBar: UISearchBar!
    var places = [Place]()
    var estacoes = [Estacao]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mySearchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.estacoes = ManagerData.getAllEstacoesOfLinha("Sul") as! [(Estacao)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return places.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellPlace", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        
        cell.textLabel?.text = self.places[indexPath.row].address

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let estacaoMaisProxima = self.stationMoreNearOfDestine(self.estacoes, destino: CLLocation(latitude: self.places[indexPath.row].latitude as Double, longitude: self.places[indexPath.row].longitude as Double))
        
        let alert = UIAlertController(title: "Estação \(estacaoMaisProxima.nome)", message: String(format: "Estação mais próxima para %@: Estação %@ com %1.2fKm", self.places[indexPath.row].address, estacaoMaisProxima.nome, estacaoMaisProxima.distance/1000), preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ver no mapa", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
            
            self.openMapForStation(estacaoMaisProxima)
            
        }))
    
        self.presentViewController(alert, animated: true, completion: nil)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func stationMoreNearOfDestine(estacoes: [Estacao], destino: CLLocation) -> EstacaoMaisProxima {
        var estacaoMaisProxima: EstacaoMaisProxima?
        var estacoesWithDistance = [EstacaoMaisProxima]()
        
        for estacao in estacoes {
            var meters = destino.distanceFromLocation(CLLocation(latitude: estacao.latitude as Double, longitude: estacao.longitude as Double))
            
            var newEstacaoWithDistance = EstacaoMaisProxima(nome: estacao.nome, latitude: estacao.latitude as Double, longitude: estacao.longitude as Double, distance: meters)
            
            estacoesWithDistance.append(newEstacaoWithDistance)
            
            println("Distancia para \(estacao.nome): \(meters / 1000)")
        }
        
        var minDistance = 10000000000000000.0
        
        for estacao in estacoesWithDistance {
            minDistance = min(minDistance, estacao.distance)
        }
        
        for estacao in estacoesWithDistance {
            if estacao.distance == minDistance {
                estacaoMaisProxima = EstacaoMaisProxima(nome: estacao.nome, latitude: estacao.latitude as Double, longitude: estacao.longitude as Double, distance: estacao.distance)
                println("Mais próxima \(estacaoMaisProxima?.nome)")
            }
        }
        
        return estacaoMaisProxima!
    }
    
    private func openMapForStation(station: EstacaoMaisProxima) {
        let regionDistance:CLLocationDistance = 10000
        var coordinates = CLLocationCoordinate2DMake(station.latitude as Double, station.longitude as Double)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span),
            MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapitem = MKMapItem(placemark: placemark)
        mapitem.name = "Estação \(station.nome)"
        mapitem.openInMapsWithLaunchOptions(options)
    }
    
    // MARK: - SEARCH BAR
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let request = RequestGoogleGeocoding()
        request.initMySearchWithString(searchBar.text, completeBlock: { () -> () in
            
            self.places = request.places
            self.tableView.reloadData()
            
        })
    }

}
