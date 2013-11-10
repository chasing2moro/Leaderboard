//
//  FriendsViewController.m
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-4.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import "FriendsViewController.h"
#import "LeaderboardMgr.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)dealloc {
    [_friendsTableView release];
    [_indicator release];
    [super dealloc];
}

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
    
    _indicator = [CommonHelper createdIndicatorAddToSubViewCenterBySubView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
     
}

// Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_indicator startAnimating];
    [[LeaderboardMgr sharedInstance] retrieveLocalPlayerFriendsWithDelegate:self];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _friends == nil ? 0 : _friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    GKPlayer *player = [_friends objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", player.displayName, player.alias];
    return  cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}

#pragma mark - LeaderboardMgr Delegate

- (void)getLocalPlayerFriends:(NSArray *)friends{
    [_indicator stopAnimating];
    if (friends == nil) {
        [CommonHelper showTipWithTitle:nil msg:@"No Friends"];
        return;
    }
    
    self.friends = friends;
    [_friendsTableView reloadData];
}


@end
