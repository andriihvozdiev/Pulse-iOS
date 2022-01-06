//
//  WBDInfo+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WBDInfo (CoreDataProperties)

+ (NSFetchRequest<WBDInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *infoDate;
@property (nonatomic) int32_t infoID;
@property (nullable, nonatomic, copy) NSString *infoNotes;
@property (nonatomic) int32_t infoSource;
@property (nullable, nonatomic, copy) NSString *infoSourceType;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nonatomic) int32_t recordID;
@property (nullable, nonatomic, copy) NSString *tblName;
@property (nullable, nonatomic, copy) NSString *wellNum;

@end

NS_ASSUME_NONNULL_END
