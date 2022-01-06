//
//  Meters+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Meters+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Meters (CoreDataProperties)

+ (NSFetchRequest<Meters *> *)fetchRequest;

@property (nonatomic) BOOL active;
@property (nullable, nonatomic, copy) NSString *appName;
@property (nonatomic) int32_t gasMeterID;
@property (nonatomic) int32_t meterID;
@property (nullable, nonatomic, copy) NSString *meterLease;
@property (nullable, nonatomic, copy) NSString *meterName;
@property (nullable, nonatomic, copy) NSString *meterType;
@property (nullable, nonatomic, copy) NSString *meterWell;
@property (nonatomic) int32_t waterMeterID;

@end

NS_ASSUME_NONNULL_END
