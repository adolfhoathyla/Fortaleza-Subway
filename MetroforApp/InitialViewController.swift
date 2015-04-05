//
//  InitialViewController.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 01/03/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InitialViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var profilePictureView: FBProfilePictureView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var myLocation: UILabel!
    
    var locationManager: CLLocationManager?
    var autorizationSatus: CLAuthorizationStatus?
    
    var estacoes = [Estacao]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initMyLocationManager()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "actionEstouNaEstacao", name: "actionSimPressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "actionNaoEstouNaEstacao", name: "actionNaoPressed", object: nil)
        
        self.myLocation.text = "Não está em nenhuma estação"
        self.estacaoMaisProxima.enabled = true

        // Do any additional setup after loading the view.
    }
    
    private func initMyLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
        var available = CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)
    }
    
    private func addRegionsMonitoring() {
        
        //estou supondo que só existe estação Sul
        self.estacoes = ManagerData.getAllEstacoesOfLinha("Sul") as [Estacao]
        for estacao in self.estacoes {
            self.makeRegionMonitoring(latitude: estacao.latitude as Double, longitude: estacao.longitude as Double, identifier: estacao.nome)
        }
    }
    
    // MARK - LOCATION MANAGER
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.locationManager?.stopUpdatingLocation()
        if ((error) != nil) {
            println(error)
            self.myLocation.text = "Não me deixou ver sua localização :/"
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locationsArray = locations as NSArray
        var location = locationsArray.lastObject as CLLocation
        println("latitude: \(location.coordinate.latitude)")
        println("longitude: \(location.coordinate.longitude)")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case .Restricted:
            println("Acesso restrito")
            self.autorizationSatus = CLAuthorizationStatus.Restricted
        case .Denied:
            println("Acesso negado pelo usuário")
            self.autorizationSatus = CLAuthorizationStatus.Denied
        case .NotDetermined:
            self.autorizationSatus = CLAuthorizationStatus.NotDetermined
            println("Acesso não determinado")
        default:
            println("Acesso permitido, à localização")
            shouldIAllow = true
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("Autorização foi modificada", object: nil)
        if shouldIAllow {
            println("Localização permitida")
            self.locationManager?.startUpdatingLocation()
            self.addRegionsMonitoring()
        } else {
            println("Localização não permitida")
        }
    }
    
    // MARK - Region Monitoring
    func makeRegionMonitoring(#latitude: Double, longitude: Double, identifier: String) {
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 50, identifier: identifier)
        self.locationManager?.startMonitoringForRegion(region)
    }
    
    //Este método é chamado sempre que é criada uma região monitorada
    //então, verifico se a localzação atual do usuário está contida em alguma das regiões registradas
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        //if (self.autorizationSatus == CLAuthorizationStatus.NotDetermined) {
            let regionCircular = region as CLCircularRegion
            let userLocation = self.locationManager?.location.coordinate
        
            if regionCircular.containsCoordinate(userLocation!) {
                
                //fazer a verificação se é ou não a primeira estação que o usuário está
        
                var dataAtual = NSDate()
                
                var notification:UILocalNotification = UILocalNotification()
                notification.category = "MY_CATEGORY"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.applicationIconBadgeNumber = 1
                notification.alertBody = "Você está na estação \(region.identifier)?"
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
                self.myLocation.text = "Está na estação " + region.identifier
                
                //self.estacaoMaisProxima.enabled = false
            }
        //}
    }

    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        //criar uma notificação
        //fazer a verificação se é ou não a primeira estação que o usuário está
        
        var notification:UILocalNotification = UILocalNotification()
        notification.category = "MY_CATEGORY"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = 1
        notification.alertBody = "Você está na estação \(region.identifier)?"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    
        println("Enter region ", region.identifier)
        self.myLocation.text = "Está na estação " + region.identifier
        //self.estacaoMaisProxima.enabled = false
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Exit region ", region.identifier)
        self.myLocation.text = "Saiu da estação " + region.identifier
        self.estacaoMaisProxima.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionEstouNaEstacao() {
        self.viewDidLoad()
    }
    
    func actionNaoEstouNaEstacao() {
        
    }

    @IBOutlet var estacaoMaisProxima: UIButton!
    
    @IBAction func actionEstacaoMaisProxima(sender: AnyObject) {
        
        //if self.myLocation.text == "Não está em nenhuma estação" {
            var estacaoMaisProximaDoUsuario = self.estacaoMaisProximaOfUserLocation(self.estacoes)
        
            let alert = UIAlertController(title: "Estação mais próxima", message: String(format: "Estação %@ com %.2fKm é a mais próxima", estacaoMaisProximaDoUsuario.nome, estacaoMaisProximaDoUsuario.distance / 1000), preferredStyle: UIAlertControllerStyle.Alert)
        
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        
            alert.addAction(UIAlertAction(title: "Ver no mapa", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.openMapForStation(estacaoMaisProximaDoUsuario)
                
            }))
        
            self.presentViewController(alert, animated: true, completion: nil)
        //}
    }
    
    private func estacaoMaisProximaOfUserLocation(estacoesLocal: [Estacao]) -> EstacaoMaisProxima {
        
        var estacoesProximas = [EstacaoMaisProxima]()
        var estacaoMaisProxima: EstacaoMaisProxima?
        
        for estacao in estacoesLocal {
            var meters = self.locationManager?.location.distanceFromLocation(CLLocation(latitude: estacao.latitude as Double, longitude: estacao.longitude as Double))
            
            var newEstacao = EstacaoMaisProxima(nome: estacao.nome, latitude: estacao.latitude as Double, longitude: estacao.longitude as Double, distance: meters!)
            
            estacoesProximas.append(newEstacao)
            
            println("Distance for \(estacao.nome): \(meters! / 1000)")
        }
        
        var minDistance = 1000000.0
        
        for estacao in estacoesProximas {
            minDistance = min(minDistance, estacao.distance)
        }
        
        for estacao in estacoesProximas {
            if estacao.distance == minDistance {
                estacaoMaisProxima = EstacaoMaisProxima(nome: estacao.nome, latitude: estacao.latitude as Double, longitude: estacao.longitude as Double, distance: minDistance)
            }
        }
        
        println("Mínima \(minDistance / 1000)")
        
        return estacaoMaisProxima!
    }
    
    private func openMapForStation(station: EstacaoMaisProxima) {
        let regionDistance:CLLocationDistance = 10000
        var coordinates = CLLocationCoordinate2DMake(station.latitude as Double, station.longitude as Double)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapitem = MKMapItem(placemark: placemark)
        mapitem.name = "Estação \(station.nome)"
        mapitem.openInMapsWithLaunchOptions(options)
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
