//
//  RigReports+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RigReports+CoreDataProperties.h"

@implementation RigReports (CoreDataProperties)

+ (NSFetchRequest<RigReports *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RigReports"];
}

@dynamic comments;
@dynamic company;
@dynamic downloaded;
@dynamic entryDate;
@dynamic entryUser;
@dynamic lease;
@dynamic reportAppID;
@dynamic reportDate;
@dynamic reportID;
@dynamic rods;
@dynamic tubing;
@dynamic wellNum;
@dynamic engrApproval;
@dynamic totalCost;
@dynamic dailyCost;
@dynamic rigImages;

@end
