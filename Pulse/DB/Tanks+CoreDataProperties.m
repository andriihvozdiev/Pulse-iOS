//
//  Tanks+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Tanks+CoreDataProperties.h"

@implementation Tanks (CoreDataProperties)

+ (NSFetchRequest<Tanks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Tanks"];
}

@dynamic current;
@dynamic lease;
@dynamic rrc;
@dynamic tankID;
@dynamic tankType;

@end
