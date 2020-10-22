//
//  ViewController.m
//  iOSDemo
//
//  Created by 孙同生 on 2020/5/27.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView* scrollView = ({
        UIScrollView* sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        sv.showsVerticalScrollIndicator = false;
        sv.showsHorizontalScrollIndicator = false;
        sv;
    });
    NSArray* btns = @[@"TSAlubmVC",@"TSApmVC",@"测试1"];
    for (int i = 0; i < btns.count; i++) {
        UIButton* btn = [UIButton buttonWithType:0];
        [btn setTitle:btns[i] forState:0];
        btn.frame = CGRectMake(10, 50*i, 200, 40);
        [btn setTitleColor:[UIColor blueColor] forState:0];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
    }
    [self.view addSubview:scrollView];
    

    
//    PreviewUrlView* pu = [PreviewUrlView new];
//    [pu loadUrl:[NSURL URLWithString:@"https://m.toutiao.com/i6847286109173449227/?timestamp=1594381503&app=news_article&group_id=6847286109173449227&use_new_style=1&req_id=2020071019450301001404813427119647"]];
//    self.pu = pu;
//    [self.view addSubview:pu.webview];
//    pu.webview.frame = self.view.bounds;
}

-(void)btnClick:(UIButton*)btn{
    
    Class cls = NSClassFromString(btn.titleLabel.text);
    if(!cls) return;
    UIViewController* vc = [cls new];
    [self.navigationController pushViewController:vc animated:false];
    
}

//MARK: - 超时检测
+(void)testTimeOut{
        
}


@end
