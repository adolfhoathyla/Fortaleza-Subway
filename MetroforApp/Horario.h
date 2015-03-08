//
//  Horario.h
//  MetroforApp
//
//  Created by Adolfho Athyla on 08/03/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Estacao;

@interface Horario : NSManagedObject

@property (nonatomic, retain) NSString * estacao;
@property (nonatomic, retain) NSString * sentido;
@property (nonatomic, retain) NSString * hora;
@property (nonatomic, retain) Estacao *horarioEstacao;

@end
