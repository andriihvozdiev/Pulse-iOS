//
//  WBDCasingTubing+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDCasingTubing+CoreDataProperties.h"

@implementation WBDCasingTubing (CoreDataProperties)

+ (NSFetchRequest<WBDCasingTubing *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WBDCasingTubing"];
}

@dynamic cmtCalcToC;
@dynamic cmtDesc;
@dynamic cmtSxQty;
@dynamic cmtToC;
@dynamic cmtVerificationType;
@dynamic cmtVerifiedToC;
@dynamic cmtVolSlurry;
@dynamic coating;
@dynamic endDepth;
@dynamic extSize;
@dynamic extSizeID;
@dynamic infoDate;
@dynamic infoSource;
@dynamic invLinker;
@dynamic invQty;
@dynamic lease;
@dynamic length;
@dynamic segmentID;
@dynamic segmentOrder;
@dynamic startDepth;
@dynamic threadType;
@dynamic tubularType;
@dynamic wbCasing;
@dynamic wbCasingTubingID;
@dynamic wbDateIn;
@dynamic wbQty;
@dynamic wbTubing;
@dynamic weight;
@dynamic wellNum;

@end
