//
//  RodLength+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RodLength+CoreDataProperties.h"

@implementation RodLength (CoreDataProperties)

+ (NSFetchRequest<RodLength *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RodLength"];
}

@dynamic nominalSize;
@dynamic rodLengthID;
@dynamic rodSize;

@end
