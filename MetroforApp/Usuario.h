//
//  Usuario.h
//  MetroforApp
//
//  Created by Adolfho Athyla on 08/03/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Usuario : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * email;

@end
