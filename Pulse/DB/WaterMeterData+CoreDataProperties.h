//
//  WaterMeterData+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WaterMeterData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WaterMeterData (CoreDataProperties)

+ (NSFetchRequest<WaterMeterData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *checkTime;
@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSString *currentFlow;
@property (nullable, nonatomic, copy) NSString *deviceID;
@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSDate *entryTime;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *location;
@property (nonatomic) int32_t meterNum;
@property (nullable, nonatomic, copy) NSString *meterProblem;
@property (nullable, nonatomic, copy) NSString *netFlow;
@property (nullable, nonatomic, copy) NSString *time24Hr;
@property (nullable, nonatomic, copy) NSString *totalVolume;
@property (nonatomic) int32_t userid;
@property (nullable, nonatomic, copy) NSString *vol24Hr;
@property (nullable, nonatomic, copy) NSString *resetVolume;
@property (nonatomic) int32_t wmdID;
@property (nullable, nonatomic, copy) NSString *yesterdayFlow;

@end

NS_ASSUME_NONNULL_END
