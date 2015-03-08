//
//  ShowMapViewController.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 08/03/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit

class ShowMapViewController: UIViewController {

    @IBOutlet var imageMap: UIImageView!
    var nameImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
