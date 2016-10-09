//
//  PhotoListViewController.m
//  SelectImageDemo
//
//  Created by likangding on 16/9/29.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import "PhotoAlbumListViewController.h"
#import <Photos/Photos.h>
#import "PhotoAlbumListCell.h"
#import "PhotoListViewController.h"

@interface PhotoAlbumListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groupList;

@end

@implementation PhotoAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"相册";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)];
    [self setPhotoGroup];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSMutableArray *)groupList{
    if (!_groupList) {
        _groupList = [NSMutableArray new];
    }
    return _groupList;
}

#pragma mark - ---------------------设置图片数据
- (void)setPhotoGroup{
    /**
     photoKit基本属性说明
     PHAsset 代表照片库中的一个资源，通过PHAsset可以获取和保存资源。（白话就是：你想要图片就要用他去取）
     PHFetchOptions 获取资源时的参数，可以传Nil,系统会有默认值。
     PHAssetCollection: PHCollecion的子类，表示一个时刻或者一个相册。
     PHFetchResult:表示一系列的资源结果集合，也可以是相册的集合。
     PHImageManager: 用于处理资源的加载，加载图片的过程带有缓存处理，可以通过传入一个 PHImageRequestOptions 控制资源的输出尺寸等规格
     PHImageRequestOptions: 如上面所说，控制加载图片时的一系列参数
     
     这个有人想要更详细的 看这个2个就是可以
     http://www.jianshu.com/p/9988303b2429 
     http://kayosite.com/ios-development-and-detail-of-photo-framework-part-two.html
     比我写的好
     */
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];//这里可以不用创建
    //PHAssetCollectionTypeSmartAlbum 表示智能相册 PHAssetCollectionSubtypeAlbumRegular 用户创建所有的相册
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    
    //注意类型
    for (PHAssetCollection *sub in smartAlbumsFetchResult){
        //遍历到数组中
        PHFetchResult *group = [PHAsset fetchAssetsInAssetCollection:sub options:nil];
        //过滤掉没有图片的Group
        if (group.count > 0) {
            [self.groupList addObject:sub];
        }
    }
}

#pragma mark - ---------------------UITableViewDelegate/UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    PhotoAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PhotoAlbumListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    PHFetchResult *group = [PHAsset fetchAssetsInAssetCollection:[_groupList objectAtIndex:indexPath.row] options:nil];
    cell.row = indexPath.row;
    cell.group = group;
    cell.groupList = self.groupList;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoListViewController *photoListVC = [[PhotoListViewController alloc] initWithGroupPhoto:_groupList[indexPath.row]];
    photoListVC.albumListVC = self;
    photoListVC.navigationItem.title = [NSString stringWithFormat:@"%@",[[_groupList objectAtIndex:indexPath.row] localizedTitle]];
    [self.navigationController pushViewController:photoListVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groupList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.layoutMargins = cell.layoutMargins;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.separatorInset = cell.separatorInset;
    }
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - ---------------------事件
- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
