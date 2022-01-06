//
//  WBDRods+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDRods+CoreDataProperties.h"

@implementation WBDRods (CoreDataProperties)

+ (NSFetchRequest<WBDRods *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WBDRods"];
}

@dynamic couplingCode;
@dynamic extSize;
@dynamic extSizeID;
@dynamic infoSource;
@dynamic invRodsQty;
@dynamic lease;
@dynamic length;
@dynamic rodType;
@dynamic segmentID;
@dynamic segmentOrder;
@dynamic wbRodsDesc;
@dynamic wbRodsDtIn;
@dynamic wbRodsID;
@dynamic wbRodsQty;
@dynamic wellNum;

@end
