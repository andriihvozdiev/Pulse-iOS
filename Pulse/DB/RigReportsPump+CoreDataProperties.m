//
//  RigReportsPump+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RigReportsPump+CoreDataProperties.h"

@implementation RigReportsPump (CoreDataProperties)

+ (NSFetchRequest<RigReportsPump *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RigReportsPump"];
}

@dynamic downloaded;
@dynamic inOut;
@dynamic pumpID;
@dynamic pumpLength;
@dynamic pumpOrder;
@dynamic pumpSize;
@dynamic pumpType;
@dynamic reportAppID;
@dynamic reportID;

@end
