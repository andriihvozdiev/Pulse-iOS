//
//  GasMeterData+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "GasMeterData+CoreDataProperties.h"

@implementation GasMeterData (CoreDataProperties)

+ (NSFetchRequest<GasMeterData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GasMeterData"];
}

@dynamic checkTime;
@dynamic comments;
@dynamic currentFlow;
@dynamic dataID;
@dynamic deviceID;
@dynamic diffPressure;
@dynamic downloaded;
@dynamic entryTime;
@dynamic idGasMeter;
@dynamic lease;
@dynamic linePressure;
@dynamic meterCumVol;
@dynamic meterProblem;
@dynamic userid;
@dynamic wellNumber;
@dynamic yesterdayFlow;

@end
