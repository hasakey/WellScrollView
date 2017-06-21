//
//  ViewController.m
//  WellScrollView
//
//  Created by 同筑科技 on 2017/6/21.
//  Copyright © 2017年 well. All rights reserved.
//

#import "ViewController.h"
#import "WellScrollView.h"

@interface ViewController ()<WellScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    WellScrollView *well = [[WellScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200) ImageArray:@[@"1",@"2",@"3",@"4",@"5",]];
    well.wellScrollViewDelegate = self;
    [self.view addSubview:well];
    
}

-(void)clickImageIndex:(NSInteger)imageIndex
{
    NSLog(@"点击了第 %ld 张",(long)(imageIndex + 1));
}



@end
