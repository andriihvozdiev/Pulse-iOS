//
//  ScheduleType+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ScheduleType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ScheduleType (CoreDataProperties)

+ (NSFetchRequest<ScheduleType *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *category;
@property (nonatomic) int32_t scheduleTypeID;
@property (nullable, nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
