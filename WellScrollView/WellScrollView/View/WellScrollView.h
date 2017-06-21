//
//  WellScrollView.h
//  WellScrollView
//
//  Created by 同筑科技 on 2017/6/21.
//  Copyright © 2017年 well. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WellScrollView;

@protocol WellScrollViewDelegate <NSObject>

@optional


/**
 点击了图片

 @param imageIndex 图片位置
 */
-(void)clickImageIndex:(NSInteger)imageIndex;

@end

@interface WellScrollView : UIView

@property(nonatomic,weak)id <WellScrollViewDelegate>wellScrollViewDelegate;


/**
 初始化方法

 @param frame frame
 @param imageArray 图片数组
 @return 创建
 */
-(instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)imageArray;

@end
