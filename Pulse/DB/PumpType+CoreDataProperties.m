//
//  PumpType+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "PumpType+CoreDataProperties.h"

@implementation PumpType (CoreDataProperties)

+ (NSFetchRequest<PumpType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PumpType"];
}

@dynamic pumpType;

@end
