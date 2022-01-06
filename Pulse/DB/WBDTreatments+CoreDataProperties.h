//
//  WBDTreatments+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDTreatments+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WBDTreatments (CoreDataProperties)

+ (NSFetchRequest<WBDTreatments *> *)fetchRequest;

@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *treatmentDate;
@property (nullable, nonatomic, copy) NSString *treatmentDesc;
@property (nonatomic) int16_t treatmentID;
@property (nullable, nonatomic, copy) NSString *treatmentNotes;
@property (nullable, nonatomic, copy) NSString *wellNum;

@end

NS_ASSUME_NONNULL_END
