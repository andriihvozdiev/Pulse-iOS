//
//  DetailInvoiceImageCollectionViewCell.h
//  Pulse
//
//  Created by dev on 4/28/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailInvoiceImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnSelectImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

NS_ASSUME_NONNULL_END
