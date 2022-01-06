//
//  WaterMeterData+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WaterMeterData+CoreDataProperties.h"

@implementation WaterMeterData (CoreDataProperties)

+ (NSFetchRequest<WaterMeterData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WaterMeterData"];
}

@dynamic checkTime;
@dynamic comments;
@dynamic currentFlow;
@dynamic deviceID;
@dynamic downloaded;
@dynamic entryTime;
@dynamic lease;
@dynamic location;
@dynamic meterNum;
@dynamic meterProblem;
@dynamic netFlow;
@dynamic time24Hr;
@dynamic totalVolume;
@dynamic userid;
@dynamic vol24Hr;
@dynamic resetVolume;
@dynamic wmdID;
@dynamic yesterdayFlow;

@end
