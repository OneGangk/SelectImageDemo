//
//  PhotoListViewController.h
//  SelectImageDemo
//
//  Created by likangding on 16/9/29.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import <UIKit/UIKit.h>
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@protocol PhotoAlbumListDegate <NSObject>

@optional
- (void)didSelectPhotos:(NSMutableArray *)dataPhotos;

@end

@interface PhotoAlbumListViewController : UIViewController
@property (assign, nonatomic) NSInteger maxSelectionCount;/**< 最多选择图片张数 */
@property (assign, nonatomic) id<PhotoAlbumListDegate>photoAlbumListDelegate;


@end
