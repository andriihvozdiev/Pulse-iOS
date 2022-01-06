//
//  ListAssetLocations+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ListAssetLocations+CoreDataProperties.h"

@implementation ListAssetLocations (CoreDataProperties)

+ (NSFetchRequest<ListAssetLocations *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ListAssetLocations"];
}

@dynamic codeProperty;
@dynamic grandparentPropNum;
@dynamic parentPropNum;
@dynamic propNum;
@dynamic propType;

@end
