//
//  ShowMapViewController.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 08/03/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit

class ShowMapViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var imageMap: UIImageView!
    var nameImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        myScrollView.minimumZoomScale = 1
        myScrollView.maximumZoomScale = 9
        myScrollView.delegate = self
        
        self.view.addSubview(myScrollView)

        // Do any additional setup after loading the view.
        
        var name = "mapa"
        
        switch nameImage {
            case "Geral":
                name += "Geral"
                break
            case "Sul":
                name += "LinhaSul"
                break
            case "Leste":
                name += "LinhaLeste"
                break
            case "Oeste":
                name += "LinhaOeste"
                break
            default:
                break
        }
        
        self.imageMap.image = UIImage(named: name)
        
        myScrollView.addSubview(imageMap)
        
        self.imageMap.userInteractionEnabled = true
        
        let pinchReconizer = UIPinchGestureRecognizer(target: self, action: "zoomMap:")
        self.imageMap.addGestureRecognizer(pinchReconizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zoomMap(sender: UIPinchGestureRecognizer) {
        
        let currentScale = self.imageMap.frame.size.width / self.imageMap.bounds.size.width
        var newScale = currentScale * sender.scale
        
        let minimumScale = CGFloat(1)
        let maximumScale = CGFloat(9)
        
        if newScale < minimumScale {
            newScale = minimumScale
        }
        
        if newScale > maximumScale {
            newScale = maximumScale
        }
        
        let transform = CGAffineTransformMakeScale(newScale, newScale)
        self.imageMap.transform = transform
        sender.scale = 1
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageMap
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
