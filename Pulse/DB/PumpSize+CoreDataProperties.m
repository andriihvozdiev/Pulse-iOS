//
//  PumpSize+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "PumpSize+CoreDataProperties.h"

@implementation PumpSize (CoreDataProperties)

+ (NSFetchRequest<PumpSize *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PumpSize"];
}

@dynamic nominalSize;
@dynamic size;

@end
