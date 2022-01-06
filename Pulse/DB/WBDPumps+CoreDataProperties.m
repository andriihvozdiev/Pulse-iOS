//
//  WBDPumps+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDPumps+CoreDataProperties.h"

@implementation WBDPumps (CoreDataProperties)

+ (NSFetchRequest<WBDPumps *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WBDPumps"];
}

@dynamic infoNotes;
@dynamic infoSource;
@dynamic lease;
@dynamic pumpDateIn;
@dynamic pumpDesc;
@dynamic pumpID;
@dynamic pumpTypeName;
@dynamic wellNum;

@end
