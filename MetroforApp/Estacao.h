//
//  Estacao.h
//  MetroforApp
//
//  Created by Adolfho Athyla on 28/02/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Linha;

@interface Estacao : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * linha;
@property (nonatomic, retain) Linha *estacaoLinha;

@end
