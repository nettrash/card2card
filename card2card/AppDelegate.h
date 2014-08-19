//
//  AppDelegate.h
//  card2card
//
//  Created by Ivan Alekseev on 03.09.13.
//  Copyright (c) 2013 OCEAN BANK CJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UIImageView *vBlur;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL)iPhone5;
- (UIImage*)blur:(UIImage*)theImage;
- (UIImage*)blurryGPUImage:(UIImage *)image withBlurLevel:(NSInteger)blur andPhases:(NSInteger)phases;
- (UIImage*)scaleIfNeeded:(CGImageRef)cgimg;
- (UIImage*)takeScreenShot;
- (void)initializeWithURL:(NSURL *)url;

@end
