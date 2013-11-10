//
//  ReportScoreViewController.h
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-4.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportScoreViewController : UIViewController{
    UIActivityIndicatorView *_indicator;
}
- (IBAction)oneSorceButtonPressed:(id)sender;
- (IBAction)twoScoreButtonPressed:(id)sender;
- (IBAction)threeScoreButtonPressed:(id)sender;

@end
