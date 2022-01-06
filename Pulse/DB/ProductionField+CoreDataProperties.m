//
//  ProductionField+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ProductionField+CoreDataProperties.h"

@implementation ProductionField (CoreDataProperties)

+ (NSFetchRequest<ProductionField *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ProductionField"];
}

@dynamic gasVol;
@dynamic lease;
@dynamic leaseField;
@dynamic leaseName;
@dynamic oilVol;
@dynamic prodID;
@dynamic productionDate;
@dynamic waterVol;
@dynamic comments;
@dynamic oilComments;
@dynamic gasComments;
@dynamic waterComments;
@dynamic wellheadComments;
@dynamic wellheadData;


@end
