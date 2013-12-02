//
//  ZZLBaseTableViewController.m
//  MyEngineProject
//
//  Created by zelong zou on 13-12-2.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "ZZLBaseTableViewController.h"
#import <objc/runtime.h>
//@interface ZZLBaseTableViewController (refreshHeadView)
//@property (nonatomic,assign) BOOL isContainedRefreshView;
//@property (nonatomic,assign) BOOL isLoading;
//@end
//@implementation ZZLBaseTableViewController (refreshHeadView)
//static char isContainedRefreshViewKey;
//static char isLoadingKey;
//- (BOOL) isContainedRefreshView
//{
//    return [objc_getAssociatedObject(self, &isContainedRefreshViewKey) boolValue];
//}
//- (void) setIsContainedRefreshView:(BOOL)isContainedRefreshView
//{
//    objc_setAssociatedObject(self, &isContainedRefreshViewKey, [NSNumber numberWithBool:isContainedRefreshView], OBJC_ASSOCIATION_ASSIGN);
//}
//- (BOOL) isLoading
//{
//    return [objc_getAssociatedObject(self, &isLoadingKey) boolValue];
//}
//- (void) setIsLoading:(BOOL)isLoading
//{
//    objc_setAssociatedObject(self, &isLoadingKey, [NSNumber numberWithBool:isLoading], OBJC_ASSOCIATION_ASSIGN);
//}
//@end
@interface ZZLBaseTableViewController ()

@end

@implementation ZZLBaseTableViewController
{
    PullTableView *_pullTableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_pullTableView) {
        _pullTableView = [[PullTableView alloc]initWithFrame:self.view.bounds];
        _pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
        _pullTableView.pullBackgroundColor = [UIColor yellowColor];
        _pullTableView.pullTextColor = [UIColor blackColor];
        _pullTableView.dataSource = self;
        _pullTableView.delegate = self;
        _pullTableView.pullDelegate = self;
        [self.view addSubview:_pullTableView];
    }
    [_pullTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if(!_pullTableView.pullTableIsRefreshing) {
        _pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    _pullTableView.pullLastRefreshDate = [NSDate date];
    _pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    _pullTableView.pullTableIsLoadingMore = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {

        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row-->%d",indexPath.row];
    // Configure the cell...
    
    return cell;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
