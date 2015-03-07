//
//  ManagerData.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 28/02/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit
import CoreData

class ManagerData {
    
    func addLinhaWithName(nome: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Linha", inManagedObjectContext: managedContext)
        
        let linha = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        linha.setValue(nome, forKey: "nome")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        
    }
    
    func addEstacaoWithName(nome: String, latitude: Double, longitude: Double, linha: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Estacao", inManagedObjectContext: managedContext)
        
        let estacao = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        estacao.setValue(nome, forKey: "nome")
        estacao.setValue(latitude, forKey: "latitude")
        estacao.setValue(longitude, forKey: "longitude")
        estacao.setValue(linha, forKey: "linha")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func getAllEstacoes() -> NSArray {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        var entity = NSEntityDescription.entityForName("Estacao", inManagedObjectContext: managedContext)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        var error: NSError?
        
        var estacoes = managedContext.executeFetchRequest(fetchRequest, error: &error)
        
        return estacoes!
    }
    
}
