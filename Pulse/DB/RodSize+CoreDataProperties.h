//
//  RodSize+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RodSize+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RodSize (CoreDataProperties)

+ (NSFetchRequest<RodSize *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *nominalSize;
@property (nullable, nonatomic, copy) NSString *rodSize;
@property (nonatomic) int16_t rodSizeID;

@end

NS_ASSUME_NONNULL_END
