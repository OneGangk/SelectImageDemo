//
//  PhotoViewCell.h
//  SelectImageDemo
//
//  Created by likangding on 16/10/8.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@protocol CollectionViewCellDelegate <NSObject>

@optional

/**
 隐藏其他控件
 */
- (void)hidenPhotoBrowse;

@end

@interface PhotoViewCell : UICollectionViewCell<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PhotoModel *model;
@property (nonatomic, assign) id<CollectionViewCellDelegate>collectionViewCellDelgate;

@end
