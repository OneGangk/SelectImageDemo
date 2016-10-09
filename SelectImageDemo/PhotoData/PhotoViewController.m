//
//  PhotoViewController.m
//  SelectImageDemo
//
//  Created by likangding on 16/9/30.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoAlbumListViewController.h"
#import "PhotoViewCell.h"

static NSString *const identifier = @"photoViewCell";

@interface PhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewCellDelegate>
@property (nonatomic, strong) UIView        *navBGView;      /**< 自定义导航栏*/
@property (nonatomic, strong) UIButton      *selectBtn;      /**< 选择图片*/
@property (nonatomic, strong) UIView        *bottonView;     /**< 底部完成和显示选中几张图片*/
@property (nonatomic, strong) UIButton      *selectCountBtn; /**< 用于显示选中几张图片*/
@property (nonatomic, strong) UIButton      *finishBtn ;     /**< 完成按钮*/
@property (nonatomic, strong) UILabel       *firstFewPhotoLabel; /**< 当前是第几张图片*/
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PhotoViewController{
    NSInteger               _totalCount;
    NSMutableDictionary     *_photoViewList;
    PhotoModel              *_tempModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//ios 7
    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self prefersStatusBarHidden];
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    }
    [self preferredStatusBarStyle];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//- (BOOL)prefersStatusBarHidden{
//    return NO;
//}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ---------------------- UI
- (void)initUI{
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat width = self.view.frame.size.width + 10;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(width, screen_height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-5, 0, width, screen_height) collectionViewLayout:layout];
    [_collectionView registerClass:[PhotoViewCell class] forCellWithReuseIdentifier:identifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];

    [self setNavView];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    _photoViewList = [[NSMutableDictionary alloc] init];
    
    _totalCount = self.photos.count;
    
    _model = _photos[self.index];
    _selectBtn.selected = _model.isSelected;
    
    if (_selectionCount == 0) {
        self.selectCountBtn.hidden = YES;
    }else{
        [self.selectCountBtn setTitle:[NSString stringWithFormat:@"%zi",_selectionCount] forState:UIControlStateNormal];
    }
    
    if (_selectionCount == 0) {
        self.selectCountBtn.hidden = YES;
    }else{
        [self.selectCountBtn setTitle:[NSString stringWithFormat:@"%zi",_selectionCount] forState:UIControlStateNormal];
    }
    
    _firstFewPhotoLabel.text = [NSString stringWithFormat:@"%zi/%zi", self.index + 1, _photos.count];
    [_firstFewPhotoLabel sizeToFit];
}

- (void)setNavView{
    //自定义导航栏
    _navBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    _navBGView.backgroundColor = [UIColor colorWithRed:121/255.0f green:121/255.0f blue:121/255.0f alpha:0.6];
    [self.view addSubview:_navBGView];
    
    //返回按钮
    UIImage *norImage = [UIImage imageNamed:[NSString stringWithFormat:@"public_backwhite_normal"]];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 0, norImage.size.width + 10, norImage.size.height);
    [backBtn addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:norImage forState:UIControlStateNormal];
    [_navBGView addSubview:backBtn];
    backBtn.center = CGPointMake(backBtn.center.x, _navBGView.center.y + 10);
    
    //选择图片
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(screen_width - 30 - 15, 27, 30, 30);
    [_selectBtn addTarget:self action:@selector(onSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn setImage:[UIImage imageNamed:@"service_unselect_icon"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"service_selected_icon"] forState:UIControlStateSelected];
    [_navBGView addSubview:_selectBtn];
    
    //当前第几张图片
    _firstFewPhotoLabel = [[UILabel alloc] init];
    _firstFewPhotoLabel.textColor = [UIColor whiteColor];
    _firstFewPhotoLabel.text = @"1/20";
    _firstFewPhotoLabel.textAlignment = NSTextAlignmentCenter;
    _firstFewPhotoLabel.frame = CGRectMake(_navBGView.center.x, 0, 0, 0);
    [_firstFewPhotoLabel sizeToFit];
    _firstFewPhotoLabel.center = CGPointMake(_navBGView.center.x, _navBGView.center.y + 10);
    [_navBGView addSubview:_firstFewPhotoLabel];
    
    //底部
    _bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height - 40, screen_width, 40)];
    _bottonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottonView];
    
    //完成Btn
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.frame = CGRectMake(screen_width - 55, 0, 50, 40);
    [_finishBtn addTarget:self action:@selector(onClickFinisBtn) forControlEvents:UIControlEventTouchUpInside];
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_finishBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_bottonView addSubview:_finishBtn];
}

- (UIButton *)selectCountBtn{
    if (!_selectCountBtn) {
        //显示选中了几张图片
        _selectCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectCountBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_selectCountBtn setBackgroundColor:[UIColor blueColor]];
        _selectCountBtn.frame = CGRectMake(screen_width - 55 - 16, 0, 19, 19);
        [_selectCountBtn.layer setCornerRadius:9.5];
        _selectCountBtn.center = CGPointMake(_selectCountBtn.center.x, _finishBtn.center.y);
        [_bottonView addSubview:_selectCountBtn];
    }
    return _selectCountBtn;
}
#pragma mark - ---------------------UICollectionViewDelegate/UICollectionViewDataSource,
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = _photos[indexPath.row];
    cell.collectionViewCellDelgate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewCell *willDisplayCell = (id)cell;
    if (willDisplayCell.scrollView.zoomScale > willDisplayCell.scrollView.minimumZoomScale) {
        [willDisplayCell.scrollView setZoomScale:willDisplayCell.scrollView.minimumZoomScale animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    _firstFewPhotoLabel.text = [NSString stringWithFormat:@"%zi/%zi", index + 1, _photos.count];
    [_firstFewPhotoLabel sizeToFit];
    _model = self.photos[index];
    _selectBtn.selected = _model.isSelected;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    self.index = index;
}

#pragma mark - ---------------------PhotoBrowseScrollViewDelegate
- (void)hidePhotoBrowse{
    [UIView animateWithDuration:0.25 animations:^{
        _navBGView.hidden = !_navBGView.hidden;
        _bottonView.hidden = !_bottonView.hidden;
    }];
}

#pragma mark - ---------------------Aciton
- (void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//选择图片
- (void)onSelectBtn{
    if (_selectionCount >= self.maxSelectionCount && !_selectBtn.isSelected) {
        NSString *msg = [NSString stringWithFormat:@"最多选择%zi张图片",self.maxSelectionCount];
        NSLog(@"%@",msg);
        return;
    }else{
        //此时的_model已经是下一张的Model了 所以我们这里要拿下标去取对应的Model
        _model = self.photos[self.index];
        _selectBtn.selected = !_selectBtn.selected;
        _model.isSelected = !_selectBtn.selected;
        if (self.photoViewControllerDetegate && [self.photoViewControllerDetegate respondsToSelector:@selector(onSelectPhoto: index:)]) {
            [self.photoViewControllerDetegate onSelectPhoto:_model index:_index];
        }
        //判断选择Btn是否是选中状态 选中状态让_selectionCount加1 不是_selectionCount减1
        if (_selectBtn.selected) {
            _selectionCount++;
            [self.selectCountBtn setTitle:[NSString stringWithFormat:@"%zi",_selectionCount] forState:UIControlStateNormal];
            self.selectCountBtn.hidden = NO;
        }else{
            _selectionCount--;
            [self.selectCountBtn setTitle:[NSString stringWithFormat:@"%zi",_selectionCount] forState:UIControlStateNormal];
            if (_selectionCount == 0) {
                self.selectCountBtn.hidden = YES;
            }else{
                self.selectCountBtn.hidden = NO;
            }
        }
    }
}

//点击完成
- (void)onClickFinisBtn{
    if (_selectionCount ==0) {
        [self onSelectBtn];
    }
    if (self.photoViewControllerDetegate && [self.photoViewControllerDetegate respondsToSelector:@selector(closeView)]) {
        [self.photoViewControllerDetegate closeView];
    }

}

#pragma mark - ---------------------CollectionViewCellDelegate
- (void)hidenPhotoBrowse{
    [UIView animateWithDuration:0.25 animations:^{
        _navBGView.hidden = !_navBGView.hidden;
        _bottonView.hidden = !_bottonView.hidden;
    }];
}


- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end
