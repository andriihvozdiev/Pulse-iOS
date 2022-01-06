//
//  Tanks+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Tanks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tanks (CoreDataProperties)

+ (NSFetchRequest<Tanks *> *)fetchRequest;

@property (nonatomic) BOOL current;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *rrc;
@property (nonatomic) int32_t tankID;
@property (nullable, nonatomic, copy) NSString *tankType;

@end

NS_ASSUME_NONNULL_END
