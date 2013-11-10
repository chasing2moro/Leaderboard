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
    [[LeaderboardMgr sharedInstance] reportScore:1 forLeaderboardID:nil];
}

- (IBAction)twoScoreButtonPressed:(id)sender {
    [[LeaderboardMgr sharedInstance] reportScore:2 forLeaderboardID:nil];
}

- (IBAction)threeScoreButtonPressed:(id)sender {
    [[LeaderboardMgr sharedInstance] reportScore:3 forLeaderboardID:nil];
}

- (void) getDefaultLeaderboard:(GKLeaderboard *)leaderbosrds{
    [_indicator stopAnimating];
}
@end
