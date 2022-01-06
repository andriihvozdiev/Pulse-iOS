//
//  WellheadData+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WellheadData+CoreDataProperties.h"

@implementation WellheadData (CoreDataProperties)

+ (NSFetchRequest<WellheadData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WellheadData"];
}

@dynamic bradenheadPressure;
@dynamic casingPressure;
@dynamic checkTime;
@dynamic choke;
@dynamic comments;
@dynamic dataID;
@dynamic deviceID;
@dynamic downloaded;
@dynamic emulsionCut;
@dynamic entryTime;
@dynamic espAmp;
@dynamic espHz;
@dynamic lease;
@dynamic oilCut;
@dynamic pound;
@dynamic prodType;
@dynamic pumpSize;
@dynamic spm;
@dynamic statusArrival;
@dynamic statusDepart;
@dynamic strokeSize;
@dynamic timeOff;
@dynamic timeOn;
@dynamic tubingPressure;
@dynamic userid;
@dynamic waterCut;
@dynamic wellNumber;
@dynamic wellOn;
@dynamic wellProblem;

@end
