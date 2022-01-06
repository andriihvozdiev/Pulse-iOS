//
//  WBDPlugs+CoreDataProperties.h
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "WBDPlugs+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WBDPlugs (CoreDataProperties)

+ (NSFetchRequest<WBDPlugs *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSDate *infoDate;
@property (nullable, nonatomic, copy) NSString *infoNotes;
@property (nonatomic) int32_t infoSource;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSDate *plugDateIn;
@property (nonatomic) int32_t plugDepth;
@property (nonatomic) int32_t plugID;
@property (nullable, nonatomic, copy) NSString *plugModel;
@property (nullable, nonatomic, copy) NSString *plugType;
@property (nullable, nonatomic, copy) NSString *wellNum;

@end

NS_ASSUME_NONNULL_END
