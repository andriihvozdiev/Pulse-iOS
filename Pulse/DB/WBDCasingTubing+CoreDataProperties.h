//
//  WBDCasingTubing+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDCasingTubing+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WBDCasingTubing (CoreDataProperties)

+ (NSFetchRequest<WBDCasingTubing *> *)fetchRequest;

@property (nonatomic) int16_t cmtCalcToC;
@property (nullable, nonatomic, copy) NSString *cmtDesc;
@property (nonatomic) int16_t cmtSxQty;
@property (nonatomic) int16_t cmtToC;
@property (nullable, nonatomic, copy) NSString *cmtVerificationType;
@property (nonatomic) int16_t cmtVerifiedToC;
@property (nonatomic) int16_t cmtVolSlurry;
@property (nullable, nonatomic, copy) NSString *coating;
@property (nonatomic) int16_t endDepth;
@property (nullable, nonatomic, copy) NSString *extSize;
@property (nonatomic) int16_t extSizeID;
@property (nullable, nonatomic, copy) NSDate *infoDate;
@property (nonatomic) int16_t infoSource;
@property (nullable, nonatomic, copy) NSString *invLinker;
@property (nonatomic) int16_t invQty;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *length;
@property (nonatomic) int16_t segmentID;
@property (nonatomic) int16_t segmentOrder;
@property (nonatomic) int16_t startDepth;
@property (nullable, nonatomic, copy) NSString *threadType;
@property (nullable, nonatomic, copy) NSString *tubularType;
@property (nonatomic) BOOL wbCasing;
@property (nonatomic) int32_t wbCasingTubingID;
@property (nullable, nonatomic, copy) NSDate *wbDateIn;
@property (nonatomic) int16_t wbQty;
@property (nonatomic) BOOL wbTubing;
@property (nullable, nonatomic, copy) NSString *weight;
@property (nullable, nonatomic, copy) NSString *wellNum;

@end

NS_ASSUME_NONNULL_END
