//
//  TankGaugeEntry+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "TankGaugeEntry+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TankGaugeEntry (CoreDataProperties)

+ (NSFetchRequest<TankGaugeEntry *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bswVol;
@property (nullable, nonatomic, copy) NSString *bswVol24;
@property (nullable, nonatomic, copy) NSString *calc24Bbls;
@property (nullable, nonatomic, copy) NSString *calcBbls;
@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSString *deviceID;
@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSDate *entryTime;
@property (nullable, nonatomic, copy) NSDate *gaugeTime;
@property (nullable, nonatomic, copy) NSDate *hr24GgDt;
@property (nullable, nonatomic, copy) NSDate *lastGgDt;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nonatomic) BOOL negProdQC;
@property (nonatomic) int16_t oilFeet1;
@property (nonatomic) int16_t oilFeet2;
@property (nonatomic) int16_t oilFeet3;
@property (nonatomic) int16_t oilFeet4;
@property (nonatomic) int16_t oilFeet5;
@property (nonatomic) int16_t oilFeet6;
@property (nonatomic) int16_t oilFeet7;
@property (nonatomic) int16_t oilFeet8;
@property (nonatomic) int16_t oilFeet9;
@property (nonatomic) int16_t oilFeet10;
@property (nullable, nonatomic, copy) NSString *onHandOil;
@property (nullable, nonatomic, copy) NSString *runTicketVol;
@property (nullable, nonatomic, copy) NSString *runTicketVol24;
@property (nonatomic) int32_t tankGaugeID;
@property (nonatomic) int16_t tankID1;
@property (nonatomic) int16_t tankID2;
@property (nonatomic) int16_t tankID3;
@property (nonatomic) int16_t tankID4;
@property (nonatomic) int16_t tankID5;
@property (nonatomic) int16_t tankID6;
@property (nonatomic) int16_t tankID7;
@property (nonatomic) int16_t tankID8;
@property (nonatomic) int16_t tankID9;
@property (nonatomic) int16_t tankID10;
@property (nonatomic) int16_t userid;

@end

NS_ASSUME_NONNULL_END
