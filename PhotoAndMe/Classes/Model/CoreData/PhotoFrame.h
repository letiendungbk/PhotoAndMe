//
//  PhotoFrame.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/7/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface PhotoFrame : NSManagedObject

@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * frameRect;
@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) NSString * photoFileURL;
@property (nonatomic, retain) NSString * bigPhotoFileURL;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *categories;
@end

@interface PhotoFrame (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

@end
