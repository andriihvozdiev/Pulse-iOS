//
//  RigReportsRods+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RigReportsRods+CoreDataProperties.h"

@implementation RigReportsRods (CoreDataProperties)

+ (NSFetchRequest<RigReportsRods *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RigReportsRods"];
}

@dynamic downloaded;
@dynamic inOut;
@dynamic reportAppID;
@dynamic reportID;
@dynamic rodCount;
@dynamic rodFootage;
@dynamic rodID;
@dynamic rodLength;
@dynamic rodOrder;
@dynamic rodSize;
@dynamic rodType;

@end
