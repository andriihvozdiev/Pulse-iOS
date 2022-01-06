//
//  TankStrappings+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "TankStrappings+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TankStrappings (CoreDataProperties)

+ (NSFetchRequest<TankStrappings *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *inc1;
@property (nullable, nonatomic, copy) NSString *inc2;
@property (nullable, nonatomic, copy) NSString *inc3;
@property (nullable, nonatomic, copy) NSString *inc4;
@property (nullable, nonatomic, copy) NSString *inc5;
@property (nullable, nonatomic, copy) NSString *inc6;
@property (nullable, nonatomic, copy) NSString *inc7;
@property (nullable, nonatomic, copy) NSString *inc8;
@property (nullable, nonatomic, copy) NSString *inc9;
@property (nullable, nonatomic, copy) NSString *inc10;
@property (nullable, nonatomic, copy) NSString *rrc;

@end

NS_ASSUME_NONNULL_END
