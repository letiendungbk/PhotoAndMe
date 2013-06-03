//
//  GalleryViewController.m
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryItemView.h"
#import "PhotoFrameViewController.h"
#import "AppModel.h"

@interface GalleryViewController ()

@property (retain, nonatomic) NSArray *categories;

@end

@implementation GalleryViewController

- (void)dealloc
{
    self.tableView = nil;
    self.categories = nil;
    
    [super dealloc];
}

- (void)viewDidUnload {
    self.tableView = nil;
    self.categories = nil;
    
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
    
    
    
    [[AppModel getInstance] loadGalleryWithCallback:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"loadGalleryWithCallback success");
            self.categories = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"loadGalleryWithCallback %@ %@", error, [error userInfo]);
        }
    }];
}


- (NSString *)title
{
    return @"Gallery";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GalleryItemViewCellIdentifier = @"GalleryItemView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GalleryItemViewCellIdentifier];
    GalleryItemView *galleryItemView;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GalleryItemViewCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        galleryItemView = [[[GalleryItemView alloc] init] autorelease];
        galleryItemView.tag = 789;
        [cell.contentView addSubview:galleryItemView];
    }
    
    // Configure the cell...
    galleryItemView = (GalleryItemView *)[cell viewWithTag:789];
    galleryItemView.data = [self.categories objectAtIndex:indexPath.row];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoFrameViewController *photoFrameViewController = [[PhotoFrameViewController alloc] initWithNibName:@"PhotoFrameViewController" bundle:nil];
    photoFrameViewController.categoryCode = [[self.categories objectAtIndex:indexPath.row] objectForKey:@"categoryCode"];
    
    [self.navigationController pushViewController:photoFrameViewController animated:YES];
    [photoFrameViewController release];
}


@end
