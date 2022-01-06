//
//  WBDPerfs+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDPerfs+CoreDataProperties.h"

@implementation WBDPerfs (CoreDataProperties)

+ (NSFetchRequest<WBDPerfs *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WBDPerfs"];
}

@dynamic lease;
@dynamic perfDate;
@dynamic perfDesc;
@dynamic perfID;
@dynamic perfZoneEnd;
@dynamic perfZoneStart;
@dynamic wellNum;
@dynamic wellPerf;

@end
