//
//  PhotoCell.h
//  SelectImageDemo
//
//  Created by likangding on 16/9/30.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PhotoModel.h"
@protocol PhotoListCellDelageta <NSObject>

@optional
- (void)selectPhoto:(PhotoModel *)model indexPath:(NSIndexPath *)indexPath ;

@end
@interface PhotoListCell : UICollectionViewCell
@property (assign, nonatomic) PhotoModel *model;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, assign) id<PhotoListCellDelageta>photoListCellDelegeta;

//设置选中标记状态
- (void)setFlagStateForModel:(PhotoModel *)model;

@end
