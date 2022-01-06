//
//  WBDRods+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDRods+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WBDRods (CoreDataProperties)

+ (NSFetchRequest<WBDRods *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *couplingCode;
@property (nullable, nonatomic, copy) NSString *extSize;
@property (nonatomic) int16_t extSizeID;
@property (nonatomic) int16_t infoSource;
@property (nonatomic) int16_t invRodsQty;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *length;
@property (nullable, nonatomic, copy) NSString *rodType;
@property (nonatomic) int16_t segmentID;
@property (nonatomic) int16_t segmentOrder;
@property (nullable, nonatomic, copy) NSString *wbRodsDesc;
@property (nullable, nonatomic, copy) NSDate *wbRodsDtIn;
@property (nonatomic) int16_t wbRodsID;
@property (nonatomic) int16_t wbRodsQty;
@property (nullable, nonatomic, copy) NSString *wellNum;

@end

NS_ASSUME_NONNULL_END
