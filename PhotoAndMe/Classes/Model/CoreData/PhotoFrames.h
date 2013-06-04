//
//  PhotoFrames.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/4/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categories;

@interface PhotoFrames : NSManagedObject

@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * frameRect;
@property (nonatomic, retain) NSString * photoFileURL;
@property (nonatomic, retain) NSSet *categories;
@end

@interface PhotoFrames (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(Categories *)value;
- (void)removeCategoriesObject:(Categories *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

@end
