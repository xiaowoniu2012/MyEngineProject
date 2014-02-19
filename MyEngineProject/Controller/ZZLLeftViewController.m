//
//  ZZLLeftViewController.m
//  MyEngineProject
//
//  Created by zelong zou on 14-2-19.
//  Copyright (c) 2014年 prdoor. All rights reserved.
//

#import "ZZLLeftViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ZZLCenterVCManger.h"
@interface ZZLLeftViewController ()

@end

@implementation ZZLLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(UIButton *)sender {
    ZZLCenterViewController *rootvc = (ZZLCenterViewController*)[[ZZLCenterVCManger shareInstance]getViewControllerWithType:kCenterVC_ITEM1];
    [self.mm_drawerController setCenterViewController:rootvc withCloseAnimation:YES completion:nil];
}

- (IBAction)item1Action:(UIButton *)sender {
    
    
     ZZLDemoViewController *rootViewController = (ZZLDemoViewController *)[[ZZLCenterVCManger shareInstance]getViewControllerWithType:KCenterVC_ITEM2];
        UINavigationController *rootvc = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    [self.mm_drawerController setCenterViewController:rootvc withCloseAnimation:YES completion:nil];
}

- (IBAction)item2Action:(UIButton *)sender {
}
- (IBAction)item3Action:(UIButton *)sender {
}

- (IBAction)item4Action:(UIButton *)sender {
}
@end
