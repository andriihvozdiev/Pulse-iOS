//
//  WellheadData+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WellheadData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WellheadData (CoreDataProperties)

+ (NSFetchRequest<WellheadData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bradenheadPressure;
@property (nullable, nonatomic, copy) NSString *casingPressure;
@property (nullable, nonatomic, copy) NSDate *checkTime;
@property (nullable, nonatomic, copy) NSString *choke;
@property (nullable, nonatomic, copy) NSString *comments;
@property (nonatomic) int32_t dataID;
@property (nullable, nonatomic, copy) NSString *deviceID;
@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSString *emulsionCut;
@property (nullable, nonatomic, copy) NSDate *entryTime;
@property (nullable, nonatomic, copy) NSString *espAmp;
@property (nullable, nonatomic, copy) NSString *espHz;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *oilCut;
@property (nullable, nonatomic, copy) NSString *pound;
@property (nullable, nonatomic, copy) NSString *prodType;
@property (nullable, nonatomic, copy) NSString *pumpSize;
@property (nullable, nonatomic, copy) NSString *spm;
@property (nonatomic) BOOL statusArrival;
@property (nonatomic) BOOL statusDepart;
@property (nullable, nonatomic, copy) NSString *strokeSize;
@property (nullable, nonatomic, copy) NSString *timeOff;
@property (nullable, nonatomic, copy) NSString *timeOn;
@property (nullable, nonatomic, copy) NSString *tubingPressure;
@property (nonatomic) int16_t userid;
@property (nullable, nonatomic, copy) NSString *waterCut;
@property (nullable, nonatomic, copy) NSString *wellNumber;
@property (nonatomic) BOOL wellOn;
@property (nullable, nonatomic, copy) NSString *wellProblem;

@end

NS_ASSUME_NONNULL_END
