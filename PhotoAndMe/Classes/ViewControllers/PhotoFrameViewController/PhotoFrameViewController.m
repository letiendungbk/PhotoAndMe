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
#import "AppModel+Parse.h"
#import "AppModel+CoreData.h"
#import "AppDelegate.h"
#import "Category.h"
#import "PhotoFrame.h"
#import <Parse/Parse.h>
#import "EffectGLViewController.h"

@interface PhotoFrameViewController ()

@property (retain, nonatomic) NSArray *photoFrames;

@end

@implementation PhotoFrameViewController

- (void)dealloc
{
    self.tableView = nil;
    self.photoFrames = nil;
    
    [super dealloc];
}

- (void)viewDidUnload {
    self.tableView = nil;
    self.photoFrames = nil;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelChangeHandler) name:ModelChangeNotification object:nil];
    
    [self modelChangeHandler];
}

- (void)modelChangeHandler
{
    //FIXME go to Core data to refresh PhotoFrame
    
    self.photoFrames = [self.category.photoFrames allObjects];
    [self.tableView reloadData];
}


- (NSString *)title
{
    return self.category.displayName;
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
    EffectGLViewController *effectGLViewController = [[EffectGLViewController alloc] initWithNibName:@"EffectGLViewController" bundle:nil];
    
    [self.navigationController pushViewController:effectGLViewController animated:YES];
    [effectGLViewController release];
}


@end
