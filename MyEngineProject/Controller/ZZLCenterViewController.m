//
//  ZZLCenterViewController.m
//  MyEngineProject
//
//  Created by zelong zou on 14-2-19.
//  Copyright (c) 2014年 prdoor. All rights reserved.
//

#import "ZZLCenterViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface ZZLCenterViewController ()

@end

@implementation ZZLCenterViewController

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

- (IBAction)showLeft:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end
