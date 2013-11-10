//
//  FriendsViewController.h
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-4.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController{
    UIActivityIndicatorView *_indicator;
}
@property (nonatomic, retain) IBOutlet UITableView *friendsTableView;
@property (nonatomic, retain) NSArray *friends;//hold GKPlayer
@end
