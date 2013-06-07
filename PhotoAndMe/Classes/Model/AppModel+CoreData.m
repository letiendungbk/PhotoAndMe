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
#import <Parse/Parse.h>

NSString *const ModelChangeNotification = @"ModelChangeNotification";

@implementation AppModel (CoreData)


#pragma mark public

//FixME
//- xu ly bug with many - many relationship
//- delete, delete with many-many
//[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//
//
//- upload categories, photo frames
//- isCustomedbyuser
//- file cache
//- init sqlite

- (void)startSync {
    if (!self.syncInProgress) {
        self.syncInProgress = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self loadCategories];
        });
    }
}

#pragma mark private

- (void)loadCategories
{
    [[AppModel getInstance] loadCategoriesFrom:[self mostRecentUpdatedAtDateForEntityWithName:@"Category"] WithCallback:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"loadGalleryWithCallback success");
            
            [self saveCategoriesToCoreData:objects];
            
        } else {
            NSLog(@"loadGalleryWithCallback %@ %@", error, [error userInfo]);
            self.syncInProgress = NO;
        }
    }];

}


- (void)saveCategoriesToCoreData:(NSArray *)downloadedRecords
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if ([downloadedRecords lastObject]) {
        NSArray *storedRecords = [self managedObjectsForClass:@"Category" ByKey:@"parseObjectId" usingArrayOfIds:[downloadedRecords valueForKey:@"objectId"] inArrayOfIds:YES];
        int currentIndex = 0;
        for (NSDictionary *record in downloadedRecords) {
            NSManagedObject *storedManagedObject = nil;
            if ([storedRecords count] > currentIndex) {
                storedManagedObject = [storedRecords objectAtIndex:currentIndex];
            }
            
            if ([[storedManagedObject valueForKey:@"parseObjectId"] isEqualToString:[record valueForKey:@"objectId"]]) {
                [self updateCategory:(Category *)[storedRecords objectAtIndex:currentIndex] withRecord:(PFObject *)record];
            } else {
                [self newCategoryForRecord:(PFObject *)record];
            }
            currentIndex++;
        }
    }
    
    [appDelegate saveBackgroundContext];
    
    [self loadPhotoFrames];
    
}

- (void)newCategoryForRecord:(PFObject *)row {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    Category *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:appDelegate.backgroundManagedObjectContext];
    
    [self updateCategory:category withRecord:row];
}

- (void)updateCategory:(Category *)category withRecord:(PFObject *)row {
    category.parseObjectId = row.objectId;
    category.updatedAt = row.updatedAt;
    category.displayName = [row objectForKey:@"displayName"];
    PFFile *thumbFile = [row objectForKey:@"thumbFile"];
    category.thumbFileURL =  thumbFile.url;
}



- (void)loadPhotoFrames
{
    [[AppModel getInstance] loadAllPhotoFramesFrom:[self mostRecentUpdatedAtDateForEntityWithName:@"PhotoFrame"] WithCallback:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"loadAllPhotoFramesFrom success");
            
            [self savePhotoFramesToCoreData:objects];
            
        } else {
            NSLog(@"loadAllPhotoFramesFrom %@ %@", error, [error userInfo]);
            self.syncInProgress = NO;
        }
    }];
    
}


- (void)savePhotoFramesToCoreData:(NSArray *)downloadedRecords
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if ([downloadedRecords lastObject]) {
        NSArray *storedRecords = [self managedObjectsForClass:@"PhotoFrame" ByKey:@"parseObjectId" usingArrayOfIds:[downloadedRecords valueForKey:@"objectId"] inArrayOfIds:YES];
        int currentIndex = 0;
        for (NSDictionary *record in downloadedRecords) {
            NSManagedObject *storedManagedObject = nil;
            if ([storedRecords count] > currentIndex) {
                storedManagedObject = [storedRecords objectAtIndex:currentIndex];
            }
            
            if ([[storedManagedObject valueForKey:@"parseObjectId"] isEqualToString:[record valueForKey:@"objectId"]]) {
                [self updatePhotoFrame:(PhotoFrame *)[storedRecords objectAtIndex:currentIndex] withRecord:(PFObject *)record];
            } else {
                [self newPhotoFrameForRecord:(PFObject *)record];
            }
            currentIndex++;
        }
    }
    
    [appDelegate saveBackgroundContext];
    [appDelegate saveMainThreadContext];
    [appDelegate saveMasterContext];
    
    self.syncInProgress = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:ModelChangeNotification object:nil userInfo:nil];
}

- (void)newPhotoFrameForRecord:(PFObject *)row {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    PhotoFrame *photoFrame = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoFrame" inManagedObjectContext:appDelegate.backgroundManagedObjectContext];
    
    [self updatePhotoFrame:photoFrame withRecord:row];
}

- (void)updatePhotoFrame:(PhotoFrame *)photoFrame withRecord:(PFObject *)row {
    photoFrame.parseObjectId = row.objectId;
    photoFrame.updatedAt = row.updatedAt;
    photoFrame.displayName = [row objectForKey:@"displayName"];
    PFFile *photoFile = [row objectForKey:@"photoFile"];
    photoFrame.photoFileURL =  photoFile.url;
    PFFile *bigPhotoFile = [row objectForKey:@"bigPhotoFile"];
    photoFrame.bigPhotoFileURL =  bigPhotoFile.url;
    photoFrame.frameRect = [[row valueForKey:@"frameRect"] componentsJoinedByString:@""];
    
    NSArray *belongsToCategories = [row valueForKey:@"belongsToCategories"];
    NSSet *oldCategories = [[photoFrame.categories copy] autorelease];
    for (Category *item in oldCategories) {
        if ([belongsToCategories indexOfObject:item.parseObjectId] == NSNotFound) {
            [item removePhotoFramesObject:photoFrame];
        }
    }
    
    NSArray *belongsToRecords = [self managedObjectsForClass:@"Category" ByKey:@"parseObjectId" usingArrayOfIds:[row valueForKey:@"belongsToCategories"] inArrayOfIds:YES];
    photoFrame.categories = [NSSet setWithArray:belongsToRecords];
}


#pragma mark utilities
- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    __block NSDate *date = nil;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    [request setFetchLimit:1];
    
    [appDelegate.backgroundManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [appDelegate.backgroundManagedObjectContext executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            //
            // Set date to the fetched result
            //
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];
    
    return date;
}

- (NSArray *)managedObjectsForClass:(NSString *)className ByKey:(NSString *)key usingArrayOfIds:(NSArray *)idArray inArrayOfIds:(BOOL)inIds {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = appDelegate.backgroundManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate;
    if (inIds) {
        predicate = [NSPredicate predicateWithFormat:@"parseObjectId IN %@", idArray];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"NOT (parseObjectId IN %@)", idArray];
    }
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:
                                      [NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

@end
