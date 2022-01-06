//
//  RodSize+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RodSize+CoreDataProperties.h"

@implementation RodSize (CoreDataProperties)

+ (NSFetchRequest<RodSize *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RodSize"];
}

@dynamic nominalSize;
@dynamic rodSize;
@dynamic rodSizeID;

@end
