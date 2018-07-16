//
//  ViewController.m
//  NoticeView
//
//  Created by yatao li on 2018/7/16.
//  Copyright © 2018年 李亚涛. All rights reserved.
//

#import "ViewController.h"
#import "YTNoticeView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YTNoticeView *noticeView = [[YTNoticeView alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 30, 40) andScrollTimeInterval:2.0];

    noticeView.backgroundColor = [UIColor redColor];
    [self.view addSubview:noticeView];
    noticeView.clickIndexBlock = ^void(NSInteger index){
        NSLog(@"点击了第%ld张", (long)index);
    };
    
    
    [noticeView beginScrollWithDataArray:@[@"---0---",@"---1---",@"---2---",@"---3---",@"---4---"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
