//
//  ViewController.m
//  RPasterDemo
//
//  Created by jasenhuang on 2018/7/22.
//  Copyright © 2018年 jasenhuang. All rights reserved.
//

#import "ViewController.h"
#import <RPaster/RPaster.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView* icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    icon2.image = [UIImage imageNamed:@"icon2"];
    [self.view addSubview:icon2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[RBundlePaster sharedInstance] loadPatchBundleFromFile];
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"a" withExtension:@"js"];
        NSLog(@"content = %@", [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil]);
        UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
        icon.image = [UIImage imageNamed:@"icon1"];
        [self.view addSubview:icon];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
