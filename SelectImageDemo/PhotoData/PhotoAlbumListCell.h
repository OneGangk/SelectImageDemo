//
//  PhotoListCell.h
//  SelectImageDemo
//
//  Created by likangding on 16/9/29.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoAlbumListCell : UITableViewCell

@property (nonatomic, strong) PHFetchResult *group;
@property (nonatomic, strong) NSMutableArray *groupList;
@property (nonatomic, assign) NSInteger row;

@end
