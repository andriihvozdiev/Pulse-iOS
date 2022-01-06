//
//  WBDSurveys+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDSurveys+CoreDataProperties.h"

@implementation WBDSurveys (CoreDataProperties)

+ (NSFetchRequest<WBDSurveys *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WBDSurveys"];
}

@dynamic comments;
@dynamic dogLegSeverity;
@dynamic inclination;
@dynamic lease;
@dynamic md;
@dynamic minHoleSize;
@dynamic surveyPointDate;
@dynamic surveyPointID;
@dynamic trueAzimuth;
@dynamic tvd;
@dynamic wellNum;

@end
