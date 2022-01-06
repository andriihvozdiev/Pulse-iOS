//
//  Production+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Production+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Production (CoreDataProperties)

+ (NSFetchRequest<Production *> *)fetchRequest;

@property (nonatomic) BOOL allocatedVolume;
@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSString *gasComments;
@property (nullable, nonatomic, copy) NSString *gasVol;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *leaseName;
@property (nullable, nonatomic, copy) NSString *oilComments;
@property (nullable, nonatomic, copy) NSString *oilVol;
@property (nonatomic) int32_t prodID;
@property (nullable, nonatomic, copy) NSDate *productionDate;
@property (nullable, nonatomic, copy) NSString *waterComments;
@property (nullable, nonatomic, copy) NSString *waterVol;
@property (nullable, nonatomic, copy) NSString *wellheadComments;
@property (nullable, nonatomic, copy) NSString *wellheadData;

@end

NS_ASSUME_NONNULL_END
