//
//  ReportScoreViewController.m
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-4.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import "ReportScoreViewController.h"
#import "LeaderboardMgr.h"

@interface ReportScoreViewController ()

@end

@implementation ReportScoreViewController

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
	// Do any additional setup after loading the view.
    
    _indicator = [CommonHelper createdIndicatorAddToSubViewCenterBySubView:self.view];
    if ([[LeaderboardMgr sharedInstance] defaultLeaderboard] == nil) {
        [_indicator startAnimating];
        [[LeaderboardMgr sharedInstance] loadLeaderboardInfoWithDelegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)oneSorceButtonPressed:(id)sender {
    [self _reportScore:1];
}

- (IBAction)twoScoreButtonPressed:(id)sender {
    [self _reportScore:2];
}

- (IBAction)threeScoreButtonPressed:(id)sender {
    [self _reportScore:3];
}

- (void) getDefaultLeaderboard:(GKLeaderboard *)leaderbosrds{
    [_indicator stopAnimating];
}

- (void) _reportScore:(uint64_t)score{
    _score = score;
    [[LeaderboardMgr sharedInstance] reportScore:_score forLeaderboardID:nil delegate:self];
    [_indicator startAnimating];
}

#pragma mark - Delegate
- (void)reportScore:(NSError *)error{
    [_indicator stopAnimating];
    if (error != nil) {
        [GKNotificationBanner showBannerWithTitle:nil
                                          message:[NSString stringWithFormat:@"report score:%lld to leaderboard encounter error:%@", _score, error.description]
                                completionHandler:nil];
    }else{
        [GKNotificationBanner showBannerWithTitle:nil
                                          message:[NSString stringWithFormat:@"report score:%lld to leaderboard", _score]
                                completionHandler:nil];
    }
}
@end
