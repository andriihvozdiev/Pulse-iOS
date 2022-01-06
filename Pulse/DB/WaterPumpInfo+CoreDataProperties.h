//
//  WaterPumpInfo+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WaterPumpInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WaterPumpInfo (CoreDataProperties)

+ (NSFetchRequest<WaterPumpInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *brand;
@property (nullable, nonatomic, copy) NSString *crankcaseOilCap;
@property (nullable, nonatomic, copy) NSString *crankExtD;
@property (nullable, nonatomic, copy) NSString *crankExtL;
@property (nullable, nonatomic, copy) NSString *fluidEnd;
@property (nullable, nonatomic, copy) NSString *keywayDepth;
@property (nullable, nonatomic, copy) NSString *keywayWidth;
@property (nullable, nonatomic, copy) NSString *maxBHP;
@property (nonatomic) int16_t maxBPD;
@property (nonatomic) int16_t maxGPM;
@property (nullable, nonatomic, copy) NSString *maxPlungerD;
@property (nonatomic) int16_t maxPressure;
@property (nullable, nonatomic, copy) NSString *maxSheaveD;
@property (nullable, nonatomic, copy) NSString *minPlungerD;
@property (nullable, nonatomic, copy) NSString *newName;
@property (nullable, nonatomic, copy) NSString *oldName;
@property (nullable, nonatomic, copy) NSString *plungerAction;
@property (nonatomic) int16_t plungerLoad;
@property (nonatomic) int16_t pumpID;
@property (nullable, nonatomic, copy) NSString *pumpTitle;
@property (nullable, nonatomic, copy) NSString *pumpType;
@property (nonatomic) int16_t rpMatBHP;
@property (nullable, nonatomic, copy) NSString *stroke;

@end

NS_ASSUME_NONNULL_END
