//
//  PhotoCell.m
//  SelectImageDemo
//
//  Created by likangding on 16/9/30.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import "PhotoListCell.h"
#import "PhotoAlbumListViewController.h"

@implementation PhotoListCell{
    UIButton *_selecedBtn;  /**< 是否选中按钮 */
    UIImageView *_imageView;
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        
        _selecedBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 30, 2.5, 30, 30)];
        [_selecedBtn setImage:[UIImage imageNamed:@"gallery_chs_normal"] forState:UIControlStateNormal];
        [_selecedBtn setImage:[UIImage imageNamed:@"gallery_chs_seleceted"] forState:UIControlStateSelected];
        [_selecedBtn addTarget:self action:@selector(onClickSelecedBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selecedBtn];
    }
    return self;
}

- (void)setModel:(PhotoModel *)model {
    _model = model;
    _imageView.frame = self.bounds;
    if (_model.thumbImage) {
        _imageView.image = _model.thumbImage;
    }else{
        /**
         注意几个方面 1.也就是用模型的好处，我拿到了高清的图片就把它添加到模型里面，下次就不需要在去加载了。
                    2.在说一下resizeMode的作用，esizeMode 属性控制图像的剪裁，
                    PHImageRequestOptionsResizeModeExact 则返回图像必须和目标大小相匹配，并且图像质量也为高质量图像
                    PHImageRequestOptionsResizeModeFast  则请求的效率更高，但返回的图像可能和目标大小不一样并且质量较低。
                    PHImageRequestOptionsResizeModeNone  没有大小
                    我这里选择PHImageRequestOptionsResizeModeFast是因为我只需要加载的效率。
         */
//        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//        //deliveryMode 如果你设置了PHImageRequestOptionsDeliveryModeFastFormat 获取低质量 你在设置BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];是没有用的 也就是说你只能获取到低质量的图
//        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//        [[PHImageManager defaultManager] requestImageForAsset:_model.asset targetSize:CGSizeMake(screen_width, screen_height) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                if (_model == model) {
//                    _model.thumbImage = result;
//                    _imageView.image = result;
//                }
//        }];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:CGSizeMake(screen_width/2, screen_height/2) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (downloadFinined) {
                _model.thumbImage = result;
                _imageView.image = result;
            }else{
                if (_model == model) {
                    _imageView.image = result;
                }
            }
        }];
    }
    [self setFlagStateForModel:model];
}

- (void)setFlagStateForModel:(PhotoModel *)model{
    _selecedBtn.selected = _model.isSelected;
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
};


#pragma mark - ---------------------Action
- (void)onClickSelecedBtn{
    if (self.photoListCellDelegeta && [self.photoListCellDelegeta respondsToSelector:@selector(selectPhoto: indexPath:)]) {
        [self.photoListCellDelegeta selectPhoto:_model indexPath:_indexPath];
    }
}

@end
