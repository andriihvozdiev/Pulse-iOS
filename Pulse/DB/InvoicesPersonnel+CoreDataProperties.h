//
//  InvoicesPersonnel+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "InvoicesPersonnel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface InvoicesPersonnel (CoreDataProperties)

+ (NSFetchRequest<InvoicesPersonnel *> *)fetchRequest;

@property (nonatomic) BOOL deleted;
@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSString *invoiceAppID;
@property (nonatomic) int32_t invoiceID;
@property (nonatomic) int32_t invoicePersonnelID;
@property (nonatomic) int32_t userID;

@end

NS_ASSUME_NONNULL_END
