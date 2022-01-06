//
//  RigReportsTubing+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RigReportsTubing+CoreDataProperties.h"

@implementation RigReportsTubing (CoreDataProperties)

+ (NSFetchRequest<RigReportsTubing *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RigReportsTubing"];
}

@dynamic downloaded;
@dynamic inOut;
@dynamic reportAppID;
@dynamic reportID;
@dynamic tubingCount;
@dynamic tubingFootage;
@dynamic tubingID;
@dynamic tubingLength;
@dynamic tubingOrder;
@dynamic tubingSize;
@dynamic tubingType;

@end
