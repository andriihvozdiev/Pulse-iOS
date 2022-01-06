//
//  PulseProdHome+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "PulseProdHome+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PulseProdHome (CoreDataProperties)

+ (NSFetchRequest<PulseProdHome *> *)fetchRequest;

@property (nonatomic) BOOL allocatedVolume;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *gasComments;
@property (nullable, nonatomic, copy) NSString *gasVol;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *leaseName;
@property (nullable, nonatomic, copy) NSString *oilComments;
@property (nullable, nonatomic, copy) NSString *oilVol;
@property (nullable, nonatomic, copy) NSString *operator;
@property (nullable, nonatomic, copy) NSString *owner;
@property (nonatomic) int32_t prodID;
@property (nonatomic) int32_t route;
@property (nullable, nonatomic, copy) NSString *waterComments;
@property (nullable, nonatomic, copy) NSString *waterVol;
@property (nullable, nonatomic, copy) NSString *wellheadComments;
@property (nullable, nonatomic, copy) NSString *wellheadData;

@end

NS_ASSUME_NONNULL_END
