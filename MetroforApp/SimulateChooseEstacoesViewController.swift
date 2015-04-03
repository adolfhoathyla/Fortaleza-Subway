//
//  SimulateChooseEstacoesViewController.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 31/03/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit

class SimulateChooseEstacoesViewController: UIViewController {
    
    @IBOutlet var labelLinha: UILabel!
    var linha = ""
    var estacoesAsString = [String]()

    @IBOutlet var labelDestino: UILabel!
    @IBOutlet var labelOrigem: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelLinha.text = self.linha
        
        // Do any additional setup after loading the view.
        
        let estacoes = ManagerData.getAllEstacoesOfLinha(self.linha) as [Estacao]
        
        for estacaoString in estacoes {
            self.estacoesAsString.append(estacaoString.nome)
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
    @IBAction func actionOrigem(sender: AnyObject) {
        RRTagController.displayTagController(parentController: self, tagsString: self.estacoesAsString, blockFinish: { (selectedTags, unSelectedTags) -> () in
            println(selectedTags[0].textContent)
            
            self.labelOrigem.text = selectedTags[0].textContent
        }) { () -> () in
            println("Cancelou: Origem")
        }
    }

    @IBAction func actionDestino(sender: AnyObject) {
        RRTagController.displayTagController(parentController: self, tagsString: self.estacoesAsString, blockFinish: { (selectedTags, unSelectedTags) -> () in
            
            self.labelDestino.text = selectedTags[0].textContent
            
        }) { () -> () in
            println("Cancelou: Destino")
        }
    }
}
