//
//  WBDTreatments+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDTreatments+CoreDataProperties.h"

@implementation WBDTreatments (CoreDataProperties)

+ (NSFetchRequest<WBDTreatments *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WBDTreatments"];
}

@dynamic downloaded;
@dynamic lease;
@dynamic treatmentDate;
@dynamic treatmentDesc;
@dynamic treatmentID;
@dynamic treatmentNotes;
@dynamic wellNum;

@end
