//
//  MapViewSimulateViagemViewController.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 03/04/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit
import MapKit

class MapViewSimulateViagemViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager: CLLocationManager?
    
    @IBOutlet var statusViagem: UILabel!
    
    var linha = ""
    var origem = ""
    var destino = ""
    var estacaoInicial: String?
    
    var estacoes = [Estacao]()
    
    @IBOutlet var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initMyMapView()
        
        self.addAllAnnotationsInMyMap()
        
        if let initialStation = self.estacaoInicial {
            if initialStation == "Nenhuma" {
                self.statusViagem.text = "Não está em nenhuma estação"
            } else {
                self.statusViagem.text = "Está na estação \(initialStation)"
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("ENTER_REGION", object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            if let estacao = notification.userInfo?.values.first as? String {
                println("MAP VIEW: Entrei da estação \(estacao)")
                self.statusViagem.text = "Chegou na estação \(estacao)"
                self.selectAnnotationActualy(estacao)
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("EXIT_REGION", object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            if let estacao = notification.userInfo?.values.first as? String {
                println("MAP VIEW: Saí da estação \(estacao)")
                self.statusViagem.text = "Saiu da estação \(estacao)"
            }
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initMyMapView() {
        
        self.myMapView.delegate = self
        //self.myMapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        self.estacoes = ManagerData.getAllEstacoesOfLinha(self.linha) as! [Estacao]
        
        var stationSource: Estacao?
        
        for estacao in estacoes {
            if estacao.nome == self.origem {
                stationSource = estacao
            }
        }
        
        let startCoordinate = CLLocationCoordinate2D(latitude: stationSource?.latitude as! Double, longitude: stationSource?.longitude as! Double)
        
        let adjustRegion = self.myMapView.regionThatFits(MKCoordinateRegionMakeWithDistance(startCoordinate, 10000, 10000))
        
        self.myMapView.setRegion(adjustRegion, animated: true)
        
    }
    
    func addAllAnnotationsInMyMap() {
        
        
        for estacao in self.estacoes {
            
            var annotationEstacao = MKPointAnnotation()
            
            let location = CLLocation(latitude: estacao.latitude as Double, longitude: estacao.longitude as Double)
            
            annotationEstacao.coordinate = location.coordinate
            annotationEstacao.title = "Estação \(estacao.nome)"
            annotationEstacao.subtitle = "Linha \(estacao.linha)"
            
            if self.origem == estacao.nome {
                annotationEstacao.subtitle = "Origem"
            }
            if self.destino == estacao.nome {
                annotationEstacao.subtitle = "Destino"
            }
            
            self.myMapView.addAnnotation(annotationEstacao)
        }
    }
    
    // MARK: - MapView
    
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.pinColor = .Red
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        var av: MKAnnotationView?
        
        for av in views {
            if av.annotation is MKPointAnnotation {
                var annotationView = av as! MKAnnotationView
                
                annotationView.image = UIImage(named: "pinoEstacao")
                
                if annotationView.annotation.title == "Estação \(self.origem)" {
                    self.myMapView.selectAnnotation(annotationView.annotation, animated: true)
                    //annotationView.image = UIImage(named: "pinoOrigemDestino")
                    var pinAv = annotationView as! MKPinAnnotationView
                    pinAv.pinColor = .Green
                }
                
                if annotationView.annotation.title == "Estação \(self.destino)" {
                    //self.myMapView.selectAnnotation(annotationView.annotation, animated: true)
                    //annotationView.image = UIImage(named: "pinoOrigemDestino")
                    var pinAvTwo = annotationView as! MKPinAnnotationView
                    pinAvTwo.pinColor = .Green
                }
            }
        }
    }
    
    private func selectAnnotationActualy(station: String) {
//        if myMapView.selectedAnnotations != nil {
//            self.myMapView.deselectAnnotation(self.myMapView.selectedAnnotations.first?.annotation, animated: true)
//        }
        
        let estacaoSelected = "Estação " + station
        
        for annotation in self.myMapView.annotations {
            if let title = annotation.title {
                if title == estacaoSelected {
                    println("Selecionar estação \(title)")
                    self.myMapView.selectAnnotation(annotation.annotation, animated: true)
                }
            }

        }
        
    }

}
