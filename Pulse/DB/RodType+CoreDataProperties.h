//
//  RodType+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RodType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RodType (CoreDataProperties)

+ (NSFetchRequest<RodType *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *rodType;
@property (nonatomic) int32_t rodTypeID;

@end

NS_ASSUME_NONNULL_END
