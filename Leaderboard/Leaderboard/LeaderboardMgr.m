//
//  LeaderboardMgr.m
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-3.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import "LeaderboardMgr.h"
#import "CommonHelper.h"

@implementation LeaderboardMgr
SYNTHESIZE_SINGLETON_FOR_CLASS(LeaderboardMgr);

- (void)dealloc{
#if UseMemberLeaderboards
    [_leaderboards release];
#endif
    [super dealloc];
}

- (void) authenticateLocalPlayer:(id)aViewControllerDelegate{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            //If the device doesn't have an authenticated player, Game Kit passes a non-nil view controller
            if (aViewControllerDelegate != nil && [aViewControllerDelegate respondsToSelector:@selector(showAuthenticationDialogWhenReasonable:)]){
                [aViewControllerDelegate showAuthenticationDialogWhenReasonable:viewController];
            }
            NSLog(@"LocalPlayer Authenticated View Controller Should Show");
        }else if (localPlayer.authenticated){
            [aViewControllerDelegate playerauthenticated:YES];
        }else{
            [aViewControllerDelegate playerauthenticated:NO];
        }
    };
}

- (void) retrieveLocalPlayerFriendsWithDelegate:(id)receiverDelegate{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (localPlayer.authenticated) {
        
        //(1) load friends id
        [localPlayer loadFriendsWithCompletionHandler:^(NSArray *friendIDs, NSError *error) {
            if (error != nil) {
                NSLog(@"local friends encounter error:%@", error.description);
            }
            if (friendIDs != nil) {
                if (friendIDs.count > 0) {
                    
                    //(2) load friends' basic content from friend id
                    [GKPlayer loadPlayersForIdentifiers:friendIDs withCompletionHandler:^(NSArray *players, NSError *error) {
                        if (error != nil) {
                            NSLog(@"retrieve local player's friends encounter error:%@", error.description);
                        }
                        
                        if (players != nil) {
                            if (receiverDelegate != nil && [receiverDelegate respondsToSelector:@selector(getLocalPlayerFriends:)])
                                [receiverDelegate getLocalPlayerFriends:players];
                        }
                    }];
                }else{
                    if (receiverDelegate != nil && [receiverDelegate respondsToSelector:@selector(getLocalPlayerFriends:)])
                        //no friends
                        [receiverDelegate getLocalPlayerFriends:nil];
                }
                
            }
        }];
    }
}

- (void) loadLeaderboardInfoWithDelegate:(id)receiveDelegate{
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
        if (error == nil) {

            self.leaderboards = leaderboards;
            
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                for (GKLeaderboard *leaderboard in _leaderboards) {
                    if ([leaderboardIdentifier compare:leaderboard.identifier] == NSOrderedSame) {
                        // set default leaderboard
                        _defaultLeaderboard = leaderboard;
                        
                        //show leaderboard
                        if (receiveDelegate != nil && [receiveDelegate respondsToSelector:@selector(getDefaultLeaderboard:)])
                            [receiveDelegate getDefaultLeaderboard:_defaultLeaderboard];
                        break;
                    }
                }
            }];


        }else{
            NSLog(@"load leaderboard info encounter error:%@ (%s%d)", error.description, __FUNCTION__, __LINE__);
        }
    }];
}

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString *)identifier delegate:(id)delegate{

    // set the default identifier
    if (identifier == nil) {
            identifier = _defaultLeaderboard.identifier;
    }

    //encapsulate socre to NSArray
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;// this property is up to your use
    NSArray *scores = @[scoreReporter];
    
    //report socre to leaderboard
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (delegate != nil && [delegate respondsToSelector:@selector(reportScore:)]) {
            [delegate reportScore:error];
        }
    }];
}

// show player info
+ (void)showPlayerInfo:(GKPlayer *)player{
    NSString *bannerString = [NSString stringWithFormat:@"Your Name:%@" ,player.displayName];
    [GKNotificationBanner showBannerWithTitle:nil
                                      message:bannerString
                            completionHandler:nil];
    
    if ([player isKindOfClass:[GKLocalPlayer class]]) {
        
    }
}


// show leaderboard info
+ (void)showLeaderboardInfo:(GKLeaderboard *)leaderboard{
    NSString *bannerString = [NSString stringWithFormat:@"Leaderboard Identifier:%@ / title:%@", leaderboard.identifier, leaderboard.title ];
    [GKNotificationBanner showBannerWithTitle:nil
                                      message:bannerString
                            completionHandler:nil];
}
@end
