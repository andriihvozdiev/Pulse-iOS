//
//  ListMeterProblem+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ListMeterProblem+CoreDataProperties.h"

@implementation ListMeterProblem (CoreDataProperties)

+ (NSFetchRequest<ListMeterProblem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ListMeterProblem"];
}

@dynamic reason;
@dynamic reasonCode;

@end
