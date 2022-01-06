//
//  ProductionAvg+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ProductionAvg+CoreDataProperties.h"

@implementation ProductionAvg (CoreDataProperties)

+ (NSFetchRequest<ProductionAvg *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ProductionAvg"];
}

@dynamic allocatedVolume;
@dynamic gas7;
@dynamic gas30;
@dynamic gas365;
@dynamic gasP30;
@dynamic lease;
@dynamic leaseName;
@dynamic oil7;
@dynamic oil30;
@dynamic oil365;
@dynamic oilP30;
@dynamic prodID;
@dynamic productionDate;
@dynamic water7;
@dynamic water30;
@dynamic water365;
@dynamic waterP30;

@end
