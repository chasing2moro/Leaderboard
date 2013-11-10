//
//  ViewController.h
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-3.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    // data to display at tableView
    NSArray *_tableData;
    // viewController to present when click tableViewCell
    NSArray *_viewControllers;
}
@property (retain, nonatomic) IBOutlet UITableView *navTableView;
@property (retain, nonatomic) IBOutlet UILabel *navLabel;

@end
