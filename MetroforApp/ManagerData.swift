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
    
    func addHorarioWithHora(hora: String, sentido: String, estacao: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Horario", inManagedObjectContext: managedContext)
        
        let horario = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        horario.setValue(sentido, forKey: "sentido")
        horario.setValue(hora, forKey: "hora")
        horario.setValue(estacao, forKey: "estacao")
        //horario.setValue(idAsInt, forKey: "idHorario")
        
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
    
    func getHorariosFromEstacao(estacao: String, sentido: String) -> NSArray {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        var entity = NSEntityDescription.entityForName("Horario", inManagedObjectContext: managedContext)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        let myPredicate = NSPredicate(format: "sentido = %@ AND estacao = %@", sentido, estacao)
        fetchRequest.predicate = myPredicate
        
        var error: NSError?
        
        var horarios = managedContext.executeFetchRequest(fetchRequest, error: &error)
        
        return horarios!
    }
    
    class func addUserWithName(name: String, email: String) {
        println("\(name) - \(email)")
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Usuario", inManagedObjectContext: managedContext)
        
        let usuario = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        usuario.setValue(name, forKey: "nome")
        usuario.setValue(email, forKey: "email")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
    }
    
}
