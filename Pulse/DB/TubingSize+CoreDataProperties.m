//
//  TubingSize+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "TubingSize+CoreDataProperties.h"

@implementation TubingSize (CoreDataProperties)

+ (NSFetchRequest<TubingSize *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TubingSize"];
}

@dynamic nominalSize;
@dynamic tbgSize;
@dynamic tbgSizeID;

@end
