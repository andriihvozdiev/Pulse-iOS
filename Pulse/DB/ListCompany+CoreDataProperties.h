//
//  ListCompany+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ListCompany+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ListCompany (CoreDataProperties)

+ (NSFetchRequest<ListCompany *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *company;
@property (nullable, nonatomic, copy) NSString *companyCode;

@end

NS_ASSUME_NONNULL_END
