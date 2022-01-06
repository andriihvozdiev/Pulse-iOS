//
//  Meters+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Meters+CoreDataProperties.h"

@implementation Meters (CoreDataProperties)

+ (NSFetchRequest<Meters *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Meters"];
}

@dynamic active;
@dynamic appName;
@dynamic gasMeterID;
@dynamic meterID;
@dynamic meterLease;
@dynamic meterName;
@dynamic meterType;
@dynamic meterWell;
@dynamic waterMeterID;

@end
