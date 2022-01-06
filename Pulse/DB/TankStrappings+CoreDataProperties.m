//
//  TankStrappings+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "TankStrappings+CoreDataProperties.h"

@implementation TankStrappings (CoreDataProperties)

+ (NSFetchRequest<TankStrappings *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TankStrappings"];
}

@dynamic inc1;
@dynamic inc2;
@dynamic inc3;
@dynamic inc4;
@dynamic inc5;
@dynamic inc6;
@dynamic inc7;
@dynamic inc8;
@dynamic inc9;
@dynamic inc10;
@dynamic rrc;

@end
