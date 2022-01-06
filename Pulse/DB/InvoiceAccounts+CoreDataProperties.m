//
//  InvoiceAccounts+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "InvoiceAccounts+CoreDataProperties.h"

@implementation InvoiceAccounts (CoreDataProperties)

+ (NSFetchRequest<InvoiceAccounts *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"InvoiceAccounts"];
}

@dynamic account;
@dynamic acctID;
@dynamic outbillLookup;
@dynamic subAccount;
@dynamic subAcctID;
@dynamic subAcctTimeUnits;
@dynamic unitCost;
@dynamic unitCostOutCharge;
@dynamic wpExpAcct;
@dynamic wpExpJournal;
@dynamic wpExpReference;
@dynamic wpIncAcct;
@dynamic wpIncJournal;
@dynamic wpIncReference;
@dynamic wpIncSubAcct;

@end
