//
//  PulseProdField+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "PulseProdField+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PulseProdField (CoreDataProperties)

+ (NSFetchRequest<PulseProdField *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fieldName;
@property (nullable, nonatomic, copy) NSString *gasCalcType;
@property (nullable, nonatomic, copy) NSString *gasVol;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *leaseName;
@property (nullable, nonatomic, copy) NSString *oilCalcType;
@property (nullable, nonatomic, copy) NSString *oilVol;
@property (nonatomic) int16_t prodID;
@property (nullable, nonatomic, copy) NSString *waterCalcType;
@property (nullable, nonatomic, copy) NSString *waterVol;

@end

NS_ASSUME_NONNULL_END
