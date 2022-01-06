//
//  RigReportsPump+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RigReportsPump+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RigReportsPump (CoreDataProperties)

+ (NSFetchRequest<RigReportsPump *> *)fetchRequest;

@property (nonatomic) BOOL downloaded;
@property (nonatomic) BOOL inOut;
@property (nonatomic) int32_t pumpID;
@property (nullable, nonatomic, copy) NSString *pumpLength;
@property (nonatomic) int32_t pumpOrder;
@property (nullable, nonatomic, copy) NSString *pumpSize;
@property (nullable, nonatomic, copy) NSString *pumpType;
@property (nullable, nonatomic, copy) NSString *reportAppID;
@property (nonatomic) int32_t reportID;

@end

NS_ASSUME_NONNULL_END
