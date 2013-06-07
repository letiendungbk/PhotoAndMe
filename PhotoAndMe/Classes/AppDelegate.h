//
//  AppDelegate.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (nonatomic, retain) UINavigationController *navigationController;

@property (readonly, retain, nonatomic) NSManagedObjectContext *masterManagedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectContext *mainThreadManagedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveMasterContext;
- (void)saveMainThreadContext;
- (void)saveBackgroundContext;

@end
