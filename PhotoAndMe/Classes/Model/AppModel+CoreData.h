//
//  AppModel+CoreData.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/4/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "AppModel.h"
#import "Category.h"
#import "PhotoFrame.h"

UIKIT_EXTERN NSString *const ModelChangeNotification;

@interface AppModel (CoreData)

- (void)startSync;

@end
