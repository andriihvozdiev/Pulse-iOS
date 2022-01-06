//
//  InvoicesPersonnel+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "InvoicesPersonnel+CoreDataProperties.h"

@implementation InvoicesPersonnel (CoreDataProperties)

+ (NSFetchRequest<InvoicesPersonnel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"InvoicesPersonnel"];
}

@dynamic deleted;
@dynamic downloaded;
@dynamic invoiceAppID;
@dynamic invoiceID;
@dynamic invoicePersonnelID;
@dynamic userID;

@end
