//
//  APhotoAlbumViewController.h
//  SelectImageDemo
//
//  Created by likangding on 16/9/29.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumListViewController.h"
#import <Photos/Photos.h>

@interface PhotoListViewController : UIViewController
@property (strong, nonatomic) PHFetchResult *group;
@property (strong, nonatomic) PhotoAlbumListViewController *albumListVC;

- (instancetype)initWithGroupPhoto:(PHAssetCollection *)group;

@end
