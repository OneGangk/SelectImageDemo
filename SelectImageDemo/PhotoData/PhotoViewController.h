//
//  PhotoViewController.h
//  SelectImageDemo
//
//  Created by likangding on 16/9/30.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@protocol PhotoViewContorllerDelegate <NSObject>

@optional
- (void)onSelectPhoto:(PhotoModel *)model index:(NSInteger)index;

- (void)closeView;

@end

@interface PhotoViewController : UIViewController
@property (assign, nonatomic) NSInteger         index;          /**< 当前显示第几张图片 */
@property (strong, nonatomic) NSArray           *photos;        /**< 数据源*/
@property (assign, nonatomic) NSInteger        selectionCount; /**< 选择了几张图片*/
@property (assign,  nonatomic) NSInteger        maxSelectionCount; /**< 最多选择几张*/
@property (assign, nonatomic) PhotoModel       *model;          /**< 图片Model*/
@property (assign, nonatomic) id<PhotoViewContorllerDelegate>photoViewControllerDetegate;

@end
