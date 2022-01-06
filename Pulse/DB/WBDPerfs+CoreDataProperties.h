//
//  WBDPerfs+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDPerfs+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WBDPerfs (CoreDataProperties)

+ (NSFetchRequest<WBDPerfs *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSDate *perfDate;
@property (nullable, nonatomic, copy) NSString *perfDesc;
@property (nonatomic) int32_t perfID;
@property (nonatomic) int32_t perfZoneEnd;
@property (nonatomic) int32_t perfZoneStart;
@property (nullable, nonatomic, copy) NSString *wellNum;
@property (nonatomic) BOOL wellPerf;

@end

NS_ASSUME_NONNULL_END
