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
    
    var linha = ""
    var origem = ""
    var destino = ""
    
    var estacoes = [Estacao]()
    
    @IBOutlet var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initMyMapView()
        
        self.addAllAnnotationsInMyMap()
        
        println("Origem \(origem)")
        println("Destino \(destino)")
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
        self.myMapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    func addAllAnnotationsInMyMap() {
        self.estacoes = ManagerData.getAllEstacoesOfLinha(self.linha) as! [Estacao]
        
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
                    //self.myMapView.selectAnnotation(annotationView.annotation, animated: true)
                    annotationView.image = UIImage(named: "pinoOrigemDestino")
                }
                
                if annotationView.annotation.title == "Estação \(self.destino)" {
                    //self.myMapView.selectAnnotation(annotationView.annotation, animated: true)
                    annotationView.image = UIImage(named: "pinoOrigemDestino")
                }
            }
        }
    }
}
