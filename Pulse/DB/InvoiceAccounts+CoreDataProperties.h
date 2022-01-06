//
//  InvoiceAccounts+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "InvoiceAccounts+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface InvoiceAccounts (CoreDataProperties)

+ (NSFetchRequest<InvoiceAccounts *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *account;
@property (nonatomic) int32_t acctID;
@property (nullable, nonatomic, copy) NSString *outbillLookup;
@property (nullable, nonatomic, copy) NSString *subAccount;
@property (nonatomic) int32_t subAcctID;
@property (nullable, nonatomic, copy) NSString *subAcctTimeUnits;
@property (nullable, nonatomic, copy) NSString *unitCost;
@property (nullable, nonatomic, copy) NSString *unitCostOutCharge;
@property (nullable, nonatomic, copy) NSString *wpExpAcct;
@property (nullable, nonatomic, copy) NSString *wpExpJournal;
@property (nullable, nonatomic, copy) NSString *wpExpReference;
@property (nullable, nonatomic, copy) NSString *wpIncAcct;
@property (nullable, nonatomic, copy) NSString *wpIncJournal;
@property (nullable, nonatomic, copy) NSString *wpIncReference;
@property (nullable, nonatomic, copy) NSString *wpIncSubAcct;

@end

NS_ASSUME_NONNULL_END
