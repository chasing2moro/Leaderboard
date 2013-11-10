//
//  LeaderboardMgr.h
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-3.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "SynthesizeSingleton.h"



@protocol ViewControllerDelegate <NSObject>
@optional;
- (void) showAuthenticationDialogWhenReasonable:(UIViewController *)viewController;
- (void) playerauthenticated:(BOOL)authenticate;
//friends holds GKPlayer objects
- (void) getLocalPlayerFriends:(NSArray *)friends;
//leaderboards holds GKLeaderboard objects
- (void) getDefaultLeaderboard:(GKLeaderboard *)leaderbosrds;
- (void)reportScore:(NSError *)error;
@end

@interface LeaderboardMgr : NSObject{
    GKLeaderboard *_defaultLeaderboard;
}

@property (nonatomic, retain) NSArray *leaderboards;
@property (nonatomic, readonly) GKLeaderboard *defaultLeaderboard;


SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(LeaderboardMgr);

//Authenticating a Local Player on the Device
- (void) authenticateLocalPlayer:(id)aViewControllerDelegate;

// retrieve lcoal player's friends
// async
- (void) retrieveLocalPlayerFriendsWithDelegate:(id)receiverDelegate;

// Load Leaderboard Info (Signed by Developer) From iTunes Connect
// async
- (void) loadLeaderboardInfoWithDelegate:(id)receiveDelegate;

// report score to leaderboard
// async
- (void)reportScore:(int64_t)socre forLeaderboardID:(NSString *)identifier delegate:(id)delegate;
@end
