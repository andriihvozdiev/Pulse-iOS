//
//  ProductionAvg+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ProductionAvg+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProductionAvg (CoreDataProperties)

+ (NSFetchRequest<ProductionAvg *> *)fetchRequest;

@property (nonatomic) BOOL allocatedVolume;
@property (nullable, nonatomic, copy) NSString *gas7;
@property (nullable, nonatomic, copy) NSString *gas30;
@property (nullable, nonatomic, copy) NSString *gas365;
@property (nullable, nonatomic, copy) NSString *gasP30;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *leaseName;
@property (nullable, nonatomic, copy) NSString *oil7;
@property (nullable, nonatomic, copy) NSString *oil30;
@property (nullable, nonatomic, copy) NSString *oil365;
@property (nullable, nonatomic, copy) NSString *oilP30;
@property (nonatomic) int32_t prodID;
@property (nullable, nonatomic, copy) NSDate *productionDate;
@property (nullable, nonatomic, copy) NSString *water7;
@property (nullable, nonatomic, copy) NSString *water30;
@property (nullable, nonatomic, copy) NSString *water365;
@property (nullable, nonatomic, copy) NSString *waterP30;

@end

NS_ASSUME_NONNULL_END
