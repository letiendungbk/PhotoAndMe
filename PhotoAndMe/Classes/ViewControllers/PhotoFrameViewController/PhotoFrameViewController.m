//
//  PhotoFrameViewController.m
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "PhotoFrameViewController.h"
#import "PhotoFrameItemView.h"
#import "AppModel.h"

@interface PhotoFrameViewController ()

@property (retain, nonatomic) NSArray *photoFrames;

@end

@implementation PhotoFrameViewController

- (void)dealloc
{
    self.tableView = nil;
    self.photoFrames = nil;
    self.categoryCode = nil;
    
    [super dealloc];
}

- (void)viewDidUnload {
    self.tableView = nil;
    self.photoFrames = nil;
    self.categoryCode = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.photoFrames = @[
//                        @{@"categoryCode":@"nature", @"displayName":@"Nature", @"photoURL":@"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/50322_373165766042153_1840934980_q.jpg"}
//                        ];
    
    [[AppModel getInstance] loadPhotoFrameForCategory:self.categoryCode WithCallback:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"loadPhotoFrameForCategory success");
            self.photoFrames = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"loadPhotoFrameForCategory %@ %@", error, [error userInfo]);
        }
    }];

}

- (NSString *)title
{
    return self.categoryCode;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PhotoFrameItemViewCellIdentifier = @"PhotoFrameItemView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PhotoFrameItemViewCellIdentifier];
    PhotoFrameItemView *photoFrameItemView;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PhotoFrameItemViewCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        photoFrameItemView = [[[PhotoFrameItemView alloc] init] autorelease];
        photoFrameItemView.tag = 789;
        [cell.contentView addSubview:photoFrameItemView];
    }
    
    // Configure the cell...
    photoFrameItemView = (PhotoFrameItemView *)[cell viewWithTag:789];
    photoFrameItemView.data = [self.photoFrames objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
