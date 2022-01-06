//
//  WBDSurveys+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDSurveys+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WBDSurveys (CoreDataProperties)

+ (NSFetchRequest<WBDSurveys *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *comments;
@property (nonatomic) float dogLegSeverity;
@property (nonatomic) float inclination;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nonatomic) float md;
@property (nonatomic) float minHoleSize;
@property (nullable, nonatomic, copy) NSDate *surveyPointDate;
@property (nonatomic) int32_t surveyPointID;
@property (nonatomic) float trueAzimuth;
@property (nonatomic) float tvd;
@property (nullable, nonatomic, copy) NSString *wellNum;

@end

NS_ASSUME_NONNULL_END
