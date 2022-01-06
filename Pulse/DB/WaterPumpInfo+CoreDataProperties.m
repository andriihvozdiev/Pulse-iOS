//
//  WaterPumpInfo+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WaterPumpInfo+CoreDataProperties.h"

@implementation WaterPumpInfo (CoreDataProperties)

+ (NSFetchRequest<WaterPumpInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WaterPumpInfo"];
}

@dynamic brand;
@dynamic crankcaseOilCap;
@dynamic crankExtD;
@dynamic crankExtL;
@dynamic fluidEnd;
@dynamic keywayDepth;
@dynamic keywayWidth;
@dynamic maxBHP;
@dynamic maxBPD;
@dynamic maxGPM;
@dynamic maxPlungerD;
@dynamic maxPressure;
@dynamic maxSheaveD;
@dynamic minPlungerD;
@dynamic newName;
@dynamic oldName;
@dynamic plungerAction;
@dynamic plungerLoad;
@dynamic pumpID;
@dynamic pumpTitle;
@dynamic pumpType;
@dynamic rpMatBHP;
@dynamic stroke;

@end
