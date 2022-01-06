//
//  PulseProdHome+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "PulseProdHome+CoreDataProperties.h"

@implementation PulseProdHome (CoreDataProperties)

+ (NSFetchRequest<PulseProdHome *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PulseProdHome"];
}

@dynamic allocatedVolume;
@dynamic date;
@dynamic gasComments;
@dynamic gasVol;
@dynamic lease;
@dynamic leaseName;
@dynamic oilComments;
@dynamic oilVol;
@dynamic operator;
@dynamic owner;
@dynamic prodID;
@dynamic route;
@dynamic waterComments;
@dynamic waterVol;
@dynamic wellheadComments;
@dynamic wellheadData;

@end
