//
//  Schedules+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Schedules+CoreDataProperties.h"

@implementation Schedules (CoreDataProperties)

+ (NSFetchRequest<Schedules *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Schedules"];
}

@dynamic acctComments;
@dynamic actEndUserID;
@dynamic actStartUserID;
@dynamic actualEndDt;
@dynamic actualStartDt;
@dynamic criticalEndDt;
@dynamic date;
@dynamic downloaded;
@dynamic engrComments;
@dynamic entryUserID;
@dynamic fieldComments;
@dynamic initialPlanStartDt;
@dynamic lease;
@dynamic planStartDt;
@dynamic scheduleID;
@dynamic scheduleType;
@dynamic status;
@dynamic updatedPlanStartDt;
@dynamic updatedPlanUserID;
@dynamic wellNumber;

@end
