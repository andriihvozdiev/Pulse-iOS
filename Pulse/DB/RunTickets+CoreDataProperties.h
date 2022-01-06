//
//  RunTickets+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RunTickets+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RunTickets (CoreDataProperties)

+ (NSFetchRequest<RunTickets *> *)fetchRequest;

@property (nonatomic) int16_t bottomsFeet1;
@property (nonatomic) int16_t bottomsFeet2;
@property (nonatomic) int16_t bottomsInch1;
@property (nonatomic) int16_t bottomsInch2;
@property (nullable, nonatomic, copy) NSString *bsw;
@property (nonatomic) int16_t ticketOption;
@property (nullable, nonatomic, copy) NSString *calcGrossVol;
@property (nullable, nonatomic, copy) NSString *calcNetVol;
@property (nullable, nonatomic, copy) NSString *carrier;
@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSString *deviceID;
@property (nonatomic) BOOL deleted;
@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSString *driver;
@property (nullable, nonatomic, copy) NSDate *entryTime;
@property (nonatomic) int16_t glMonth;
@property (nonatomic) int16_t glYear;
@property (nullable, nonatomic, copy) NSString *grossVol;
@property (nonatomic) int32_t internalTicketID;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *netVol;
@property (nullable, nonatomic, copy) NSString *obsGrav;
@property (nonatomic) int16_t obsTemp;
@property (nonatomic) int16_t oilFeet1;
@property (nonatomic) int16_t oilFeet2;
@property (nonatomic) int16_t oilFraction1;
@property (nonatomic) int16_t oilFraction2;
@property (nonatomic) int16_t oilInch1;
@property (nonatomic) int16_t oilInch2;
@property (nonatomic) int16_t tankNumber;
@property (nonatomic) int16_t temp1;
@property (nonatomic) int16_t temp2;
@property (nullable, nonatomic, copy) NSString *ticketImage;
@property (nullable, nonatomic, copy) NSString *ticketNumber;
@property (nullable, nonatomic, copy) NSDate *ticketTime;
@property (nullable, nonatomic, copy) NSDate *timeOff;
@property (nullable, nonatomic, copy) NSDate *timeOn;
@property (nonatomic) int32_t userid;

@end

NS_ASSUME_NONNULL_END
