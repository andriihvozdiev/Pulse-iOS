//
//  LeaseRoutes+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "LeaseRoutes+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LeaseRoutes (CoreDataProperties)

+ (NSFetchRequest<LeaseRoutes *> *)fetchRequest;

@property (nonatomic) int32_t routeID;
@property (nullable, nonatomic, copy) NSString *routeName;

@end

NS_ASSUME_NONNULL_END
