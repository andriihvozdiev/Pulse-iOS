//
//  RigReportsRods+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RigReportsRods+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RigReportsRods (CoreDataProperties)

+ (NSFetchRequest<RigReportsRods *> *)fetchRequest;

@property (nonatomic) BOOL downloaded;
@property (nonatomic) BOOL inOut;
@property (nullable, nonatomic, copy) NSString *reportAppID;
@property (nonatomic) int16_t reportID;
@property (nonatomic) int16_t rodCount;
@property (nullable, nonatomic, copy) NSString *rodFootage;
@property (nonatomic) int16_t rodID;
@property (nullable, nonatomic, copy) NSString *rodLength;
@property (nonatomic) int16_t rodOrder;
@property (nullable, nonatomic, copy) NSString *rodSize;
@property (nullable, nonatomic, copy) NSString *rodType;

@end

NS_ASSUME_NONNULL_END
