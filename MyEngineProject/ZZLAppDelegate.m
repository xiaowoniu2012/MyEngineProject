//
//  ZZLAppDelegate.m
//  MyEngineProject
//
//  Created by zelong zou on 13-8-30.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "ZZLAppDelegate.h"
#import "ZZLHttpManager.h"
#import "MovieList.h"
#import "ZZLDemoViewController.h"

@implementation ZZLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    ZZLDemoViewController *rootViewController = [[ZZLDemoViewController alloc]initWithNibName:NSStringFromClass([ZZLDemoViewController class]) bundle:Nil];
    
    UINavigationController *rootvc = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    self.window.rootViewController = rootvc;
    
    [self.window makeKeyAndVisible];
    
//    [[ZZLHttpManager sharedInstance]requestMovieListOnSuccess:^(NSMutableArray *listOfModalObjects) {
//        NSLog(@"did it work");
//        NSLog(@"list:%@",listOfModalObjects);
//    } OnFail:^(NSError *erro) {
//        NSLog(@"request erro!");
//    }];
    

    [ZZLHttpManager requestModelListWithServicePath:HOME_PAGE_URL
                                           keyPaths:[NSArray arrayWithObjects:@"hot",@"movie_list", nil]
                                         modelClass:[MovieList class]
                                          onSuccess:^(NSMutableArray *listOfModalObjects){
        NSLog(@"list:%@",listOfModalObjects);
    } onFail:^(NSError *erro) {
        NSLog(@"request erro!");
    }];
    [ZZLHttpManager cancelRequestWithPath:HOME_PAGE_URL];

//    [ZZLHttpManager requestSingleModelWithServicePath:HOME_PAGE_URL
//                                             keyPaths:@[@"hot",@"movie_list"]
//                                           modelClass:[MovieList class]
//                                            onSuccess:^(ZZLBaseJsonObject *modelObject) {
//        NSLog(@"single object:%@",modelObject);
//    } onFail:^(NSError *erro) {
//        NSLog(@"single erro");
//    }];

    
    [self performSelector:@selector(delay1) withObject:nil afterDelay:1.0f];

     
    return YES;
}
- (void)delay1
{
    [ZZLHttpManager requestWithServicePath:HOME_PAGE_URL
                                 onSuccess:^(id obj) {
                                     NSLog(@"<<<<<<<requst data:%@",obj);
                                 } onFail:^(NSError *erro) {
                                     NSLog(@"request erro");
                                 }];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
