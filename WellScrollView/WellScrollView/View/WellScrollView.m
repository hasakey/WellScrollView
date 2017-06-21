//
//  WellScrollView.m
//  WellScrollView
//
//  Created by 同筑科技 on 2017/6/21.
//  Copyright © 2017年 well. All rights reserved.
//

#define ImageViewCount  3

#import "WellScrollView.h"

@interface WellScrollView()<UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSMutableArray *imageViewArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation WellScrollView

-(instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = imageArray;
        [self setUpSubViews];
        [self startTimer];
    }
    return self;
}

#pragma mark    初始化
-(void)setUpSubViews
{
    [self addSubview:self.scrollView];
    //为scrollView添加图片
    for (int i = 0; i < ImageViewCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        
        //添加点击手势，触发delegate
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        
        if (i == 0) {
            imageView.tag = self.imageArray.count - 1;
        }else if (i == 1)
        {
            imageView.tag = 0;
        }else
        {
            imageView.tag = 1;
        }
        
        //设置显示的图片
        imageView.image = [UIImage imageNamed:self.imageArray[imageView.tag]];
        
        [self.imageViewArray addObject:imageView];
        [self.scrollView addSubview:imageView];
    }
    //添加pageControl
    self.pageControl.numberOfPages = self.imageArray.count;
    [self addSubview:self.pageControl];
}


#pragma mark    消除定时器
-(void)dealloc
{
    [self stopTimer];
}

#pragma mark    点击方法
-(void)clickAction:(UITapGestureRecognizer *)tapGestureRecognizer
{
    
    if ([self.wellScrollViewDelegate respondsToSelector:@selector(clickImageIndex:)]) {
        [self.wellScrollViewDelegate clickImageIndex:tapGestureRecognizer.view.tag];
    }
}

#pragma mark    定时器方法
-(void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:2.0f target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)nextImage
{
    //这里要设置off到2倍width，并且设置动画
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
}

#pragma mark   UIScrollViewDelegate
//每次滚动都会来到这里
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self reSetSubViews];
}

//开始拖拽，要停止计时器，防止错乱
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

//停止拖拽，要重新开启定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

//停止拖拽之后，会来到这里
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reSetSubViews];
}


#pragma mark    更新显示
-(void)reSetSubViews
{
    
    BOOL isSlideLeft = NO;
    if (self.scrollView.contentOffset.x > self.frame.size.width) {
        isSlideLeft = YES;
    }else if (self.scrollView.contentOffset.x == 0)
    {
        isSlideLeft = NO;
    }else
    {
        return;
    }
    
    NSInteger index;
    for (UIImageView *imageView in self.imageViewArray) {
        if (isSlideLeft) {
            index = imageView.tag + 1;
        }else
        {
            index = imageView.tag - 1;
        }
        
        if (index < 0) {
            //最后一页
            index = self.imageArray.count - 1;
        }else if (index >= self.imageArray.count)
        {
            //回到首页
            index = 0;
        }
        
        
        imageView.tag = index;
        
        imageView.image = [UIImage imageNamed:self.imageArray[imageView.tag]];

        
    }
    
    //设置pageControl
    self.pageControl.currentPage = [self.imageViewArray[1] tag];
    
    //这里不要动画
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
}

#pragma mark    懒加载

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.frame = CGRectMake(0, self.frame.size.height - 10 - 20, self.frame.size.width, 20);
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.frame = self.bounds;
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        //一开始让offset为一张图片的width，为了显示中间部分
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    return _scrollView;
}

-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}

-(NSMutableArray *)imageViewArray
{
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}





@end
