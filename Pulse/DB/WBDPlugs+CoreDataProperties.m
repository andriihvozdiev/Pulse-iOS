//
//  WBDPlugs+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDPlugs+CoreDataProperties.h"

@implementation WBDPlugs (CoreDataProperties)

+ (NSFetchRequest<WBDPlugs *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WBDPlugs"];
}

@dynamic comments;
@dynamic infoDate;
@dynamic infoNotes;
@dynamic infoSource;
@dynamic lease;
@dynamic plugDateIn;
@dynamic plugDepth;
@dynamic plugID;
@dynamic plugModel;
@dynamic plugType;
@dynamic wellNum;

@end
