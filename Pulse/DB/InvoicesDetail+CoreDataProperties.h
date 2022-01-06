//
//  InvoicesDetail+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "InvoicesDetail+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface InvoicesDetail (CoreDataProperties)

+ (NSFetchRequest<InvoicesDetail *> *)fetchRequest;

@property (nonatomic) int32_t account;
@property (nonatomic) int32_t accountSub;
@property (nullable, nonatomic, copy) NSString *accountTime;
@property (nullable, nonatomic, copy) NSString *accountUnit;
@property (nonatomic) BOOL deleted;
@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSString *invoiceAppID;
@property (nonatomic) int32_t invoiceDetailID;
@property (nonatomic) int32_t invoiceID;

@end

NS_ASSUME_NONNULL_END
