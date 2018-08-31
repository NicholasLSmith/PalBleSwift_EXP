//
//  AppDelegate.h
//  Obj3
//
//  Created by Nicholas Smith on 31/08/2018.
//  Copyright © 2018 PAL Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

