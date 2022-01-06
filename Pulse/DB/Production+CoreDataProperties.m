//
//  Production+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Production+CoreDataProperties.h"

@implementation Production (CoreDataProperties)

+ (NSFetchRequest<Production *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Production"];
}

@dynamic allocatedVolume;
@dynamic comments;
@dynamic gasComments;
@dynamic gasVol;
@dynamic lease;
@dynamic leaseName;
@dynamic oilComments;
@dynamic oilVol;
@dynamic prodID;
@dynamic productionDate;
@dynamic waterComments;
@dynamic waterVol;
@dynamic wellheadComments;
@dynamic wellheadData;

@end
