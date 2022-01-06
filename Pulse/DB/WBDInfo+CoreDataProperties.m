//
//  WBDInfo+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDInfo+CoreDataProperties.h"

@implementation WBDInfo (CoreDataProperties)

+ (NSFetchRequest<WBDInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WBDInfo"];
}

@dynamic infoDate;
@dynamic infoID;
@dynamic infoNotes;
@dynamic infoSource;
@dynamic infoSourceType;
@dynamic lease;
@dynamic recordID;
@dynamic tblName;
@dynamic wellNum;

@end
