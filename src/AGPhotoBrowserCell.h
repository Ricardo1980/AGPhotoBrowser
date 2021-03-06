//
//  AGPhotoBrowserCell.h
//  AGPhotoBrowser
//
//  Created by Hellrider on 1/5/14.
//  Copyright (c) 2014 Andrea Giavatto. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AGPhotoBrowserCellProtocol.h"

@interface AGPhotoBrowserCell : UICollectionViewCell <AGPhotoBrowserCellProtocol>

@property (nonatomic, weak) id<AGPhotoBrowserCellDelegate> delegate;

- (void)setCellImage:(UIImage *)cellImage;
- (void)setCellImage:(UIImage *)cellImage animated:(BOOL)animated;
- (void)resetZoomScale;

@end
