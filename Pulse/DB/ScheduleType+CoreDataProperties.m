//
//  ScheduleType+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ScheduleType+CoreDataProperties.h"

@implementation ScheduleType (CoreDataProperties)

+ (NSFetchRequest<ScheduleType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ScheduleType"];
}

@dynamic category;
@dynamic scheduleTypeID;
@dynamic type;

@end
