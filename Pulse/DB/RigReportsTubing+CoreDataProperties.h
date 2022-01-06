//
//  RigReportsTubing+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RigReportsTubing+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RigReportsTubing (CoreDataProperties)

+ (NSFetchRequest<RigReportsTubing *> *)fetchRequest;

@property (nonatomic) BOOL downloaded;
@property (nonatomic) BOOL inOut;
@property (nullable, nonatomic, copy) NSString *reportAppID;
@property (nonatomic) int32_t reportID;
@property (nonatomic) int32_t tubingCount;
@property (nullable, nonatomic, copy) NSString *tubingFootage;
@property (nonatomic) int32_t tubingID;
@property (nullable, nonatomic, copy) NSString *tubingLength;
@property (nonatomic) int32_t tubingOrder;
@property (nullable, nonatomic, copy) NSString *tubingSize;
@property (nullable, nonatomic, copy) NSString *tubingType;

@end

NS_ASSUME_NONNULL_END
