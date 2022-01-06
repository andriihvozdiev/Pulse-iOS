//
//  PumpType+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "PumpType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PumpType (CoreDataProperties)

+ (NSFetchRequest<PumpType *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *pumpType;

@end

NS_ASSUME_NONNULL_END
