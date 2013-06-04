//
//  AppModel+CoreData.m
//  PhotoAndMe
//
//  Created by LeTienDung on 6/4/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "AppModel+CoreData.h"
#import "AppModel+Parse.h"
#import "AppDelegate.h"
#import "Categories.h"
#import "PhotoFrames.h"
#import <Parse/Parse.h>

NSString *const ModelChangeNotification = @"ModelChangeNotification";

@implementation AppModel (CoreData)

- (void)syncCategories
{
    [[AppModel getInstance] loadCategoriesWithCallback:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"loadGalleryWithCallback success");
            
            [self saveCategoriesToCoreData:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:ModelChangeNotification object:nil userInfo:nil];
            
        } else {
            NSLog(@"loadGalleryWithCallback %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)saveCategoriesToCoreData:(NSArray *)categories
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    for (PFObject *row in categories) {
        //must store parseObjectId as a field in Core Data
        NSLog(@"objectId:%@", row.objectId);
        
        NSLog(@"displayName:%@", [row objectForKey:@"displayName"]);
        
        PFFile *thumbFile = [row objectForKey:@"thumbFile"];
        NSLog(@"thumbFileURL:%@", thumbFile.url);
        
        Categories *category = [NSEntityDescription
                                                insertNewObjectForEntityForName:@"Categories"
                                                inManagedObjectContext:appDelegate.managedObjectContext];
        category.parseObjectId = row.objectId;
        category.displayName = [row objectForKey:@"displayName"];
        category.thumbFileURL =  thumbFile.url;
        
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
    }
}





@end
