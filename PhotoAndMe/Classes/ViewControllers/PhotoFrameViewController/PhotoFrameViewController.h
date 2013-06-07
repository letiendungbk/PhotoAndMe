//
//  PhotoFrameViewController.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface PhotoFrameViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (retain, nonatomic) Category *category;

@property (retain, nonatomic) IBOutlet UITableView *tableView;


@end

