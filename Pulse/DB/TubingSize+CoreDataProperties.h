//
//  TubingSize+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "TubingSize+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TubingSize (CoreDataProperties)

+ (NSFetchRequest<TubingSize *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *nominalSize;
@property (nullable, nonatomic, copy) NSString *tbgSize;
@property (nonatomic) int16_t tbgSizeID;

@end

NS_ASSUME_NONNULL_END
