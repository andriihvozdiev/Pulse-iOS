//
//  ListAssetLocations+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ListAssetLocations+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ListAssetLocations (CoreDataProperties)

+ (NSFetchRequest<ListAssetLocations *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *codeProperty;
@property (nullable, nonatomic, copy) NSString *grandparentPropNum;
@property (nullable, nonatomic, copy) NSString *parentPropNum;
@property (nullable, nonatomic, copy) NSString *propNum;
@property (nullable, nonatomic, copy) NSString *propType;

@end

NS_ASSUME_NONNULL_END
