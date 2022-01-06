//
//  ListMeterProblem+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "ListMeterProblem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ListMeterProblem (CoreDataProperties)

+ (NSFetchRequest<ListMeterProblem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *reason;
@property (nullable, nonatomic, copy) NSString *reasonCode;

@end

NS_ASSUME_NONNULL_END
