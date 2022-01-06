//
//  WBDInfoSource+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDInfoSource+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WBDInfoSource (CoreDataProperties)

+ (NSFetchRequest<WBDInfoSource *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *infoSourceType;
@property (nonatomic) int32_t sourceID;

@end

NS_ASSUME_NONNULL_END
