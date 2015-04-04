//
//  EstacaoMaisProxima.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 04/04/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit

class EstacaoMaisProxima: NSObject {
    var nome: String
    var latitude: Double
    var longitude: Double
    var distance: Double
    
    init(nome: String, latitude: Double, longitude: Double, distance: Double) {
        self.nome = nome
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        
    }
}
