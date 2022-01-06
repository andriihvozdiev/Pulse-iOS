//
//  Schedules+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Schedules+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Schedules (CoreDataProperties)

+ (NSFetchRequest<Schedules *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *acctComments;
@property (nonatomic) int32_t actEndUserID;
@property (nonatomic) int32_t actStartUserID;
@property (nullable, nonatomic, copy) NSDate *actualEndDt;
@property (nullable, nonatomic, copy) NSDate *actualStartDt;
@property (nullable, nonatomic, copy) NSDate *criticalEndDt;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSString *engrComments;
@property (nonatomic) int32_t entryUserID;
@property (nullable, nonatomic, copy) NSString *fieldComments;
@property (nullable, nonatomic, copy) NSDate *initialPlanStartDt;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSDate *planStartDt;
@property (nonatomic) int32_t scheduleID;
@property (nullable, nonatomic, copy) NSString *scheduleType;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSDate *updatedPlanStartDt;
@property (nonatomic) int32_t updatedPlanUserID;
@property (nullable, nonatomic, copy) NSString *wellNumber;

@end

NS_ASSUME_NONNULL_END
