//
//  WBDPumps+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDPumps+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WBDPumps (CoreDataProperties)

+ (NSFetchRequest<WBDPumps *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *infoNotes;
@property (nonatomic) int32_t infoSource;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSDate *pumpDateIn;
@property (nullable, nonatomic, copy) NSString *pumpDesc;
@property (nonatomic) int32_t pumpID;
@property (nullable, nonatomic, copy) NSString *pumpTypeName;
@property (nullable, nonatomic, copy) NSString *wellNum;

@end

NS_ASSUME_NONNULL_END
