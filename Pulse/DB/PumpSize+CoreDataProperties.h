//
//  PumpSize+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "PumpSize+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PumpSize (CoreDataProperties)

+ (NSFetchRequest<PumpSize *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *nominalSize;
@property (nullable, nonatomic, copy) NSString *size;

@end

NS_ASSUME_NONNULL_END
