//
//  PhotoViewCell.m
//  SelectImageDemo
//
//  Created by likangding on 16/10/8.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import "PhotoViewCell.h"
#import "PhotoAlbumListViewController.h"

@implementation PhotoViewCell{
    UIImageView *_imageView;
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, frame.size.width - 10, frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 2.8;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_scrollView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapEvent)];
        [_scrollView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapEvent:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [_scrollView addSubview:_imageView];

    }
    return self;
}

- (void)setModel:(PhotoModel *)model{
    _model = model;
    if (_model.image) {
        _imageView.image = _model.image;
    }else{
        [[PHImageManager defaultManager] requestImageForAsset:_model.asset targetSize:CGSizeMake(screen_width, screen_height) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (_model == model) {
                    if (downloadFinined) {
                        _model.image = result;
                        _imageView.image = _model.image;
                    }else{
                        _imageView.image = result;
                    }
                }
        }];
    }
    [self setImageFrame];
}

- (void)setImageFrame{
    UIImage *image = _imageView.image;
    CGFloat scale = 0;
    if (image && image.size.width > 0) {
        scale = [UIScreen mainScreen].bounds.size.width / image.size.width;
    }
    
    CGRect frame = _imageView.frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = scale * image.size.height;
    frame.origin.x = 0;
    if (frame.size.height > self.frame.size.height) {
        frame.origin.y = 0;
    }else{
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2;
    }
    _imageView.frame = frame;
}

- (void)zoomToMinimumScale{
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
}

#pragma mark - ---------------------- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scrollView.zoomScale > scrollView.maximumZoomScale){
        [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //放大过程中需要设置图片的中心点
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}

#pragma mark - ---------------------- 事件
- (void)singleTapEvent{
    if (self.collectionViewCellDelgate && [self.collectionViewCellDelgate respondsToSelector:@selector(hidenPhotoBrowse)]) {
        [self.collectionViewCellDelgate hidenPhotoBrowse];
    }
}

- (void)doubleTapEvent:(UITapGestureRecognizer *)sender{
    if (_scrollView.zoomScale != _scrollView.minimumZoomScale) {
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    }else{
        //放大倍数
        CGFloat scale = _scrollView.maximumZoomScale;
        CGFloat newWidth = _scrollView.bounds.size.width / scale;
        CGFloat newHeight = _scrollView.bounds.size.height / scale;
        
        //获取双击的点
        CGFloat touchX = [sender locationInView:sender.view].x;
        CGFloat touchY = [sender locationInView:sender.view].y;
        
        CGRect frame = CGRectMake(touchX - newWidth/2, touchY - newHeight/2, newWidth, newHeight);
        [_scrollView zoomToRect:frame animated:YES];
    }
}


@end
