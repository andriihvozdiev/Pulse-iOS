//
//  TubingType+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "TubingType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TubingType (CoreDataProperties)

+ (NSFetchRequest<TubingType *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *tbgType;
@property (nonatomic) int32_t tbgTypeID;

@end

NS_ASSUME_NONNULL_END