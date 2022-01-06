//
//  Personnel+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Personnel+CoreDataProperties.h"

@implementation Personnel (CoreDataProperties)

+ (NSFetchRequest<Personnel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Personnel"];
}

@dynamic active;
@dynamic department;
@dynamic email;
@dynamic employeeName;
@dynamic invPersonnel;
@dynamic noBillApp;
@dynamic outsideBillApp;
@dynamic primaryApp;
@dynamic secondaryApp;
@dynamic userid;

@end
