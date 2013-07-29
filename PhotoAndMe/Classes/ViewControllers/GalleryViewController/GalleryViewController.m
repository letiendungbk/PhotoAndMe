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
#import "AppModel+Parse.h"
#import "AppModel+CoreData.h"
#import "AppDelegate.h"
#import "Category.h"
#import "PhotoFrame.h"
#import <Parse/Parse.h>
#import "AddCategoryViewController.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelChangeHandler) name:ModelChangeNotification object:nil];
    
    [self modelChangeHandler];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"")
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(addCategory)] autorelease];
    

}

- (void)modelChangeHandler
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category"
                                              inManagedObjectContext:appDelegate.mainThreadManagedObjectContext];
    [fetchRequest setEntity:entity];

    [appDelegate.mainThreadManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        self.categories = [appDelegate.mainThreadManagedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"modelChangeHandler %@", error);
        }
    }];
    
    [self.tableView reloadData];
    
    [fetchRequest release];
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
    
    Category *selectedCategory = (Category *)[self.categories objectAtIndex:indexPath.row];
    photoFrameViewController.category = selectedCategory;
    
    [self.navigationController pushViewController:photoFrameViewController animated:YES];
    [photoFrameViewController release];
}


#pragma mark add Category
- (void)addCategory
{
    AddCategoryViewController *addCategoryViewController = [[AddCategoryViewController alloc] initWithNibName:@"AddCategoryViewController" bundle:nil];
    
    [self.navigationController pushViewController:addCategoryViewController animated:YES];
    [addCategoryViewController release];
}

@end
