//
//  LeaderboardViewController.m
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-4.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LeaderboardMgr.h"

#define kLabelRank 100
#define kLabelPlayerName 101
#define kLabelScore 102

#define kPlayerAliasNameLen 5

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController


#pragma mark -
- (void)dealloc{
    [_leaderboards release];
    [_indicator release];
    [_leaderboardTableView release];
    [_players release];
    [_scores release];
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

    _indicator = [CommonHelper createdIndicatorAddToSubViewCenterBySubView:self.view];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //load leaderboard
    [_indicator startAnimating];
    [[LeaderboardMgr sharedInstance] loadLeaderboardInfoWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private
// show leaderboard
- (void) _showDefaultLeaderboard:(NSString *) leaderboardID{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        
        //GKGameCenterViewController no longer supports leaderboard time scopes. Will always default to GKLeaderboardTimeScopeAllTime.
       // gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
        
        gameCenterController.leaderboardIdentifier = leaderboardID;

        
        [self presentViewController:gameCenterController animated:YES completion:nil];
    }
}

/*
 代码块 声明例子
 int (^triple)(int) = ^(int number) {
 return number * 3;
 };
 */

- (void) _showCostomLeaderboardWithIdentifier:(NSString *)identifier{
    
    //pretend B Block
    void(^aBlock)(NSArray *, NSError *) = ^(NSArray *scores, NSError *error){
        
        if (error != nil)
        {
            [CommonHelper showTipWithTitle:nil msg:[NSString stringWithFormat:@"show costom leaderboard encounter error:%@", error.description]];
        }
        if (scores != nil)
        {
            self.scores = scores;//assign
            NSMutableArray *playerIdentifiers = [NSMutableArray array];
            for (GKScore *score in scores) {
                [playerIdentifiers addObject:score.playerID];
#if 1
                NSLog(@"rank:%ld / playerId:%@ / value:%lld / formattedValue:%@",
                      (long)score.rank,
                      score.playerID,
                      score.value,
                      score.formattedValue);
#endif
            }

            
            [GKPlayer loadPlayersForIdentifiers:playerIdentifiers
                          withCompletionHandler:^(NSArray *players,
                                                  NSError *error){
                              if (error != nil)
                              {
                                  [CommonHelper showTipWithTitle:nil msg:[NSString stringWithFormat:@"show costom leaderboard encounter error:%@", error.description]];
                              }
                              if (players != nil) {
                                    [_indicator stopAnimating];
                                  self.players = players;//assign
                                  [_leaderboardTableView reloadData];
#if 1
                                  for (GKPlayer *player  in players) {
                                      NSLog(@"player : %@", player);
                                  }
#endif
                              }
                          }];
        }
        
    };
    
    
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest != nil)
    {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;//GKLeaderboardTimeScopeToday;
        leaderboardRequest.identifier = identifier;
        leaderboardRequest.range = NSMakeRange(1,10);
        [leaderboardRequest loadScoresWithCompletionHandler:aBlock];
    }
}
#pragma mark - Delegate
- (void) getDefaultLeaderboard:(GKLeaderboard *)defaultLeaderboard{
    //[self _showDefaultLeaderboard:defaultLeaderboard.identifier];
    [self _showCostomLeaderboardWithIdentifier:defaultLeaderboard.identifier];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _scores == nil ? 0 : _scores.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"LeaderboardTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UILabel *labelRank =  (UILabel *)[cell viewWithTag:kLabelRank];
    UILabel *labelPlayerName = (UILabel *)[cell viewWithTag:kLabelPlayerName];
    UILabel *labelScore = (UILabel *)[cell viewWithTag:kLabelScore];
    
    NSAssert(labelRank != nil && labelPlayerName != nil && labelScore != nil, @"Finding Label in cell encounter error");
    
    GKScore *score = [_scores objectAtIndex:indexPath.row];
    GKPlayer *player = nil;
    for (GKPlayer *aPlayer in _players) {
        if ([score.playerID isEqualToString:aPlayer.playerID]) {
            player = aPlayer;
            break;
        }
    }
    

    labelRank.text = [NSString stringWithFormat:@"%d", score.rank];
    labelPlayerName.text = [player.alias substringToIndex:kPlayerAliasNameLen >= player.alias.length ? player.alias.length : kPlayerAliasNameLen];
    labelScore.text = score.formattedValue;
    return cell;
}

@end
