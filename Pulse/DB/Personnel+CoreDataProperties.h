//
//  Personnel+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "Personnel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Personnel (CoreDataProperties)

+ (NSFetchRequest<Personnel *> *)fetchRequest;

@property (nonatomic) BOOL active;
@property (nullable, nonatomic, copy) NSString *department;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *employeeName;
@property (nonatomic) BOOL invPersonnel;
@property (nonatomic) BOOL noBillApp;
@property (nonatomic) BOOL outsideBillApp;
@property (nonatomic) BOOL primaryApp;
@property (nonatomic) BOOL secondaryApp;
@property (nonatomic) int16_t userid;

@end

NS_ASSUME_NONNULL_END
