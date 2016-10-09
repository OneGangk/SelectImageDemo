//
//  APhotoAlbumViewController.m
//  SelectImageDemo
//
//  Created by likangding on 16/9/29.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoAlbumListViewController.h"
#import "PhotoModel.h"
#import "PhotoListCell.h"
#import "PhotoViewController.h"

const CGFloat imageSpacing = 2.0f;  /**< 图片间距 */
const NSInteger maxCountInLine = 4; /**< 每行显示图片张数 */

@interface PhotoListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, PhotoListCellDelageta, PhotoViewContorllerDelegate>
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (strong, nonatomic) PhotoListCell      *cell;
@property (strong, nonatomic) UIButton          *finishButton;      /**< 完成按钮 */

@end

@implementation PhotoListViewController{
    NSMutableArray *_selectedFalgList;  /**< 是否选中标记 */
    NSMutableArray *_assetList;         /**< 当前相薄所有asset */
    PhotoModel     *_selectedModel;
}

- (instancetype)initWithGroupPhoto:(PHAssetCollection *)group{
    if (self = [super init]) {
        _group = [PHAsset fetchAssetsInAssetCollection:group options:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self getAllPhoto];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (self.view.frame.size.width - imageSpacing * (maxCountInLine - 1)) / maxCountInLine;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing      = imageSpacing;
        layout.minimumInteritemSpacing = imageSpacing;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) collectionViewLayout:layout];
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[PhotoListCell class] forCellWithReuseIdentifier:@"photoCell"];
    }
    return _collectionView;
}

- (UIButton *)finishButton{
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 49)];
        [_finishButton addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
        [_finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishButton.backgroundColor     = [UIColor whiteColor];
        _finishButton.titleLabel.font     = [UIFont systemFontOfSize:15];
        [_finishButton setTitle:@"确定" forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _finishButton.frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [_finishButton addSubview:lineView];
        
        [self.view addSubview:_finishButton];
        [self.view bringSubviewToFront:_finishButton];
    }
    return _finishButton;
}

#pragma mark - ---------------------数据
- (void)getAllPhoto{
    _assetList = [NSMutableArray array];
    _selectedFalgList = [[NSMutableArray alloc] init];
    NSMutableArray *photoList = [[NSMutableArray alloc] init];
    //把数据封装成一个模型 方便以后使用
    for (PHAsset *asset in _group) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            PhotoModel *model = [[PhotoModel alloc] init];
            model.asset = asset;
            
            //获取缩略图大小
            CGFloat scale = screen_width / screen_height;
            CGSize resize = CGSizeMake(asset.pixelWidth * scale, asset.pixelHeight * scale);
            model.thumbSize = CGSizeMake(_collectionView.frame.size.height / resize.height * resize.width, _collectionView.frame.size.height);
            [photoList addObject:model];
        }
    }
    _assetList = [NSMutableArray arrayWithArray:[photoList reverseObjectEnumerator].allObjects];
}

#pragma mark - ---------------------- UICollectionViewDataSource/delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assetList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    _cell.indexPath = indexPath;
    _cell.model = _assetList[indexPath.row];
    _cell.photoListCellDelegeta = self;
    return _cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.index = indexPath.row;
    photoVC.photos = _assetList;
    photoVC.selectionCount = [_selectedFalgList count];
    photoVC.maxSelectionCount = self.albumListVC.maxSelectionCount;
    photoVC.photoViewControllerDetegate = self;
    [self.navigationController pushViewController:photoVC animated:YES];
}

#pragma mark - ---------------------- animation
- (void)showFinishButton{
    self.finishButton.hidden = NO;
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = _finishButton.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        _finishButton.frame = frame;
        
        frame = _collectionView.frame;
        frame.size.height = _finishButton.frame.origin.y;
        _collectionView.frame = frame;
    }];
    [_finishButton setTitle:[NSString stringWithFormat:@"确定(%zi)",_selectedFalgList.count] forState:UIControlStateNormal];
}

- (void)hideFinishButton{
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = _finishButton.frame;
        frame.origin.y = self.view.frame.size.height;
        _finishButton.frame = frame;
        
        frame = _collectionView.frame;
        frame.size.height = _finishButton.frame.origin.y;
        _collectionView.frame = frame;
    } completion:^(BOOL finished) {
        self.finishButton.hidden = YES;
    }];
}

#pragma mark - ---------------------PhotoListCellDelageta
- (void)selectPhoto:(PhotoModel *)model indexPath:(NSIndexPath *)indexPath{
    if (_selectedFalgList.count > 0 && !model.isSelected) {
        if (_selectedFalgList.count >= self.albumListVC.maxSelectionCount) {
            NSString *msg = [NSString stringWithFormat:@"最多选择%zi张图片",self.albumListVC.maxSelectionCount];
            NSLog(@"%@",msg);
            return;
        }
    }
    model.isSelected = !model.isSelected;
    if (!model.isSelected) {
        [_selectedFalgList removeObject:model.image];
        if (_selectedFalgList.count <= 0) {
            [self hideFinishButton];
        }else{
            [self showFinishButton];
        }
    }else{
        [_selectedFalgList addObject:model.image];
        [self showFinishButton];
    }
    _selectedModel = model;
    
    _cell = (id)[_collectionView cellForItemAtIndexPath:indexPath];
    [_cell setFlagStateForModel:model];
}

#pragma mark - ---------------------PhotoViewContorllerDelegate
- (void)onSelectPhoto:(PhotoModel *)model index:(NSInteger)index{
    model.isSelected = !model.isSelected;
    if (!model.isSelected) {
        [_selectedFalgList removeObject:model.image];
        if (_selectedFalgList.count <= 0) {
            [self hideFinishButton];
        }else{
            [self showFinishButton];
        }
    }else{
        [_selectedFalgList addObject:model.image];
        [self showFinishButton];
    }
    _selectedModel = model;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)closeView{
    [self clickFinish];
}

#pragma mark - ---------------------Aciton
- (void)clickFinish{
    if (self.albumListVC.photoAlbumListDelegate && [self.albumListVC.photoAlbumListDelegate respondsToSelector:@selector(didSelectPhotos:)]) {
        [self.albumListVC.photoAlbumListDelegate didSelectPhotos:_selectedFalgList];
    }
    [self clickCancel];
}

- (void)clickCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end
