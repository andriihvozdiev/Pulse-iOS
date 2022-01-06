//
//  ListCompany+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ListCompany+CoreDataProperties.h"

@implementation ListCompany (CoreDataProperties)

+ (NSFetchRequest<ListCompany *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ListCompany"];
}

@dynamic company;
@dynamic companyCode;

@end
