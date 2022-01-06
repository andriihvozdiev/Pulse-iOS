//
//  WBDInfoSource+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDInfoSource+CoreDataProperties.h"

@implementation WBDInfoSource (CoreDataProperties)

+ (NSFetchRequest<WBDInfoSource *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WBDInfoSource"];
}

@dynamic infoSourceType;
@dynamic sourceID;

@end
