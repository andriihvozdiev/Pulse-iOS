//
//  InvoicesDetail+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "InvoicesDetail+CoreDataProperties.h"

@implementation InvoicesDetail (CoreDataProperties)

+ (NSFetchRequest<InvoicesDetail *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"InvoicesDetail"];
}

@dynamic account;
@dynamic accountSub;
@dynamic accountTime;
@dynamic accountUnit;
@dynamic deleted;
@dynamic downloaded;
@dynamic invoiceAppID;
@dynamic invoiceDetailID;
@dynamic invoiceID;

@end
