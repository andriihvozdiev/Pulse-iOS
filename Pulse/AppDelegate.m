#import "AppDelegate.h"
#import "AppData.h"

#import "LoginViewController.h"
#import "ResetPasswordVC.h"
#import "MainTabbarViewController.h"

#import "TankGaugeEntryVC.h"
#import "WellheadDataVC.h"
#import "MeterDataVC.h"
#import "MainTabbarViewController.h"
#import "ProductionDetailMainVC.h"
#import "ToolboxVC.h"
#import "ProductionMainVC.h"

@import PeekPop;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (![userdefaults valueForKey:S_DaysToSync]) {
        [userdefaults setValue:@"7" forKey:S_DaysToSync];
    }
    
    if ([userdefaults valueForKey:S_Email] && [userdefaults valueForKey:S_Password]) {
        [self loginMethodWith:[[NSUserDefaults standardUserDefaults] valueForKey:S_Email] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:S_Password]];
    }
    
    UIImage *whiteBackground = [UIImage imageNamed:@"tabbaritem_bg"];
    [[UITabBar appearance] setSelectionIndicatorImage:whiteBackground];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"TTTTTTTTTT");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    NSLog(@"enter background");
    
    [AppData sharedInstance].isBackground = YES;
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [AppData sharedInstance].isBackground = NO;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"App is active");
    [AppData sharedInstance].isBackground = NO;
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userdefaults valueForKey:S_Email] && [userdefaults valueForKey:S_Password]) {
        [[AppData sharedInstance] changedSyncStatus:Synced];
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    NSLog(@"application will terminate");
    [self saveContext];
}



- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation {
    
    NSString *StrURL = [url description];
    if([StrURL rangeOfString:@"pulsepassword"].length !=0)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        ResetPasswordVC *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ResetPasswordVC"];
        vc.openUrlID = StrURL;
        [(UINavigationController*)self.window.rootViewController pushViewController:vc animated:YES];
        
        return YES;
    } else if([StrURL rangeOfString:@"pulseverification"].length !=0) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.openUrlID = StrURL;
        [(UINavigationController*)self.window.rootViewController pushViewController:vc animated:YES];
        
        return YES;
        
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    NSString *StrURL = [url description];
    if([StrURL rangeOfString:@"pulsepassword"].length !=0)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ResetPasswordVC *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ResetPasswordVC"];
        vc.openUrlID = StrURL;
        [(UINavigationController*)self.window.rootViewController pushViewController:vc animated:YES];
        
        return YES;
        
    } else if([StrURL rangeOfString:@"pulseverification"].length !=0) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.openUrlID = StrURL;
        [(UINavigationController*)self.window.rootViewController pushViewController:vc animated:YES];
        
        return YES;        
    }
    
    return NO;
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Pulse"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}



#pragma mark -

-(void)loginMethodWith:(NSString *)email andPassword:(NSString *)password
{
    NSString *interval = [[NSUserDefaults standardUserDefaults] valueForKey:S_SyncInterval];
    if (interval) {
        [[AppData sharedInstance] startAutoSyncing];
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MainTabbarViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabbarViewController"];
    
    self.window.rootViewController = vc;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "pixels.com.Swift_Release" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Pulse" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Pulse.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - orientation rotate.

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([self.window.rootViewController isKindOfClass:[MainTabbarViewController class]]) {
        MainTabbarViewController *mainTabbarController = (MainTabbarViewController*)self.window.rootViewController;
        if (mainTabbarController.selectedIndex != 0 && mainTabbarController.selectedIndex != 2) {
            
            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UINavigationController *mainNavVC = (UINavigationController*)(mainTabbarController.selectedViewController);
        if ( [mainNavVC.topViewController isKindOfClass:[ProductionDetailMainVC class]] ||
            [mainNavVC.topViewController isKindOfClass:[TankGaugeEntryVC class]] ||
            [mainNavVC.topViewController isKindOfClass:[MeterDataVC class]] ||
            [mainNavVC.topViewController isKindOfClass:[WellheadDataVC class]] ||
            [mainNavVC.topViewController isKindOfClass:[ToolboxVC class]])
        {
            UIViewController *fullController = ((UINavigationController*)mainTabbarController.selectedViewController).topViewController;
            
            if (fullController.view.tag == 10){
                return UIInterfaceOrientationMaskAllButUpsideDown;
            }else{
                return UIInterfaceOrientationMaskPortrait;
            }
        } else {
            return UIInterfaceOrientationMaskPortrait;
        }
    }
    
    return UIInterfaceOrientationMaskPortrait;    
}

@end
