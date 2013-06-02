//
//  PhotoFrameViewController.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoFrameViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (copy, nonatomic) NSString *categoryCode;

@property (retain, nonatomic) IBOutlet UITableView *tableView;


@end

