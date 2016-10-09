//
//  PhotoModel.h
//  SelectImageDemo
//
//  Created by likangding on 16/9/30.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoModel : NSObject
@property (strong, nonatomic) PHAsset   *asset;     /**< 资源 */
@property (assign, nonatomic) CGSize    thumbSize;  /**< 缩放大小 */
@property (strong, nonatomic) UIImage   *image;     /**< 解析资源后的图片 */
@property (strong, nonatomic) UIImage   *thumbImage;/**< 缩略图*/
@property (assign, nonatomic) BOOL      isSelected; /**< 是否已选中 */

@end
