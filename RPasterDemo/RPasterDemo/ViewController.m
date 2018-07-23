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
    [[RBundlePaster sharedInstance] loadPatchBundleFromFile];
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"a" withExtension:@"js"];
    NSLog(@"content = %@", [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil]);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    imageView.image = [UIImage imageNamed:@"icon2"];
    [self.view addSubview:imageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
