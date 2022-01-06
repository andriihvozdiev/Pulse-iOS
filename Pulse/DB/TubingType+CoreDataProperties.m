//
//  TubingType+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "TubingType+CoreDataProperties.h"

@implementation TubingType (CoreDataProperties)

+ (NSFetchRequest<TubingType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TubingType"];
}

@dynamic tbgType;
@dynamic tbgTypeID;

@end
