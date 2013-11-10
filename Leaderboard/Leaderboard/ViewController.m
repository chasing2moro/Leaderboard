//
//  ViewController.m
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-3.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import "ViewController.h"
#import "LeaderboardMgr.h"
#import "FriendsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc{
    [self _releaseTableStuff];
    [_navTableView release];
    [_navLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    [self _initTableStuff];
    
    //
    [self _playerauthenticated:NO];
    
	// Do any additional setup after loading the view, typically from a nib.
    [[LeaderboardMgr sharedInstance] authenticateLocalPlayer:self];
    
    //[[LeaderboardMgr sharedInstance] loadLeaderboardInfo];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initTableStuff{
    _tableData = [[NSArray alloc] initWithObjects:
                  @"Friends",
                  @"Leaderboard",
                  @"ReportScore",
                  nil];
    
    //viewControllers
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    _viewControllers = [[NSArray alloc] initWithObjects:
                        [storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"],
                        [storyboard instantiateViewControllerWithIdentifier:@"LeaderboardViewController"],
                        [storyboard instantiateViewControllerWithIdentifier:@"ReportScoreViewController"],
                        nil];
}

- (void)_releaseTableStuff{
    [_tableData release];
    [_viewControllers release];
}

- (void)_playerauthenticated:(BOOL)authenticated{
    if (authenticated) {
        _navLabel.hidden = YES;
        _navTableView.hidden = NO;
    }else{
        _navLabel.hidden = NO;
        _navTableView.hidden = YES;
    }
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableData == nil ? 0 : _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UINavigationController *navigation = self.navigationController;
    UIViewController *viewController = [_viewControllers objectAtIndex:indexPath.row];
    [navigation pushViewController:viewController animated:YES];
}
#pragma mark - LeaderboardMgr Delegate
- (void) playerauthenticated:(BOOL)authenticate{
    if (authenticate == NO) {
        [CommonHelper showTipWithTitle:nil msg:@"Authenticate Player Failed"];
    }
    [self _playerauthenticated:YES];
}

- (void) showAuthenticationDialogWhenReasonable:(UIViewController *)viewController{
    [self presentViewController:viewController animated:YES completion:nil];
}
@end
