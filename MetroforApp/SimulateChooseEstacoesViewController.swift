//
//  SimulateChooseEstacoesViewController.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 31/03/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//


import UIKit

class SimulateChooseEstacoesViewController: UIViewController {

    @IBOutlet var btDone: UIBarButtonItem!
    @IBOutlet var btDestination: UIButton!
    @IBOutlet var constraintDestino: NSLayoutConstraint!
    @IBOutlet var constraintOrigem: NSLayoutConstraint!
    @IBOutlet var lbPara: UILabel!
    @IBOutlet var lbDe: UILabel!
    @IBOutlet var labelLinha: UILabel!
    var linha = ""
    var estacoesAsString = [String]()
    var estacaoInicial: String?

    @IBOutlet var labelDestino: UILabel!
    @IBOutlet var labelOrigem: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelLinha.text = "Linha " + self.linha
        
        self.btDestination.enabled = false
        self.btDone.enabled = false
        
        // Do any additional setup after loading the view.
        
        let estacoes = ManagerData.getAllEstacoesOfLinha(self.linha) as! [Estacao]
        
        for estacaoString in estacoes {
            self.estacoesAsString.append(estacaoString.nome)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let mapViewController = segue.destinationViewController as! MapViewSimulateViagemViewController
        mapViewController.linha = self.linha
        mapViewController.origem = self.labelOrigem.text!
        mapViewController.destino = self.labelDestino.text!
        mapViewController.estacaoInicial = self.estacaoInicial
    }

    @IBAction func actionOrigem(sender: AnyObject) {
        RRTagController.displayTagController(parentController: self, tagsString: self.estacoesAsString, blockFinish: { (selectedTags, unSelectedTags) -> () in

            self.animationButtonAndLabels(sender as! UIButton, op: "origem", estacao: selectedTags[0].textContent)
            
        }) { () -> () in
            println("Cancelou: Origem")
        }
    }

    @IBAction func actionDestino(sender: AnyObject) {
        RRTagController.displayTagController(parentController: self, tagsString: self.estacoesAsString, blockFinish: { (selectedTags, unSelectedTags) -> () in

            self.animationButtonAndLabels(sender as! UIButton, op: "destino", estacao: selectedTags[0].textContent)
            
        }) { () -> () in
            println("Cancelou: Destino")
        }
    }
    
    @IBAction func actionDone(sender: AnyObject) {
        if self.labelDestino.text == "Escolha" || self.labelOrigem.text == "Escolha" {
            
            let alert = UIAlertController(title: "Ops", message: "Você deve preencher os campos origem e destino", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            self.performSegueWithIdentifier("showMap", sender: nil)
        }
    }
    
    func animationButtonAndLabels(button: UIButton, op: String, estacao: String) {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            if op == "origem" {
                
                self.constraintOrigem.constant = +70
                
            } else if op == "destino" {
                
                self.constraintDestino.constant = +70
                
            }
            
            
            
            self.view.layoutIfNeeded()
            
        }) { (success) -> Void in
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                if op == "origem" {
                    
                    self.labelOrigem.text = estacao
                    self.lbDe.alpha = 1
                    self.labelOrigem.alpha = 1
                    self.btDestination.enabled = true
                    
                } else if op == "destino" {
                    
                    self.labelDestino.text = estacao
                    self.lbPara.alpha = 1
                    self.labelDestino.alpha = 1
                    self.btDone.enabled = true
                    
                }
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
        }
    }
}
