//
//  RigReports+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RigReports+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RigReports (CoreDataProperties)

+ (NSFetchRequest<RigReports *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSString *company;
@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSDate *entryDate;
@property (nonatomic) int32_t entryUser;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *reportAppID;
@property (nullable, nonatomic, copy) NSDate *reportDate;
@property (nonatomic) int32_t reportID;
@property (nullable, nonatomic, copy) NSString *rods;
@property (nullable, nonatomic, copy) NSString *tubing;
@property (nullable, nonatomic, copy) NSString *wellNum;
@property (nullable, nonatomic, retain) NSArray *rigImages;
@property (nonatomic) BOOL engrApproval;
@property (nullable, nonatomic, copy) NSString *totalCost;
@property (nullable, nonatomic, copy) NSString *dailyCost;

@end

NS_ASSUME_NONNULL_END
