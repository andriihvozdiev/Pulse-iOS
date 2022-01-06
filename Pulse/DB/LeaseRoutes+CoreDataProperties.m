//
//  LeaseRoutes+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "LeaseRoutes+CoreDataProperties.h"

@implementation LeaseRoutes (CoreDataProperties)

+ (NSFetchRequest<LeaseRoutes *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LeaseRoutes"];
}

@dynamic routeID;
@dynamic routeName;

@end
