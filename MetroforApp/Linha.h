//
//  Linha.h
//  MetroforApp
//
//  Created by Adolfho Athyla on 28/02/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Estacao;

@interface Linha : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) Estacao *linhaEstacao;

@end
