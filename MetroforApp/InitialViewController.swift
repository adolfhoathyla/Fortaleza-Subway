//
//  InitialViewController.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 01/03/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit
import CoreLocation

class InitialViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var profilePictureView: FBProfilePictureView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var myLocation: UILabel!
    
    var locationManager: CLLocationManager?
    var autorizationSatus: CLAuthorizationStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initMyLocationManager()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "actionEstouNaEstacao", name: "actionSimPressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "actionNaoEstouNaEstacao", name: "actionNaoPressed", object: nil)
        
        self.myLocation.text = "Não está em nenhuma estação"

        // Do any additional setup after loading the view.
    }
    
    func initMyLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
        var available = CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)
    }
    
    func addRegionsMonitoring() {
        
        //estou supondo que só existe estação Sul
        var estacoes = ManagerData.getAllEstacoesOfLinha("Sul")
        for estacao in estacoes {
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
        
        println(region.identifier)
        
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
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Exit region ", region.identifier)
        self.myLocation.text = "Saiu da estação " + region.identifier
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
