//
//  PulseProdField+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "PulseProdField+CoreDataProperties.h"

@implementation PulseProdField (CoreDataProperties)

+ (NSFetchRequest<PulseProdField *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PulseProdField"];
}

@dynamic fieldName;
@dynamic gasCalcType;
@dynamic gasVol;
@dynamic lease;
@dynamic leaseName;
@dynamic oilCalcType;
@dynamic oilVol;
@dynamic prodID;
@dynamic waterCalcType;
@dynamic waterVol;

@end
