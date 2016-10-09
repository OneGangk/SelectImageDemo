//
//  ViewController.m
//  SelectImageDemo
//
//  Created by likangding on 16/9/29.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import "ViewController.h"
#import "PhotoAlbumListViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()<PhotoAlbumListDegate>
@property (nonatomic, strong) UIButton *photoListBtn;
@property (nonatomic, strong) PhotoAlbumListViewController *photoAlubmListVC; /**< 用户图片列表*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _photoListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoListBtn setTitle:@"相册" forState:UIControlStateNormal];
    [_photoListBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_photoListBtn addTarget:self action:@selector(onClickPhotoBtn) forControlEvents:UIControlEventTouchUpInside];
    _photoListBtn.frame = CGRectMake(0, 0, 200, 50);
    _photoListBtn.center = self.view.center;
    [self.view addSubview:_photoListBtn];
    
/**
 思路：
 实现多选图片 用PhotoKit框架实现
            图片列表 用tableView显示 拿去第一个图片作为图片
            点击某个cell 以为collectionView 显示列表
            点击某个图片  以为图片游览器方式显示 （仿QQ的）
            图片游览 第一个用collectionView 第二个scrollView
            我建议还是用scrollView好（进过测试scrollView 不会出现卡顿）
 */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------------------Action
- (void)onClickPhotoBtn{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    //PHAuthorizationStatusDenied 表示未授权
    if (status == PHAuthorizationStatusDenied) {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *appName =[infoDict objectForKey:@"CFBundleDisplayName"];
        NSLog(@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册",appName);
        return;
    }else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self showPhotoListVC];
            }
        }];
    }else if(status == PHAuthorizationStatusAuthorized){
        [self showPhotoListVC];
    }
}

- (void)showPhotoListVC{
    _photoAlubmListVC = [[PhotoAlbumListViewController alloc] init];
    _photoAlubmListVC.maxSelectionCount = 6;
    _photoAlubmListVC.photoAlbumListDelegate = self;
//    [self presentViewController:_photoListVC animated:YES completion:nil];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:_photoAlubmListVC] animated:YES completion:nil];
}

#pragma mark - ---------------------PhotoAlbumListDegate
- (void)didSelectPhotos:(NSMutableArray *)dataPhotos{
    NSLog(@"%@",dataPhotos);
}

@end
