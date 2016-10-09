//
//  PhotoListCell.m
//  SelectImageDemo
//
//  Created by likangding on 16/9/29.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import "PhotoAlbumListCell.h"
#import "PhotoAlbumListViewController.h"

@implementation PhotoAlbumListCell{
    UIImageView *_imageView;
    UILabel     *_textLabel;
    PHAssetCollection *_titleAsset;
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 80, 80)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.numberOfLines = 1;
        [self.contentView addSubview:_textLabel];
        
        _groupList = [NSMutableArray new];
    }
    return self;
}

- (void)setGroup:(PHFetchResult *)group{
    _group = group;
    //获取相薄最后一张图片
    [[PHImageManager defaultManager] requestImageForAsset:group.lastObject
                                               targetSize:CGSizeMake(screen_width,screen_height)
                                              contentMode:PHImageContentModeAspectFit
                                                  options:nil
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                _imageView.image = result;
                                            }];
}

- (void)setGroupList:(NSMutableArray *)groupList{
    _groupList = groupList;
    _titleAsset = [_groupList objectAtIndex:_row];
    //显示相薄名称+图片张数
    _textLabel.text = [NSString stringWithFormat:@"%@(%zi张)",[NSString stringWithFormat:@"%@",_titleAsset.localizedTitle], _group.count];
    [_textLabel sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = _textLabel.frame;
    frame.origin = CGPointMake(CGRectGetMaxX(_imageView.frame) + 10, 0);
    _textLabel.frame =frame;
    _textLabel.center = CGPointMake(_textLabel.center.x, _imageView.center.y);
  }

@end
