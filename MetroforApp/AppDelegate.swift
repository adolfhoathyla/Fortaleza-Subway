//
//  AppDelegate.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 28/02/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        
        let tabBarController = self.window!.rootViewController as! UITabBarController
        
        tabBarController.selectedIndex = 0;
        
//        let controller = tabBarController.viewControllers?.first as! UINavigationController
//        
//        let master = controller.topViewController as! MasterViewController
//        master.managedObjectContext = self.managedObjectContext
        
        //Se for o primeiro acesso, vamos popular o banco (:
        if !NSUserDefaults.standardUserDefaults().boolForKey("firstAcess") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstAcess")
            
            self.addAllLines()
            self.addAllEstacoes()
            self.AddAllHorarios()
            //self.addRegionsMonitoring()
        }
        
        //Se não tiver uma sessão aberta, então vamos abrir uma sessão no facebook (:
//        if !FBSession.activeSession().isOpen {
        //if FBSession.activeSession().state == FBSessionState.CreatedTokenLoaded {
//            println("não está logado")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginViewController = storyboard.instantiateViewControllerWithIdentifier("OAuthFacebook") as! UIViewController
//            self.window?.makeKeyAndVisible()
//            self.window?.rootViewController?.presentViewController(loginViewController, animated: true, completion: nil)
//        }
        
        //Notificações (:
        
        //actions
        var firstAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "FIRST_ACTION"
        firstAction.title = "Não"
        
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        var secondAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "SECOND_ACTION"
        secondAction.title = "Sim"
        
        secondAction.activationMode = UIUserNotificationActivationMode.Foreground
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        
        
        //categorie
        let category:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        category.identifier = "MY_CATEGORY"
        
        category.setActions([firstAction, secondAction], forContext: UIUserNotificationActionContext.Default)
        category.setActions([firstAction, secondAction], forContext: UIUserNotificationActionContext.Minimal)
        
        let categories:NSSet = NSSet(objects: category)
        
        let type:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: type, categories: categories as Set<NSObject>)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
        
        return true
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if identifier == "FIRST_ACTION" {
            NSNotificationCenter.defaultCenter().postNotificationName("actionNaoPressed", object: nil)
        } else if identifier == "SECOND_ACTION" {
            NSNotificationCenter.defaultCenter().postNotificationName("actionSimPressed", object: nil)
        }
        completionHandler()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        
        FBAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "BEPiD.MetroforApp" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("MetroforApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("MetroforApp.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func addAllLines() {
        var manager = ManagerData()
        manager.addLinhaWithName("Sul")
        manager.addLinhaWithName("Leste")
        manager.addLinhaWithName("Oeste")
    }
    
    func addAllEstacoes() {
        var manager = ManagerData()
        //manager.addEstacaoWithName("Casa do Athyla", latitude: -3.879383, longitude: -38.609168, linha: "Sul")
        manager.addEstacaoWithName("Carlito Benevides", latitude: -3.894090, longitude: -38.621003, linha: "Sul")
        manager.addEstacaoWithName("Jereissati", latitude: -3.887254, longitude: -38.627102, linha: "Sul")
        manager.addEstacaoWithName("Maracanaú", latitude: -3.878559, longitude: -38.625588, linha: "Sul")
        manager.addEstacaoWithName("Virgílio Távora", latitude: -3.867129, longitude: -38.620134, linha: "Sul")
        manager.addEstacaoWithName("Rachel de Queiroz", latitude: -3.850466, longitude: -38.608327, linha: "Sul")
        manager.addEstacaoWithName("Alto Alegre", latitude: -3.839299, longitude: -38.600502, linha: "Sul")
        manager.addEstacaoWithName("Aracapé", latitude: -3.825964, longitude: -38.591499, linha: "Sul")
        manager.addEstacaoWithName("Esperança", latitude: -3.816800, longitude: -38.585473, linha: "Sul")
        manager.addEstacaoWithName("Mondubim", latitude: -3.807392, longitude: -38.577355, linha: "Sul")
        manager.addEstacaoWithName("Manoel Sátiro", latitude: -3.798295, longitude: -38.574918, linha: "Sul")
        manager.addEstacaoWithName("Vila Pery", latitude: -3.783916, longitude: -38.571985, linha: "Sul")
        manager.addEstacaoWithName("Parangaba", latitude: -3.775648, longitude: -38.563614, linha: "Sul")
        manager.addEstacaoWithName("Couto Fernandes", latitude: -3.757276, longitude: -38.557599, linha: "Sul")
        manager.addEstacaoWithName("Porangabussu", latitude: -3.751283, longitude: -38.551447, linha: "Sul")
        manager.addEstacaoWithName("Benfica", latitude: -3.739154, longitude: -38.540032, linha: "Sul")
        manager.addEstacaoWithName("São Benedito", latitude: -3.731717, longitude: -38.535000, linha: "Sul")
        manager.addEstacaoWithName("José de Alencar", latitude: -3.726197, longitude: -38.532553, linha: "Sul")
        manager.addEstacaoWithName("Chico da Silva", latitude: -3.721343, longitude: -38.530937, linha: "Sul")
    }
    
    func AddAllHorarios() {
        var manager = ManagerData()
        
        manager.addHorarioWithHora("07:00", sentido: "Ida", estacao: "Carlito Benevides")
        manager.addHorarioWithHora("07:03", sentido: "Ida", estacao: "Jereissati")
        manager.addHorarioWithHora("07:06", sentido: "Ida", estacao: "Maracanaú")
        
    }
    
//    func addRegionsMonitoring() {
//        var manager = ManagerData()
//        var estacoes = manager.getAllEstacoes()
//        var initialViewController = InitialViewController()
//        for estacao in estacoes {
//            println(estacao.nome)
//            println(estacao.latitude)
//            println(estacao.longitude)
//            initialViewController.makeRegionMonitoring(latitude: estacao.latitude as Double, longitude: estacao.longitude as Double, identifier: estacao.nome)
//        }
//    }
    
    func openSession(#allowLoginUI: Bool) -> Bool {
        let permissions = ["public_profile", "email"]
        
        return FBSession.openActiveSessionWithReadPermissions(permissions, allowLoginUI: allowLoginUI, completionHandler: { (var session, var state, var err) -> Void in
            if (err != nil) {
                println("\(err.localizedDescription)")
            } else {
                self.checkSessionState(state: state)
            }
        })
    }
    
    func checkSessionState(#state: FBSessionState){
        
    }

}

