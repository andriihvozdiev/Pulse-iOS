//
//  NewInvoiceImageCell.m
//  Pulse
//
//  Created by dev on 4/26/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

#import "NewInvoiceImageCell.h"
#import "NewInvoiceImageCollectionViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@implementation NewInvoiceImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.aryImages = [[NSMutableArray alloc] init];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onAddImage:(id)sender {
    [self.delegate onAddImage];
}
- (IBAction)onSelectImage:(UIButton*)sender {
    [self.delegate onDeleteImage:sender.tag];
}

#pragma mark-UICollectionView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewInvoiceAddImageCollectionViewCell" forIndexPath:indexPath];
        UIButton *btnAddImage = (UIButton*) [cell viewWithTag:1111];
        btnAddImage.layer.cornerRadius = 3.0;
        btnAddImage.layer.borderColor = [UIColor whiteColor].CGColor;
        btnAddImage.layer.borderWidth = 1.0;
        return cell;
    } else {
        NewInvoiceImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewInvoiceImageCollectionViewCell" forIndexPath:indexPath];
        UIImageView *imageView = (UIImageView*) [cell viewWithTag:1111];
        imageView.layer.cornerRadius = 3.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1.0;
        if (self.aryImages != nil) {
            NSObject *obj = self.aryImages[indexPath.row - 1];
            if ([obj isKindOfClass:[UIImage class]]) {
                [imageView setImage:(UIImage*)obj];
            } else if ([obj isKindOfClass:[NSString class]]) {
                NSString *url_str = [NSString stringWithFormat:@"%@%@%@", BASE_URL, ASSETS_BASE_URL, (NSString*)obj];
                [imageView setImageWithURL:[NSURL URLWithString:url_str] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            }
            
        }
        cell.btnSelectImage.tag = indexPath.row - 1;
        return cell;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.aryImages.count + 1;
}
@end
