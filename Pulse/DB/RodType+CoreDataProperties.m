//
//  RodType+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RodType+CoreDataProperties.h"

@implementation RodType (CoreDataProperties)

+ (NSFetchRequest<RodType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RodType"];
}

@dynamic rodType;
@dynamic rodTypeID;

@end
