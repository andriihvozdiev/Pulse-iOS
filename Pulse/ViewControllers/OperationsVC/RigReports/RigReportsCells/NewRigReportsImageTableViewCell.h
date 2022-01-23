//
//  NewRigReportsImageTableViewCell.h
//  Pulse
//
//  Created by dev on 4/24/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CollectionViewMgrDelegate <NSObject>
-(void)onAddImage;
-(void)onDeleteImage:(NSInteger)index;
@end

@interface NewRigReportsImageTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) id<CollectionViewMgrDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *aryImages;

@end

NS_ASSUME_NONNULL_END
