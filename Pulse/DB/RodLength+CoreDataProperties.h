//
//  RodLength+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RodLength+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RodLength (CoreDataProperties)

+ (NSFetchRequest<RodLength *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *nominalSize;
@property (nonatomic) int32_t rodLengthID;
@property (nullable, nonatomic, copy) NSString *rodSize;

@end

NS_ASSUME_NONNULL_END
