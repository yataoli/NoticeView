//
//  PicturePlayer.m
//  PicturePlay
//
//  Created by yatao li on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YTNoticeView.h"
@interface YTNoticeView () <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSTimer *timer;//定时器
@property (nonatomic) NSTimeInterval scrollInterval;
@property (nonatomic,strong) NSArray *dataArray;


@end
@implementation YTNoticeView
-(instancetype)initWithFrame:(CGRect)frame andScrollTimeInterval:(NSTimeInterval)timeInterval{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.scrollEnabled = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentSize = CGSizeMake(0, self.frame.size.width * 3);
        self.scrollView.contentOffset = CGPointMake(0, self.frame.size.height);
        self.scrollView.delegate  = self;
        [self addSubview:self.scrollView];
        
        for (NSInteger i = 0; i < 3; i ++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height * i, self.frame.size.width, frame.size.height)];
            
            label.tag = i+1;
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:15];
            label.backgroundColor = [UIColor redColor];
            label.userInteractionEnabled = YES;
            [self.scrollView addSubview:label];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
            [label addGestureRecognizer:tapGesture];
            
        }
        
        if (timeInterval <= 0) {
            self.scrollInterval = 2.0;
        }
        self.scrollInterval = timeInterval;
        
    }
    return self;
}



#pragma mark - 开始滚动
- (void)beginScrollWithDataArray:(NSArray *)array{
    if (array.count <= 0) {
        return;
    }
    self.dataArray = array;
    //设置scrollView上的内容
    [self setContentInScrollView:self.scrollView];
    //开启定时器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addTimer];
    });
    

}

#pragma mark - 开启定时器
- (void)addTimer
{
    if (_timer == nil)
    {
        _timer = [NSTimer timerWithTimeInterval:self.scrollInterval target:self selector:@selector(autoScroll:) userInfo:_scrollView repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark - 定时器绑定的方法
- (void)autoScroll:(NSTimer *)timer
{
    [_timer.userInfo setContentOffset:CGPointMake(0, self.frame.size.height * 2) animated:YES];
}
#pragma mark - 设置scrollView上的图片
- (void)setContentInScrollView:(UIScrollView *)scrollView
{
    UILabel *label = [scrollView viewWithTag:1];
    NSString *nameString = _dataArray[_pageIndex - 1 < 0 ? self.dataArray.count - 1 : self.pageIndex - 1];
    label.text = nameString;
    
    
    
    
    label = [scrollView viewWithTag:2];
    nameString = self.dataArray[self.pageIndex];
    label.text = nameString;
    
    
    
    label = [scrollView viewWithTag:3];
    nameString = self.dataArray[self.pageIndex + 1 == self.dataArray.count ? 0 : self.pageIndex + 1];
    label.text = nameString;
}
#pragma mark - 返回所点击图片在数组中的索引
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if (self.clickIndexBlock)
    {
        self.clickIndexBlock(self.pageIndex);
    }
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UIScrollView class]])
    {
        if (scrollView.contentOffset.x == self.frame.size.width * 2)
        {
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height * 1);
            self.pageIndex++;
            if (self.pageIndex == self.dataArray.count)
            {
                self.pageIndex = 0;
            }
            [self setContentInScrollView:scrollView];
            
        }else if (scrollView.contentOffset.x == 0)
        {
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height * 1);
            self.pageIndex--;
            if (self.pageIndex == -1)
            {
                self.pageIndex = self.dataArray.count - 1;
            }
            [self setContentInScrollView:scrollView];
        }
    }
}
#pragma mark - 带动画的滑动结束后才会调用(手滑动的时候不会调用该方法)
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UIScrollView class]])
    {
        if (scrollView.contentOffset.y == self.frame.size.height * 2)
        {
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height * 1);
            self.pageIndex++;
            if (self.pageIndex == self.dataArray.count)
            {
                self.pageIndex = 0;
            }
            [self setContentInScrollView:scrollView];
            
        }else if (scrollView.contentOffset.y == 0)
        {
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height * 1);
            self.pageIndex--;
            if (self.pageIndex == -1)
            {
                self.pageIndex = self.dataArray.count - 1;
            }
            [self setContentInScrollView:scrollView];
        }
    }
}
@end
