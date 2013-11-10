//
//  LeaderboardViewController.h
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-4.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
@class GKLeaderboard;


//this is the default leaderboard
@interface LeaderboardViewController : UIViewController <GKGameCenterControllerDelegate>{
        UIActivityIndicatorView *_indicator;
}

@property (retain, nonatomic) IBOutlet UITableView *leaderboardTableView;
@property (nonatomic, retain) NSArray *leaderboards;

@property (nonatomic, retain) NSArray *players;
@property (nonatomic, retain) NSArray *scores;
@end
