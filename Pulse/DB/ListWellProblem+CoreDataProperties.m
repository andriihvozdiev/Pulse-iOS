//
//  ListWellProblem+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ListWellProblem+CoreDataProperties.h"

@implementation ListWellProblem (CoreDataProperties)

+ (NSFetchRequest<ListWellProblem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ListWellProblem"];
}

@dynamic reason;
@dynamic reasonCode;

@end
