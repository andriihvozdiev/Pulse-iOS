//
//  NewInvoiceImageCell.h
//  Pulse
//
//  Created by dev on 4/26/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionViewMgrDelegateForInvoice <NSObject>
-(void)onAddImage;
-(void)onDeleteImage:(NSInteger)index;
@end

@interface NewInvoiceImageCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) id<CollectionViewMgrDelegateForInvoice> delegate;
@property (retain, nonatomic) NSMutableArray *aryImages;

@end

NS_ASSUME_NONNULL_END
