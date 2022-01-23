#import "AppData.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "Toast.h"

#define APINumber 47

@interface AppData ()
{
    NSTimer *mTimer;
    int passcodeCounter;
    BOOL isShowPasscode;
}
@end


@implementation AppData

@synthesize isSyncing;
@synthesize successCount;
@synthesize failedCount;

@synthesize arrAccounts;
@synthesize arrPeople;
@synthesize arrSelectedAccounts;
@synthesize arrSelectedAccountTimes;
@synthesize arrSelectedAccountTimeUnits;

@synthesize arrSelectedPeople;
@synthesize strComment;
@synthesize strTubingComment;
@synthesize strRodComment;

@synthesize arrRoutes;
@synthesize arrOperatings;
@synthesize arrOwns;
@synthesize isEmptyPermission;

@synthesize arrLeases;
@synthesize arrLeaseNames;

@synthesize arrSelectedDates;
@synthesize arrScheduleComments;
@synthesize arrDownloadStatus;
@synthesize arrSecondDownloadStatus;

+(instancetype)sharedInstance
{
    static AppData *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        singleton = [[AppData alloc] init];
    });
    return singleton;
}

-(id) init
{
    self = [super init];
    
    [self initialize];
    
    return self;
}

-(void) initialize
{
    isSyncing = NO;
    
    isShowPasscode = NO;
    
    self.invoiceApprovalType = Field;
    arrAccounts = [[NSArray alloc] init];
    arrPeople = [[NSArray alloc]init];
    arrSelectedAccounts = [[NSMutableArray alloc] init];
    arrSelectedAccountTimes = [[NSMutableArray alloc] init];
    arrSelectedAccountTimeUnits = [[NSMutableArray alloc] init];
    
    arrSelectedPeople = [[NSMutableArray alloc] init];
    strComment = @"";
    strTubingComment = @"";
    strRodComment = @"";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    arrRoutes = [userDefaults valueForKey:S_Routes];
    arrOperatings = [userDefaults valueForKey:S_Operatings];
    arrOwns = [userDefaults valueForKey:S_Owns];
    isEmptyPermission = [userDefaults valueForKey:S_EmptyPermission];
    
    arrLeases = [[NSMutableArray alloc] init];
    arrLeaseNames = [[NSMutableArray alloc] init];
    
    
    arrSelectedDates = [[NSMutableArray alloc] init];
    arrScheduleComments = [[NSMutableArray alloc] init];
    arrDownloadStatus = [[NSMutableArray alloc] init];
    arrSecondDownloadStatus = [[NSMutableArray alloc] init];
    for (int i = 0; i < APINumber; i++) {
        [arrDownloadStatus addObject:[NSNumber numberWithBool:YES]];
    }
    self.selectedWaterMeterPumpInfo = nil;
}

#pragma mark - sync setting
-(void) startAutoSyncing
{
    [self stopAutoSyncing];
    
    if (!self.bgTask) {
        self.bgTask = [[BackgroundTask alloc] init];
    }
    
    [self.bgTask startBackgroundTasks:30 target:self selector:@selector(syncData:)];
}

-(void) syncData:(NSTimer*)timer
{
    NSDate *lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:S_SyncLastTime];
    NSTimeInterval diff = 0;
    if (lastTime) {
        NSDate *now = [NSDate date];
        diff = [now timeIntervalSinceDate:lastTime];
        
    } else {
        diff = 0;
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:S_SyncLastTime];
    }
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (![userdefaults valueForKey:S_SyncInterval]) {
        [userdefaults setValue:@"30" forKey:S_SyncInterval];
    }
    
    int interval = [[userdefaults valueForKey:S_SyncInterval] intValue] * 60;
    
    if (diff > interval) {
        if ([userdefaults valueForKey:S_Email] && [userdefaults valueForKey:S_Password]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:S_SyncLastTime];
            [[DBManager sharedInstance] syncData];
        }
    }
    
    [self checkedLoggedinTime];
}


-(void) checkedLoggedinTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *current = [NSDate date];
    if ([userDefaults valueForKey:@"loggedInTime"] == nil) {
        [userDefaults setObject:current forKey:@"loggedInTime"];
    }
    NSDate *loggedInTime = [userDefaults valueForKey:@"loggedInTime"];
    
    NSTimeInterval diff = [current timeIntervalSinceDate:loggedInTime];
    
    int numberOfHours = diff / 3600;
    
    if (numberOfHours > 23 && !self.isBackground) {
        [self authenticateUser];
    }
}

-(void)authenticateUser
{
    NSString *isActivatedToucID = [[NSUserDefaults standardUserDefaults] valueForKey:S_ActivateTouchID];
    if (isActivatedToucID && [isActivatedToucID isEqual:@"yes"]) {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *myLocalizedReasonString = @"Authentication is needed to access the database.";
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&authError]) {
            
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError *error) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"Auth Success");
                        NSDate *current = [NSDate date];
                        [[NSUserDefaults standardUserDefaults] setObject:current forKey:@"loggedInTime"];
                    });
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        switch (error.code) {
                            case LAErrorSystemCancel:
                                NSLog(@"System Cancel");
                                break;
                            case LAErrorUserCancel:
                                NSLog(@"User Cancel");
                                break;
                            case LAErrorUserFallback:
                                NSLog(@"Fall back");
                                break;
                            default:
                                NSLog(@"Authentication failed");
                                break;
                        }
                        [self showPasscodeVC];
                    });
                }
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showPasscodeVC];
            });
        }
    } else {
        [self showPasscodeVC];
    }
}

-(void) showPasscodeVC {
    passcodeCounter = 0;
    if (!isShowPasscode) {
        isShowPasscode = YES;
        
        TOPasscodeViewController *passcodeViewController = [[TOPasscodeViewController alloc] initWithStyle:TOPasscodeViewStyleTranslucentDark passcodeType:TOPasscodeTypeFourDigits];
        [passcodeViewController.cancelButton setHidden:YES];
        passcodeViewController.delegate = self;
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [window.rootViewController presentViewController:passcodeViewController animated:YES completion:nil];
    }
}

#pragma - TOPasscodeViewController delegate
- (void)didTapCancelInPasscodeViewController:(TOPasscodeViewController *)passcodeViewController
{
//    [passcodeViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)passcodeViewController:(TOPasscodeViewController *)passcodeViewController isCorrectCode:(NSString *)code
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *strPass = [userdefaults valueForKey:S_SyncPassword];
    
    if (strPass && ![strPass isEqual:@""]) {
        if ([code isEqualToString:strPass]) {
            NSDate *current = [NSDate date];
            [[NSUserDefaults standardUserDefaults] setObject:current forKey:@"loggedInTime"];
            
            [passcodeViewController dismissViewControllerAnimated:YES completion:nil];
            isShowPasscode = NO;
            return YES;
        } else {
            if (passcodeCounter > 1) {
                passcodeCounter = 0;
                [passcodeViewController dismissViewControllerAnimated:YES completion:nil];
                
                double delayInSeconds = 1.0f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //code to be executed on the main queue after delay
                    [self logoutWithAlert:@"Auth Error" withMessage:@"Please log in again."];
                });
                
                return NO;
            }
            passcodeCounter += 1;
        }
    } else {
        isShowPasscode = NO;
        [self logoutWithAlert:@"Auth Error" withMessage:@"You didn't set your passcode."];
    }

    return NO;
}

-(void) stopAutoSyncing
{
    [self.bgTask stopBackgroundTask];
}

-(void) changedSyncStatus:(SyncStatus)syncStatus
{
    self.syncStatus = syncStatus;
    
    if (!self.isBackground) {
        [self.changedStatusDelegate changedSyncStatus];
        if (syncStatus == SyncFailed) {
            [self.downloadedDelegate downloadedCommonData];
        }
    }
}

-(SyncStatus) getSyncStatus
{
    return self.syncStatus;
}

-(void) showDefaultAlert:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    
    UIViewController *parentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    while (parentViewController.presentedViewController != nil){
        parentViewController = parentViewController.presentedViewController;
    }
    UIViewController *currentViewController = parentViewController;
    [currentViewController presentViewController:alertController animated:YES completion:nil];
}

-(void) showUnautherizedAlert
{
    [self logoutWithAlert:@"Unauthorized" withMessage:@"Please Login."];
}

-(void) logoutWithAlert:(NSString*)title withMessage:(NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setValue:nil forKey:S_UserID];
        [userdefaults setValue:nil forKey:S_Email];
        [userdefaults setValue:nil forKey:S_Password];
        [userdefaults setValue:nil forKey:S_Routes];
        [userdefaults setValue:nil forKey:S_Operatings];
        [userdefaults setValue:nil forKey:S_Owns];
        [userdefaults setValue:nil forKey:S_EmptyPermission];
        [userdefaults setValue:nil forKey:S_Downloaded];
        [userdefaults setValue:nil forKey:S_AccessToken];
        [userdefaults setValue:nil forKey:S_SyncPassword];
        
        [userdefaults setValue:nil forKey:S_SyncInterval];
        
        [[WebServiceManager sharedInstance].operationQueue cancelAllOperations];
        [[AppData sharedInstance] stopAutoSyncing];
        
        [[AppData sharedInstance] initialize];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *navVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"InitNavVC"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:navVC];
    }];
    [alertController addAction:okAction];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(NSString*) getMannualSyncAlertMessage {
    NSDate *lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:S_SyncLastTime];
    
    if (lastTime) {
        NSDate *now = [NSDate date];
        NSTimeInterval diff = [now timeIntervalSinceDate:lastTime];
        int numberOfDays = diff / 86400;
        diff -= numberOfDays * 86400;
        int numberOfHours = diff / 3600;
        diff -= numberOfHours * 3600;
        int numberOfMinutes = diff / 60;
        
        NSString *strMsg = @"";
        if (numberOfDays > 0) {
            strMsg = [NSString stringWithFormat:@"You synced all data %d days ago. Do you really want to sync all data for now?", numberOfDays];
            if (numberOfDays == 1) {
                strMsg = [NSString stringWithFormat:@"You synced all data %d day ago. Do you really want to sync all data for now?", numberOfDays];
            }
            return strMsg;
        }
        
        if (numberOfHours > 0) {
            strMsg = [NSString stringWithFormat:@"You synced all data %d hours ago. Do you really want to sync all data for now?", numberOfHours];
            if (numberOfDays == 1) {
                strMsg = [NSString stringWithFormat:@"You synced all data %d hour ago. Do you really want to sync all data for now?", numberOfHours];
            }
            return strMsg;
        }
        
        if (numberOfMinutes > 0) {
            strMsg = [NSString stringWithFormat:@"You synced all data %d minutes ago. Do you really want to sync all data for now?", numberOfMinutes];
            if (numberOfDays == 1) {
                strMsg = [NSString stringWithFormat:@"You synced all data %d minute ago. Do you really want to sync all data for now?", numberOfMinutes];
            }
            return strMsg;
        }
    }
    return @"Do you really want to sync all data for now?";
}

-(void) mannualSync
{
    if ([[AppData sharedInstance] getSyncStatus] == Syncing)
    {
        [self showDefaultAlert:@"Syncing Now..." withMessage:nil];
        return;
    }
    NSString *strMsg = [self getMannualSyncAlertMessage];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DBManager sharedInstance] syncData];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    
    UIViewController *parentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    while (parentViewController.presentedViewController != nil){
        parentViewController = parentViewController.presentedViewController;
    }
    UIViewController *currentViewController = parentViewController;
    [currentViewController presentViewController:alertController animated:YES completion:nil];
}

-(void)doSyncFailedData {
    if ([[AppData sharedInstance] getSyncStatus] == Syncing)
    {
        [self showDefaultAlert:@"Syncing Now..." withMessage:nil];
        return;
    }
    BOOL isFail = NO;
    for (NSNumber *val in arrDownloadStatus) {
        if (![val boolValue]) {
            isFail = YES;
            break;
        }
    }
    UIViewController *parentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    while (parentViewController.presentedViewController != nil){
        parentViewController = parentViewController.presentedViewController;
    }
    UIViewController *currentViewController = parentViewController;
    if (!isFail) {
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor darkGrayColor];
        [currentViewController.view makeToast:@"All data was synced successfully." duration:2.0 position:CSToastPositionBottom style:style];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to sync for the failed data?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        arrSecondDownloadStatus = [arrDownloadStatus mutableCopy];
        isSyncing = YES;
        successCount = 0;
        failedCount = 0;
        [self changedSyncStatus:Syncing];
        [self syncFailedData];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    [currentViewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - show/hide MBProgressHUD with Title

-(void) showProgressBarWithTitle:(NSString*)str
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.label.text = str;
}

-(void) hideProgressBar
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

#pragma mark - download all data.
-(void) downloadData:(BOOL)isProgressBar
{
    
    if (isProgressBar) {
        [self showProgressBarWithTitle:@"Downloading Data"];
    }
        
    if (!isSyncing) {
        isSyncing = YES;
        
        successCount = 0;
        failedCount = 0;
        
        [self changedSyncStatus:Syncing];
        
        if ([WebServiceManager connectedToNetwork]) {
            NSLog(@"Download start");
            
            [self downloadPersonnels];
            [self downloadLeaseRoutes];
            [self downloadListCompanies];
            [self downloadScheduleTypes];
            [self downloadListMeterProblem];
            [self downloadListWellProblem];
            
        } else {
            isSyncing = NO;
            [self changedSyncStatus:SyncFailed];
            [self hideProgressBar];
            [self showDefaultAlert:@"Download Failed" withMessage:@"Connection Error: Please check your connection"];
        }
    }
}

-(void)checkStatus:(BOOL) isLast
{
    int totalCount = successCount + failedCount;
    
    NSLog(@"%d %d %d", successCount, failedCount, totalCount);
    
    if (totalCount == APINumber) {
        isSyncing = NO;
        [self hideProgressBar];
        
        if (successCount == APINumber) {
            [self changedSyncStatus:Synced];
            [self.downloadedDelegate downloadedCommonData];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:S_SyncLastTime];
        } else {
            NSLog(@"Success = %d", successCount);
            [self changedSyncStatus:SyncFailed];
        }
        
        successCount = failedCount = 0;
    } else {
        if (isLast) {
            [self changedSyncStatus:Syncing];
        } else {
            [self changedSyncStatus:Syncing];
        }
    }
}

-(void) downloadPersonnels
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_Personnels param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllPersonnels:arrData]){
            NSLog(@"downloaded 1");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
            
        } else {
            NSLog(@"save 1 failed");
            
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
        }
        
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        NSLog(@"download 1 failed. %@", error);
        
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
    }];
}

-(void) downloadLeaseRoutes
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_LeaseRoutes param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveLeaseRoutes:arrData]){
            NSLog(@"downloaded 2");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
            
        } else {
            failedCount += 1;
            [self checkStatus: false];
            NSLog(@"save 2 failed");
            [arrDownloadStatus replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:NO]];
        }
        
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        NSLog(@"download 2 failed. %@", error);
        [arrDownloadStatus replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:NO]];
    }];
}

-(void) downloadListCompanies
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_ListCompanies param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary *)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveListCompanies:arrData]){
            NSLog(@"downloaded 3");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            
            NSLog(@"save 3 failed");
            [arrDownloadStatus replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
        }
        
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        NSLog(@"download 3 failed. %@", error);
        [arrDownloadStatus replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
    }];
}

-(void) downloadScheduleTypes
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_ScheduleTypes param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary *)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        if ([[DBManager sharedInstance] saveScheduleTypes:arrData]){
            NSLog(@"downloaded 4");
            
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            NSLog(@"save 4 failed");
            [arrDownloadStatus replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:NO]];
        }
        
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        NSLog(@"download 4 failed. %@", error);
        [arrDownloadStatus replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:NO]];
    }];
}

-(void) downloadListMeterProblem
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_ListMeterProblem param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveListMeterProblem:arrData]) {
            NSLog(@"downloaded 5");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:NO]];
        }
        
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        NSLog(@"download 5 failed. %@", error);
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:NO]];
    }];
}

-(void) downloadListWellProblem
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_ListWellProblem param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveListWellProblem:arrData]) {
            NSLog(@"downloaded 6");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:NO]];
        }
        [self downloadTanks:YES completionHandler:nil];
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        NSLog(@"download 6 failed. %@", error);
        failedCount += 1;
        [self checkStatus: false];
        [self downloadTanks:YES completionHandler:nil];
        [arrDownloadStatus replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:NO]];
    }];
}

#pragma mark - tanks

-(void) downloadTanks:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_Tanks param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllTanks:arrData]){
            NSLog(@"downloaded 7");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:6 withObject:[NSNumber numberWithBool:YES]]; //tmp
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:6 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadTankGaugeEntries:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        NSLog(@"download 7 failed. %@", error);
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:6 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadTankGaugeEntries:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
    
}

-(void) downloadTankGaugeEntries:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    [self getUserPermissions];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    
    NSDictionary *dicParameter = @{@"userid": userid, @"routes": arrRoutes, @"operatings": arrOperatings, @"owns": arrOwns, @"isemptypermission": isEmptyPermission};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_TankGaugeEntries param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        NSLog(@"TankGaugeEntries count: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] saveAllTankGaugeEntries:arrData])
        {
            NSLog(@"downloaded 8");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:7 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:7 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadTankStrappings:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 8 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:7 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadTankStrappings:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadTankStrappings:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_TankStrappings param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllTankStrappings:arrData]) {
            NSLog(@"downloaded 9");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:8 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:8 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadRunTickets:YES completionHandler:nil];
        else
            completionBlock(YES);

    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 9 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:8 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadRunTickets:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadRunTickets:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid, @"isNeededUrlForImage": @"1"};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_RunTickets param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        NSLog(@"RunTickets count: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] saveAllRunTickets:arrData]) {
            NSLog(@"downloaded 10");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:9 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:9 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadMeters:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 10 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:9 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadMeters:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

#pragma mark - Meters

-(void) downloadMeters:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_Meters param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllMeters:arrData]){
            NSLog(@"downloaded 11");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:10 withObject:[NSNumber numberWithBool:YES]];
            
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:10 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadGasMeterData:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 11 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:10 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadGasMeterData:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadGasMeterData:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_GasMeterData param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllGasMeterData:arrData]) {
            NSLog(@"downloaded 12");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:11 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:11 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWaterMeterData:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 12 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:11 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWaterMeterData:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadWaterMeterData:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WaterMeterData param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllWaterMeterData:arrData]) {
            NSLog(@"downloaded 13");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:12 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:12 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWellList:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 13 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:12 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWellList:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void)downloadWellList:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WellList param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        NSLog(@"WellList count: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] saveAllWellList:arrData]) {
            NSLog(@"downloaded 14");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:13 withObject:[NSNumber numberWithBool:YES]];
        } else{
            NSLog(@"failed 14");
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:13 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWellheadData:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 14 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:13 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWellheadData:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadWellheadData:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WellheadData param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        NSLog(@"WellheadData count: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] saveAllWellheadData:arrData]) {
            NSLog(@"downloaded 15");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:14 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:14 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadAllLeases:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 15 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:14 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadAllLeases:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

#pragma mark - leases
-(void) downloadAllLeases:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    [self getUserPermissions];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    
    NSDictionary *dicParameter = @{@"userid": userid, @"routes": arrRoutes, @"operatings": arrOperatings, @"owns": arrOwns, @"isemptypermission": isEmptyPermission};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_AllLease param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary *)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        NSLog(@"lease total count: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] saveAllLease:arrData]) {
            NSLog(@"downloaded 16");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:15 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            NSLog(@"save 16 failed");
            [arrDownloadStatus replaceObjectAtIndex:15 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadPulseProdField:YES completionHandler:nil];
        else
            completionBlock(YES);
//        [self downloadInvoices];
//        [self downloadAllRigReports];
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        NSLog(@"download 16 failed. %@", error);
        [arrDownloadStatus replaceObjectAtIndex:15 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadPulseProdField:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadPulseProdField:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_PulseProdFields param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary *)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        NSLog(@"PulseProdField count: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] savePulseProdField:arrData]) {
            NSLog(@"downloaded 17");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:16 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            NSLog(@"save 17 failed");
            [arrDownloadStatus replaceObjectAtIndex:16 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadProductions:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        NSLog(@"download 17 failed. %@", error);
        [arrDownloadStatus replaceObjectAtIndex:16 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadProductions:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void)downloadProductions:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_Productions param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary *)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        NSLog(@"tblProduction count: %d", (int)arrData.count);
        if ([[DBManager sharedInstance] saveAllProductions:arrData]) {
            NSLog(@"downloaded 18");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:17 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            NSLog(@"Save 18 failed");
            [arrDownloadStatus replaceObjectAtIndex:17 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadProductionField:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        NSLog(@"download 18 failed. %@", error);
        [arrDownloadStatus replaceObjectAtIndex:17 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadProductionField:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];

}

-(void) downloadProductionField:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_ProductionFields param:dicParameter completionHandler:^(id obj) {
        NSDictionary *dicResponse = (NSDictionary *)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        NSLog(@"ProductionField count: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] saveProductionField:arrData]) {
            NSLog(@"downloaded 19");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:18 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            NSLog(@"save 19 failed");
            [arrDownloadStatus replaceObjectAtIndex:18 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadProductionAvgs:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        NSLog(@"download 19 failed. %@", error);
        [arrDownloadStatus replaceObjectAtIndex:18 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadProductionAvgs:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadProductionAvgs:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_ProductionAvgs param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary *)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllProductionAvgs:arrData]) {
            NSLog(@"downloaded 20");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:19 withObject:[NSNumber numberWithBool:YES]];
            
        } else {
            NSLog(@"Save 20 failed");
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:19 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadProductionAvgFields:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        NSLog(@"download 20 failed. %@", error);
        [arrDownloadStatus replaceObjectAtIndex:19 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadProductionAvgFields:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadProductionAvgFields:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};

    [[WebServiceManager sharedInstance] sendPostRequest:D_ProductionAvgField param:dicParameter completionHandler:^(id obj) {

        NSDictionary *dicResponse = (NSDictionary *)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllProductionAvgFields:arrData]) {
            NSLog(@"downloaded 21");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:20 withObject:[NSNumber numberWithBool:YES]];

        } else {
            NSLog(@"Save 21 failed");
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:20 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWBDCasingTubing:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        NSLog(@"download 21 failed. %@", error);
        [arrDownloadStatus replaceObjectAtIndex:20 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWBDCasingTubing:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

#pragma mark - WBD
-(void) downloadWBDCasingTubing:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WBDCasingTubing param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveWBDCasingTubing:arrData]) {
            NSLog(@"downloaded 22");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:21 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:21 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWBDSurveys:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 22 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:21 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWBDSurveys:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadWBDSurveys:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WBDSurveys param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveWBDSurveys:arrData]) {
            NSLog(@"downloaded 23");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:22 withObject:[NSNumber numberWithBool:YES]];
            
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:22 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWBDPlugs:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 23 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:22 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWBDPlugs:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadWBDPlugs:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WBDPlugs param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveWBDPlugs:arrData]) {
            NSLog(@"downloaded 24");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:23 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:23 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWBDRods:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 24 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:23 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWBDRods:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}


-(void) downloadWBDRods:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WBDRods param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveWBDRods:arrData]) {
            NSLog(@"downloaded 25");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:24 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:24 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWBDInfo:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 25 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:24 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWBDInfo:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadWBDInfo:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WBDInfo param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveWBDInfo:arrData]) {
            NSLog(@"downloaded 26");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:25 withObject:[NSNumber numberWithBool:YES]];
            		
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:25 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWBDInfoSource:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 26 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:25 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWBDInfoSource:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadWBDInfoSource:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WBDInfoSource param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveWBDInfoSource:arrData]) {
            NSLog(@"downloaded 27");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:26 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:26 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWBDPumps:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 27 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:26 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWBDPumps:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadWBDPumps:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WBDPumps param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveWBDPumps:arrData]) {
            NSLog(@"downloaded 28");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:27 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:27 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWBDTreatments:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 28 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:27 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWBDTreatments:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}


-(void) downloadWBDTreatments:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WBDTreatments param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllWBDTreatments:arrData]) {
            NSLog(@"downloaded 29");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:28 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:28 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWBDPerfs:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 29 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:28 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWBDPerfs:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}


-(void) downloadWBDPerfs:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WBDPerfs param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllWBDPerfs:arrData]) {
            NSLog(@"downloaded 30");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:29 withObject:[NSNumber numberWithBool:YES]];
            
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:29 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadInvoices:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 30 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:29 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadInvoices:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}


#pragma mark -
-(void) downloadInvoices:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    [self getUserPermissions];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    
    NSDictionary *dicParameter = @{@"userid": userid, @"routes": arrRoutes, @"operatings": arrOperatings, @"owns": arrOwns, @"isemptypermission": isEmptyPermission};
    [[WebServiceManager sharedInstance] sendPostRequest:D_Invoices param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        
        NSLog(@"Invoice counts: %d", (int)arrData.count);
        if ([[DBManager sharedInstance] saveAllInvoicesData:arrData]) {
            NSLog(@"downloaded 31");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:30 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:30 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadSchedules:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 31 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:30 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadSchedules:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

//-(void) downloadSpecificInvoices
//{
//    [self getUserPermissions];
//    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
//    
//    NSDictionary *dicParameter = @{@"userid": userid, @"routes": arrRoutes, @"operatings": arrOperatings, @"owns": arrOwns, @"isemptypermission": isEmptyPermission};
//    [[WebServiceManager sharedInstance] sendPostRequest:D_InvoicesSpec param:dicParameter completionHandler:^(id obj) {
//        
//        NSDictionary *dicResponse = (NSDictionary*)obj;
//        NSArray *arrData = [dicResponse objectForKey:@"data"];
//        
//        NSLog(@"Invoice counts: %d", (int)arrData.count);
//        
//        if ([[DBManager sharedInstance] saveSpecificInvoicesData:arrData]) {
//            NSLog(@"downloaded 31_spec");
//            successCount += 1;
//            [self checkStatus: false];
//        } else {
//            failedCount += 1;
//            [self checkStatus: false];
//        }
//        
//        [self downloadSchedules];
//    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"download 31_spec failed. %@", error);
//        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
//        if ([response statusCode] == 401) {
//            [self showUnautherizedAlert];
//            return;
//        }
//        failedCount += 1;
//        [self checkStatus: false];
//        [self downloadSchedules];
//    }];
//}

-(void) downloadSchedules:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    [self getUserPermissions];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    
    NSDictionary *dicParameter = @{@"userid": userid, @"routes": arrRoutes, @"operatings": arrOperatings, @"owns": arrOwns, @"isemptypermission": isEmptyPermission};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_Schedules param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse objectForKey:@"data"];
        NSLog(@"Schedule count: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] saveAllSchedules:arrData])
        {
            NSLog(@"downloaded 32");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:31 withObject:[NSNumber numberWithBool:YES]];
        }
        else
        {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:31 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadListAssetLocations:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 32 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:31 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadListAssetLocations:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadListAssetLocations:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    arrRoutes = [userDefaults valueForKey:S_Routes];
    arrOperatings = [userDefaults valueForKey:S_Operatings];
    arrOwns = [userDefaults valueForKey:S_Owns];
    isEmptyPermission = [userDefaults valueForKey:S_EmptyPermission];
    NSString *userid = [userDefaults valueForKey:S_UserID];
    
    NSDictionary *dicParameter = @{@"userid": userid, @"routes": arrRoutes, @"operatings": arrOperatings, @"owns": arrOwns, @"isemptypermission": isEmptyPermission};
    [[WebServiceManager sharedInstance] sendPostRequest:D_LeasesWithPermission param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*)obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveListAssetLocations:arrData]) {
            NSLog(@"downloaded 33");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:32 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:32 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadInvoiceAccounts:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 33 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:32 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadInvoiceAccounts:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadInvoiceAccounts:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_InvoiceAccounts param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveInvoiceAccounts:arrData]) {
            NSLog(@"downloaded 34");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:33 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:33 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadAllRigReports:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 34 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:33 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadAllRigReports:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

#pragma mark -
-(void) downloadAllRigReports:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    [self getUserPermissions];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    BOOL isAll = [[NSUserDefaults standardUserDefaults] boolForKey:S_DownloadAllChron];
    NSDictionary *dicParameter = @{@"userid": userid, @"routes": arrRoutes, @"operatings": arrOperatings, @"owns": arrOwns, @"isemptypermission": isEmptyPermission, @"isNeededUrlForImage": @"1", @"isAll": [NSNumber numberWithBool:isAll]};
    [[WebServiceManager sharedInstance] sendPostRequest:D_RigReports param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        NSLog(@"Rig Reports Counts: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] saveAllRigReports:arrData]) {
            NSLog(@"downloaded 35");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:34 withObject:[NSNumber numberWithBool:YES]];
            
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:34 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadAllRigReportsRods:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 35 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:34 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadAllRigReportsRods:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadAllRigReportsRods:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_RigReportsRods param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllRigReportsRods:arrData]) {
            NSLog(@"downloaded 36");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:35 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:35 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadRodSize:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 36 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:35 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadRodSize:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadRodSize:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_RodSize param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveRodSize:arrData]) {
            NSLog(@"downloaded 37");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:36 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:36 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadRodType:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 37 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:36 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadRodType:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadRodType:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_RodType param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveRodType:arrData]) {
            NSLog(@"downloaded 38");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:37 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:37 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadRodLength:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 38 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:37 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadRodLength:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadRodLength:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_RodLength param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveRodLength:arrData]) {
            NSLog(@"downloaded 39");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:38 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:38 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadAllRigReportsPump:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 39 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:38 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadAllRigReportsPump:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

#pragma mark -
-(void) downloadAllRigReportsPump:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_RigReportsPump param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllRigReportsPump:arrData]) {
            NSLog(@"downloaded 40");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:39 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:39 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadPumpSize:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 40 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:39 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadPumpSize:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadPumpSize:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_PumpSize param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] savePumpSize:arrData]) {
            NSLog(@"downloaded 41");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:40 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:40 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadPumpType:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 41 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:40 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadPumpType:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadPumpType:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_PumpType param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] savePumpType:arrData]) {
            NSLog(@"downloaded 42");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:41 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:41 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadAllRigReportsTubing:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 42 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:41 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadAllRigReportsTubing:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}


#pragma mark -
-(void) downloadAllRigReportsTubing:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_RigReportsTubing param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllRigReportsTubing:arrData]) {
            NSLog(@"downloaded 43");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:42 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:42 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadTubingSize:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 43 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:42 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadTubingSize:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadTubingSize:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_TubingSize param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveTubingSize:arrData]) {
            NSLog(@"downloaded 44");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:43 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:43 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadTubingType:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 44 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:43 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadTubingType:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadTubingType:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_TubingType param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveTubingType:arrData]) {
            NSLog(@"downloaded 45");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:44 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:44 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadTubingLength:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 45 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:44 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadTubingLength:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

-(void) downloadTubingLength:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_TubingLength param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveTubingLength:arrData]) {
            NSLog(@"downloaded 46");
            successCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:45 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus: false];
            [arrDownloadStatus replaceObjectAtIndex:45 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadWaterPumpInfo:YES completionHandler:nil];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 46 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        
        failedCount += 1;
        [self checkStatus: false];
        [arrDownloadStatus replaceObjectAtIndex:45 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadWaterPumpInfo:YES completionHandler:nil];
        else
            completionBlock(NO);
    }];
}

#pragma mark -
-(void) downloadWaterPumpInfo:(BOOL)isNeedNext completionHandler:(void(^)(BOOL isSuccess))completionBlock
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid};
    
    [[WebServiceManager sharedInstance] sendPostRequest:D_WaterPumpInfo param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        if ([[DBManager sharedInstance] saveAllPumpInfo:arrData]) {
            NSLog(@"downloaded 47");
            successCount += 1;
            [self checkStatus:true];
            [arrDownloadStatus replaceObjectAtIndex:46 withObject:[NSNumber numberWithBool:YES]];
        } else {
            failedCount += 1;
            [self checkStatus:true];
            [arrDownloadStatus replaceObjectAtIndex:46 withObject:[NSNumber numberWithBool:NO]];
        }
        if (isNeedNext)
            [self downloadResultProc];
        else
            completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"download 47 failed. %@", error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        
        failedCount += 1;
        [self checkStatus:true];
        [arrDownloadStatus replaceObjectAtIndex:46 withObject:[NSNumber numberWithBool:NO]];
        if (isNeedNext)
            [self downloadResultProc];
        else
            completionBlock(NO);
    }];
}

-(void)downloadResultProc {
    BOOL isNeedToFailedProc = NO;
    for (int i = 0; i < APINumber; i++) {
        if (![arrDownloadStatus[i] boolValue]) {
            isNeedToFailedProc = YES;
            break;
        }
    }
    if (isNeedToFailedProc) {
        
        NSString *strMsg = @"Some data got failed to sync. Please hold the sync button to sync for the only failed data.";
        UIViewController *parentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        while (parentViewController.presentedViewController != nil){
            parentViewController = parentViewController.presentedViewController;
        }
        UIViewController *currentViewController = parentViewController;
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor darkGrayColor];
        [currentViewController.view makeToast:strMsg duration:5.0 position:CSToastPositionBottom style:style];
    }
}

-(void)syncFailedData {
    
    if (![WebServiceManager connectedToNetwork]) {
        isSyncing = NO;
        [self changedSyncStatus:SyncFailed];
        [self hideProgressBar];
        [self showDefaultAlert:@"Download Failed" withMessage:@"Connection Error: Please check your connection"];
        return;
    }
    NSLog(@"Download start for failed data");
    
    int failedIndex = -1;
    for (int i = 0; i < APINumber; i++) {
        if (![arrSecondDownloadStatus[i] boolValue]) {
            failedIndex = i;
            break;
        }
    }
    //tmp
    int countFailedData = 0;
    for (int i = 0; i < APINumber; i++) {
        if (![arrSecondDownloadStatus[i] boolValue]) {
            countFailedData++;
        }
    }
    NSLog(@"Failed count: %d", countFailedData);
    //
    switch (failedIndex) {
        case -1: {
            isSyncing = NO;
            BOOL isFail = NO;
            for (NSNumber *val in arrDownloadStatus) {
                if (![val boolValue]) {
                    isFail = YES;
                    break;
                }
            }
            if (!isFail) {
                [self changedSyncStatus:Synced];
            } else {
                NSLog(@"Failed to manual sync for only failed data");
                [self changedSyncStatus:SyncFailed];
            }
            successCount = failedCount = 0;
            break;
        }
        case 6: {
            [self downloadTanks:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 7: {
            [self downloadTankGaugeEntries:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 8: {
            [self downloadTankStrappings:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 9: {
            [self downloadRunTickets:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 10: {
            [self downloadMeters:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 11: {
            [self downloadGasMeterData:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 12: {
            [self downloadWaterMeterData:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 13: {
            [self downloadWellList:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 14: {
            [self downloadWellheadData:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 15: {
            [self downloadAllLeases:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 16: {
            [self downloadPulseProdField:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 17: {
            [self downloadProductions:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 18: {
            [self downloadProductionField:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 19: {
            [self downloadProductionAvgs:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 20: {
            [self downloadProductionAvgFields:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 21: {
            [self downloadWBDCasingTubing:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 22: {
            [self downloadWBDSurveys:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 23: {
            [self downloadWBDPlugs:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 24: {
            [self downloadWBDRods:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 25: {
            [self downloadWBDInfo:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 26: {
            [self downloadWBDInfoSource:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 27: {
            [self downloadWBDPumps:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 28: {
            [self downloadWBDTreatments:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 29: {
            [self downloadWBDPerfs:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 30: {
            [self downloadInvoices:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 31: {
            [self downloadSchedules:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 32: {
            [self downloadListAssetLocations:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 33: {
            [self downloadInvoiceAccounts:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 34: {
            [self downloadAllRigReports:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 35: {
            [self downloadAllRigReportsRods:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 36: {
            [self downloadRodSize:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 37: {
            [self downloadRodType:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 38: {
            [self downloadRodLength:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 39: {
            [self downloadAllRigReportsPump:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 40: {
            [self downloadPumpSize:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 41: {
            [self downloadPumpType:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 42: {
            [self downloadAllRigReportsTubing:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 43: {
            [self downloadTubingSize:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 44: {
            [self downloadTubingType:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 45: {
            [self downloadTubingLength:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        case 46: {
            [self downloadWaterPumpInfo:NO completionHandler:^(BOOL isSuccess) {
                [arrSecondDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:YES]];
                [arrDownloadStatus replaceObjectAtIndex:failedIndex withObject:[NSNumber numberWithBool:isSuccess]];
                [self syncFailedData];
            }];
            break;
        }
        default:
            break;
    }
}

-(void)downloadRigReportsWithWellNum:(NSString *)wellNum lease:(NSString *)lease completionHandler:(void(^)(BOOL isSuccess))completionBlock {
    [self getUserPermissions];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    NSDictionary *dicParameter = @{@"userid": userid, @"routes": arrRoutes, @"operatings": arrOperatings, @"owns": arrOwns, @"isemptypermission": isEmptyPermission, @"isNeededUrlForImage": @"1", @"wellNumber": wellNum, @"lease": lease};
    [[WebServiceManager sharedInstance] sendPostRequest:D_RigReportsWithWell param:dicParameter completionHandler:^(id obj) {
        
        NSDictionary *dicResponse = (NSDictionary*) obj;
        NSArray *arrData = [dicResponse valueForKey:@"data"];
        NSLog(@"Specific Rig Reports Counts: %d", (int)arrData.count);
        
        if ([[DBManager sharedInstance] saveAllRigReports:arrData]) {
            [arrDownloadStatus replaceObjectAtIndex:34 withObject:[NSNumber numberWithBool:YES]];
        }
        completionBlock(YES);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        if ([response statusCode] == 401) {
            [self showUnautherizedAlert];
            return;
        }
        completionBlock(NO);
    }];
}

#pragma mark - Get User Permissions

-(void) getUserPermissions
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    arrRoutes = [userDefaults valueForKey:S_Routes];
    arrOperatings = [userDefaults valueForKey:S_Operatings];
    arrOwns = [userDefaults valueForKey:S_Owns];
    isEmptyPermission = [userDefaults valueForKey:S_EmptyPermission];
}


#pragma mark - Get data when New Invoice.
-(void) getLeases
{
    NSArray *arrListAssetLocations = [[DBManager sharedInstance] getLeases];
    
    for (ListAssetLocations *listAssetLocations in arrListAssetLocations) {
//        [arrLeases addObject:listAssetLocations.propNum];
        [arrLeases addObject:listAssetLocations.grandparentPropNum];
        [arrLeaseNames addObject:listAssetLocations.codeProperty];        
    }    
}


#pragma mark - upload all data
-(void) uploadRunTickets:(NSArray *)arrData{
    [self uploadRunTickets:arrData isAll:YES];
}
-(void) uploadTankGaugeEntries:(NSArray*)arrData{
    [self uploadTankGaugeEntries:arrData isAll:YES];
}

-(void) uploadGasMeterData:(NSArray*)arrData {
    [self uploadGasMeterData:arrData isAll:YES];
}

-(void) uploadWaterMeterData:(NSArray*)arrData {
    [self uploadWaterMeterData:arrData isAll:YES];
}

-(void) uploadWellheadData:(NSArray*)arrData {
    [self uploadWellheadData:arrData isAll:YES];
}

-(void) uploadInvoiceData:(NSArray*)arrData {
    [self uploadInvoiceData:arrData isAll:YES];
}

-(void) uploadInvoiceDetailData:(NSArray*)arrData {
    [self uploadInvoiceDetailData:arrData isAll:YES];
}

-(void) uploadInvoicePersonnelData:(NSArray*)arrData {
    [self uploadInvoicePersonnelData:arrData isAll:YES];
}

-(void) uploadScheduleData:(NSArray*)arrData {
    [self uploadScheduleData:arrData isAll:YES];
}

-(void) uploadRigReports:(NSArray*)arrData {
    [self uploadRigReports:arrData isAll:YES];
}

-(void) uploadRigReportsRods:(NSArray *)arrData {
    [self uploadRigReportsRods:arrData isAll:YES];
}

-(void) uploadRigReportsPump:(NSArray *)arrData {
    [self uploadRigReportsPump:arrData isAll:YES];
}

-(void) uploadRigReportsTubing:(NSArray *)arrData {
    [self uploadRigReportsTubing:arrData isAll:YES];
}

#pragma mark - upload entries
-(void) uploadRunTickets:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicRunTickets = [[NSMutableDictionary alloc] init];
    
    
    for (int i = 0; i < arrData.count; i++) {
        RunTickets *runTicket = arrData[i];
        
        NSDictionary *dic = [self getRunTicketDictionary:runTicket];
        
        [dicRunTickets setObject:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicRunTickets forKey:@"tickets"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    NSLog(@"%@", dicParam);
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            [[WebServiceManager sharedInstance] sendPostRequest:U_RunTickets param:dicParam completionHandler:^(id obj) {
                NSLog(@"Uploaded RunTickets");
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                [[DBManager sharedInstance] uploadedRunTickets:arrData];
                if (isAll) [[DBManager sharedInstance] syncTankGaugeEntryData];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: RunTickets");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
}


-(void) uploadTankGaugeEntries:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicTankGaugeEntries = [[NSMutableDictionary alloc] init];
    
    
    for (int i = 0; i < arrData.count; i++) {
        TankGaugeEntry *tankGaugeEntry = arrData[i];
        
        NSDictionary *dic = [self getTankGaugeEntryDictionary:tankGaugeEntry];
        
        [dicTankGaugeEntries setObject:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicTankGaugeEntries forKey:@"entries"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    NSLog(@"%@", dicParam);
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            
            [[WebServiceManager sharedInstance] sendPostRequest:U_TankGaugeEntries param:dicParam completionHandler:^(id obj) {
                NSLog(@"Uploaded: TankGaugeEntries");
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                [[DBManager sharedInstance] uploadedTankGaugeEntries:arrData];
                if (isAll) [[DBManager sharedInstance] syncGasMeterData];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: TankGaugeEntries");
                isSyncing = NO;
                NSLog(@"%@", error);
                [self changedSyncStatus:UploadFailed];
                if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
    
}

-(void) uploadGasMeterData:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicGasMeterData = [[NSMutableDictionary alloc] init];
    
    
    for (int i = 0; i < arrData.count; i++) {
        GasMeterData *gasMeterData = arrData[i];
        
        NSDictionary *dic = [self getGasMeterDictionary:gasMeterData];
        
        [dicGasMeterData setObject:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicGasMeterData forKey:@"gasmeterdata"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            
            [[WebServiceManager sharedInstance] sendPostRequest:U_GasMeterData param:dicParam completionHandler:^(id obj) {
                NSLog(@"Uploaded: GasMeterData");
                [self changedSyncStatus:Synced];
                isSyncing = NO;
                
                [[DBManager sharedInstance] uploadedGasMeterData: arrData];
                
                if (isAll) {
                    [[DBManager sharedInstance] syncWaterMeterData];
                } else {
                    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
                    NSDictionary *dicParameter = @{@"userid": userid};
                    
                    [[WebServiceManager sharedInstance] sendPostRequest:D_GasMeterData param:dicParameter completionHandler:^(id obj) {
                        NSDictionary *dicResponse = (NSDictionary*)obj;
                        NSArray *arrData = [dicResponse objectForKey:@"data"];
                        [[DBManager sharedInstance] saveAllGasMeterData:arrData];
                    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                        NSLog(@"download GasMeterData failed");
                    }];
                }
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: GasMeterData");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll) {
                    [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
                }
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
}

-(void) uploadWaterMeterData:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicWaterMeterData = [[NSMutableDictionary alloc] init];
    
    
    for (int i = 0; i < arrData.count; i++) {
        WaterMeterData *waterMeterData = arrData[i];
        
        NSDictionary *dic = [self getWaterMeterDictionary:waterMeterData];
        [dicWaterMeterData setObject:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicWaterMeterData forKey:@"watermeterdata"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            [[WebServiceManager sharedInstance] sendPostRequest:U_WaterMeterData param:dicParam completionHandler:^(id obj) {
                
                NSLog(@"Uploaded: WaterMeterData");
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                
                [[DBManager sharedInstance] uploadedWaterMeterData:arrData];
                if (isAll) {
                    [[DBManager sharedInstance] syncWellheadData];
                } else {
                    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
                    NSDictionary *dicParameter = @{@"userid": userid};
                    
                    [[WebServiceManager sharedInstance] sendPostRequest:D_WaterMeterData param:dicParameter completionHandler:^(id obj) {
                        NSDictionary *dicResponse = (NSDictionary*)obj;
                        NSArray *arrData = [dicResponse objectForKey:@"data"];
                        [[DBManager sharedInstance] saveAllWaterMeterData:arrData];
                    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                        NSLog(@"download WaterMeterData failed");
                    }];
                }
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: WaterMeterData");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll)
                    [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}


-(void) uploadWellheadData:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicWaterMeterData = [[NSMutableDictionary alloc] init];
    
    
    for (int i = 0; i < arrData.count; i++) {
        WellheadData *wellheadData = arrData[i];
        
        NSDictionary *dic = [self getWellheadDictionary:wellheadData];
        [dicWaterMeterData setObject:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicWaterMeterData forKey:@"wellheaddata"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    NSLog(@"%@", dicParam);
    
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            [[WebServiceManager sharedInstance] sendPostRequest:U_WellheadData param:dicParam completionHandler:^(id obj) {
                NSLog(@"%@", obj);
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                
                [[DBManager sharedInstance] uploadedWellheadData:arrData];
                if (isAll) {
	                }
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: WellheadData");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll)
                    [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}


-(void) uploadInvoiceData:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicInvoices = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < arrData.count; i++) {
        Invoices *invoice = arrData[i];
        
        NSDictionary *dic = [self getInvoiceDictionary:invoice];
        [dicInvoices setValue:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicInvoices forKey:@"invoices"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    NSLog(@"%@", dicParam);
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            [[WebServiceManager sharedInstance] sendPostRequest:U_Invoices param:dicParam completionHandler:^(id obj) {
                NSLog(@"Uploaded: Invoices");
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                [[DBManager sharedInstance] uploadedInvoicesFromLocal:arrData];
                
                if (isAll) {
                    [[DBManager sharedInstance] syncInvoicesDetailData];
                } else {
                    // upload invoice detail
                    NSArray *arrUpdatedInvoiceDetails = [[DBManager sharedInstance] getUpdatedInvoicesDetails];
                    if (arrUpdatedInvoiceDetails && arrUpdatedInvoiceDetails.count > 0) {
                        [[AppData sharedInstance] uploadInvoiceDetailData:arrUpdatedInvoiceDetails isAll:NO];
                    } else {
                        // upload invoice detail
                        NSArray *arrUpdatedInvoiceDetails = [[DBManager sharedInstance] getUpdatedInvoicesDetails];
                        if (arrUpdatedInvoiceDetails && arrUpdatedInvoiceDetails.count > 0) {
                            [[AppData sharedInstance] uploadInvoiceDetailData:arrUpdatedInvoiceDetails isAll:NO];
                        }
                    }
                }
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: Invoices");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll)
                    [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
        
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}

-(void) uploadInvoiceDetailData:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicInvoices = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < arrData.count; i++) {
        InvoicesDetail *invoiceDetail = arrData[i];
        
        NSDictionary *dic = [self getInvoiceDetailDictionary:invoiceDetail];
        [dicInvoices setValue:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicInvoices forKey:@"invoicesDetail"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    NSLog(@"%@", dicParam);
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            
            [[WebServiceManager sharedInstance] sendPostRequest:U_InvoicesDetail param:dicParam completionHandler:^(id obj) {
                NSLog(@"Uploaded: InvoicesDetail");
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                [[DBManager sharedInstance] uploadedInvoicesDetailFromLocal:arrData];
                if (isAll) {
                    [[DBManager sharedInstance] syncInvoicesPersonnel];
                } else {
                    // upload invoice personal
                    NSArray *arrUpdatedInvoicePersonnel = [[DBManager sharedInstance] getUpdatedInvoicesPersonnel];
                    if (arrUpdatedInvoicePersonnel && arrUpdatedInvoicePersonnel.count > 0) {
                        [[AppData sharedInstance] uploadInvoicePersonnelData:arrUpdatedInvoicePersonnel isAll:NO];
                    }
                }
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: InvoicesDetail");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll)
                    [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}

-(void) uploadInvoicePersonnelData:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicInvoices = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < arrData.count; i++) {
        InvoicesPersonnel *invoicePersonnel = arrData[i];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        [dic setValue:[NSString stringWithFormat:@"%d", invoicePersonnel.invoiceID] forKey:@"invoiceID"];
        [dic setValue:invoicePersonnel.invoiceAppID forKey:@"invoiceAppID"];
        [dic setValue:[NSString stringWithFormat:@"%d", invoicePersonnel.userID] forKey:@"peopleID"];
        
        if (invoicePersonnel.deleted) {
            [dic setValue:@"1" forKey:@"deleted"];
        } else {
            [dic setValue:@"0" forKey:@"deleted"];
        }
        
        [dicInvoices setValue:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicInvoices forKey:@"invoicesPersonnel"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    NSLog(@"%@", dicParam);
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            
            [[WebServiceManager sharedInstance] sendPostRequest:U_InvoicesPersonnel param:dicParam completionHandler:^(id obj) {
                
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                [[DBManager sharedInstance] uploadedInvoicesPersonnelFromLocal:arrData];
                if (isAll)
                    [[DBManager sharedInstance] syncSchedulesData];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: InvoicesPersonnal");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll)
                    [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}


#pragma mark -
- (void) uploadScheduleData:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicSchedules = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < arrData.count; i++) {
        Schedules *schedule = arrData[i];
        
        NSDictionary *dic = [self getScheduleDictionary:schedule];
        [dicSchedules setValue:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicSchedules forKey:@"schedules"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            [[WebServiceManager sharedInstance] sendPostRequest:U_Schedules param:dicParam completionHandler:^(id obj) {
                
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                [[DBManager sharedInstance] uploadedScheduleData:arrData];
                
                if (isAll) [[DBManager sharedInstance] syncRigReports];
                
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: Schedules");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}


-(void) uploadRigReports:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicRigReports = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < arrData.count; i++) {
        RigReports *rigReports = arrData[i];
        
        NSDictionary *dic = [self getRigReportsDictionary:rigReports];
        [dicRigReports setValue:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicRigReports forKey:@"rigReports"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            [[WebServiceManager sharedInstance] sendPostRequest:U_RigReports param:dicParam completionHandler:^(id obj) {
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                
                [[DBManager sharedInstance] uploadedRigReports:arrData];
                if (isAll) [[DBManager sharedInstance] syncRigReportsRods];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: RigReports");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}

-(void) uploadRigReportsRods:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicRigReports = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < arrData.count; i++) {
        RigReportsRods *rod = arrData[i];
        
        NSDictionary *dic = [self getRigReportsRodsDictionary:rod];
        [dicRigReports setValue:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicRigReports forKey:@"rods"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    NSLog(@"%@", dicParam);
    
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            [[WebServiceManager sharedInstance] sendPostRequest:U_RigReportsRods param:dicParam completionHandler:^(id obj) {
                
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                
                [[DBManager sharedInstance] uploadedRigReportRods:arrData];
                if (isAll) [[DBManager sharedInstance] syncRigReportsPump];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: RigReportsRods");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}


-(void) uploadRigReportsPump:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicRigReportsPump = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < arrData.count; i++) {
        RigReportsPump *pump = arrData[i];
        NSDictionary *dic = [self getRigReportsPumpDictionary:pump];
        [dicRigReportsPump setValue:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicRigReportsPump forKey:@"pump"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    NSLog(@"%@", dicParam);
    
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            [[WebServiceManager sharedInstance] sendPostRequest:U_RigReportsPump param:dicParam completionHandler:^(id obj) {
                
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                [[DBManager sharedInstance] uploadedRigReportPump:arrData];
                
                if (isAll) [[DBManager sharedInstance] syncRigReportsTubing];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: RigReportsPump");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}


-(void) uploadRigReportsTubing:(NSArray *)arrData isAll:(BOOL)isAll
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicRigReportsTubing = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < arrData.count; i++) {
        RigReportsTubing *tubing = arrData[i];
        NSDictionary *dic = [self getRigReportsTubingDictionary:tubing];
        [dicRigReportsTubing setValue:dic forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    [dicParam setObject:dicRigReportsTubing forKey:@"tubing"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:S_UserID];
    [dicParam setObject:userid forKey:@"userid"];
    
    NSLog(@"%@", dicParam);
    
    if ([WebServiceManager connectedToNetwork]) {
        if (!isSyncing) {
            isSyncing = YES;
            [self changedSyncStatus:Syncing];
            [[WebServiceManager sharedInstance] sendPostRequest:U_RigReportsTubing param:dicParam completionHandler:^(id obj) {
                
                isSyncing = NO;
                [self changedSyncStatus:Synced];
                [[DBManager sharedInstance] uploadedRigReportTubing:arrData];
                if (isAll) [self downloadData:NO];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Upload Failed: RigReportsTubing");
                isSyncing = NO;
                [self changedSyncStatus:UploadFailed];
                if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
            }];
        }
    } else {
        isSyncing = NO;
        [self changedSyncStatus:UploadFailed];
        if (isAll) [self showDefaultAlert:@"Upload failed" withMessage:@"Please retry to sync."];
    }
    
}

#pragma mark - make dictionary for uploading
-(NSDictionary *)getRunTicketDictionary:(RunTickets*)runTicket {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *strEntryTime = [defaultFormatter stringFromDate:runTicket.entryTime];
    NSString *strTicketTime = [defaultFormatter stringFromDate:runTicket.ticketTime];
    
    [dic setValue:[NSNumber numberWithInt:runTicket.internalTicketID] forKey:@"internalTicketID"];
    [dic setValue:strEntryTime forKey:@"entryTime"];
    [dic setValue:strTicketTime forKey:@"ticketTime"];
    [dic setValue:runTicket.lease forKey:@"lease"];
    [dic setValue:runTicket.deviceID forKey:@"deviceID"];
    
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.tankNumber] forKey:@"tankNumber"];
    [dic setValue:runTicket.ticketNumber forKey:@"ticketNumber"];
    
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.temp1] forKey:@"temp1"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.oilFeet1] forKey:@"oilFeet1"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.oilInch1] forKey:@"oilInch1"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.oilFraction1] forKey:@"oilFraction1"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.bottomsFeet1] forKey:@"bottomsFeet1"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.bottomsInch1] forKey:@"bottomsInch1"];
    
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.temp2] forKey:@"temp2"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.oilFeet2] forKey:@"oilFeet2"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.oilInch2] forKey:@"oilInch2"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.oilFraction2] forKey:@"oilFraction2"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.bottomsFeet2] forKey:@"bottomsFeet2"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.bottomsInch2] forKey:@"bottomsInch2"];
    
    [dic setValue:runTicket.obsGrav forKey:@"obsGrav"];
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.obsTemp] forKey:@"obsTemp"];
    [dic setValue:runTicket.bsw forKey:@"bsw"];
    [dic setValue:runTicket.grossVol forKey:@"grossVol"];
    [dic setValue:runTicket.netVol forKey:@"netVol"];
    
    NSString *strTimeOn = [defaultFormatter stringFromDate:runTicket.timeOn];
    NSString *strTimeOff = [defaultFormatter stringFromDate:runTicket.timeOff];
    if (strTimeOn == nil)
        strTimeOn = @"";
    if (strTimeOff == nil)
        strTimeOff = @"";
    [dic setValue:strTimeOn forKey:@"timeOn"];
    [dic setValue:strTimeOff forKey:@"timeOff"];
    
    [dic setValue:runTicket.carrier forKey:@"carrier"];
    [dic setValue:runTicket.driver forKey:@"driver"];
    [dic setValue:runTicket.comments forKey:@"comments"];
    NSString *strTicketOption = [NSString stringWithFormat:@"%d", runTicket.ticketOption];
    [dic setValue:strTicketOption forKey:@"ticketOption"];
    
    [dic setValue:runTicket.ticketImage forKey:@"ticketImage"];
        
    [dic setValue:[NSString stringWithFormat:@"%d", runTicket.userid] forKey:@"userid"];
    
    if (runTicket.deleted) {
        [dic setValue:@"1" forKey:@"deleted"];
    } else {
        [dic setValue:@"0" forKey:@"deleted"];
    }
    
    return dic;
}

-(NSDictionary *)getTankGaugeEntryDictionary:(TankGaugeEntry*)tankGaugeEntry
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *strEntryTime = [defaultFormatter stringFromDate:tankGaugeEntry.entryTime];
    NSString *strGaugeTime = [defaultFormatter stringFromDate:tankGaugeEntry.gaugeTime];
    [dic setValue:strEntryTime forKey:@"entryTime"];
    [dic setValue:strGaugeTime forKey:@"gaugeTime"];
    [dic setValue:tankGaugeEntry.lease forKey:@"lease"];
    [dic setValue:tankGaugeEntry.deviceID forKey:@"deviceID"];
    [dic setValue:tankGaugeEntry.comments forKey:@"comment"];
    
    [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankGaugeID] forKey:@"tankGaugeID"];
    [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.userid] forKey:@"userid"];
    
    if (tankGaugeEntry.tankID1 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID1] forKey:@"tankID1"];
    if (tankGaugeEntry.tankID2 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID2] forKey:@"tankID2"];
    if (tankGaugeEntry.tankID3 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID3] forKey:@"tankID3"];
    if (tankGaugeEntry.tankID4 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID4] forKey:@"tankID4"];
    if (tankGaugeEntry.tankID5 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID5] forKey:@"tankID5"];
    if (tankGaugeEntry.tankID6 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID6] forKey:@"tankID6"];
    if (tankGaugeEntry.tankID7 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID7] forKey:@"tankID7"];
    if (tankGaugeEntry.tankID8 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID8] forKey:@"tankID8"];
    if (tankGaugeEntry.tankID9 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID9] forKey:@"tankID9"];
    if (tankGaugeEntry.tankID10 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.tankID10] forKey:@"tankID10"];
    
    if (tankGaugeEntry.oilFeet1 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet1] forKey:@"oilFeet1"];
    if (tankGaugeEntry.oilFeet2 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet2] forKey:@"oilFeet2"];
    if (tankGaugeEntry.oilFeet3 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet3] forKey:@"oilFeet3"];
    if (tankGaugeEntry.oilFeet4 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet4] forKey:@"oilFeet4"];
    if (tankGaugeEntry.oilFeet5 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet5] forKey:@"oilFeet5"];
    if (tankGaugeEntry.oilFeet6 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet6] forKey:@"oilFeet6"];
    if (tankGaugeEntry.oilFeet7 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet7] forKey:@"oilFeet7"];
    if (tankGaugeEntry.oilFeet8 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet8] forKey:@"oilFeet8"];
    if (tankGaugeEntry.oilFeet9 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet9] forKey:@"oilFeet9"];
    if (tankGaugeEntry.oilFeet10 != 0)
        [dic setValue:[NSString stringWithFormat:@"%d", tankGaugeEntry.oilFeet10] forKey:@"oilFeet10"];
    
    return dic;
}

-(NSDictionary *)getGasMeterDictionary:(GasMeterData*)gasMeterData
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *strEntryTime = [defaultFormatter stringFromDate:gasMeterData.entryTime];
    NSString *strCheckTime = [defaultFormatter stringFromDate:gasMeterData.checkTime];
    [dic setValue:strEntryTime forKey:@"entryTime"];
    [dic setValue:strCheckTime forKey:@"checkTime"];
    
    [dic setValue:[NSString stringWithFormat:@"%d", gasMeterData.dataID] forKey:@"dataID"];
    
    [dic setValue:gasMeterData.lease forKey:@"lease"];
    [dic setValue:gasMeterData.deviceID forKey:@"deviceID"];
    [dic setValue:[NSString stringWithFormat:@"%d", gasMeterData.idGasMeter] forKey:@"idGasMeter"];
    
    [dic setValue:gasMeterData.meterProblem forKey:@"meterProblem"];
    [dic setValue:gasMeterData.currentFlow forKey:@"currentFlow"];
    [dic setValue:gasMeterData.yesterdayFlow forKey:@"yesterdayFlow"];
    [dic setValue:gasMeterData.meterCumVol forKey:@"meterCumVol"];
    [dic setValue:gasMeterData.linePressure forKey:@"linePressure"];
    [dic setValue:gasMeterData.diffPressure forKey:@"diffPressure"];
    
    [dic setValue:gasMeterData.comments forKey:@"comments"];
    [dic setValue:[NSString stringWithFormat:@"%d", gasMeterData.userid] forKey:@"userid"];
    
    return dic;
}

-(NSDictionary *)getWaterMeterDictionary:(WaterMeterData*)waterMeterData
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *strEntryTime = [defaultFormatter stringFromDate:waterMeterData.entryTime];
    NSString *strCheckTime = [defaultFormatter stringFromDate:waterMeterData.checkTime];
    [dic setValue:strEntryTime forKey:@"entryTime"];
    [dic setValue:strCheckTime forKey:@"checkTime"];
    
    [dic setValue:[NSString stringWithFormat:@"%d", waterMeterData.wmdID] forKey:@"wmdID"];
    
    [dic setValue:waterMeterData.lease forKey:@"lease"];
    [dic setValue:waterMeterData.deviceID forKey:@"deviceID"];
    [dic setValue:[NSString stringWithFormat:@"%d", waterMeterData.meterNum] forKey:@"meterNum"];
    
    [dic setValue:waterMeterData.meterProblem forKey:@"meterProblem"];
    [dic setValue:waterMeterData.currentFlow forKey:@"currentFlow"];
    [dic setValue:waterMeterData.yesterdayFlow forKey:@"yesterdayFlow"];
    [dic setValue:waterMeterData.totalVolume forKey:@"totalVolume"];
    [dic setValue:waterMeterData.resetVolume forKey:@"resetVolume"];
    
    [dic setValue:waterMeterData.comments forKey:@"comments"];
    [dic setValue:[NSString stringWithFormat:@"%d", waterMeterData.userid] forKey:@"userid"];
    
    return dic;
}

-(NSDictionary *)getWellheadDictionary:(WellheadData*)wellheadData
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    [dic setValue:[NSString stringWithFormat:@"%d", wellheadData.dataID] forKey:@"dataID"];
    
    NSString *strEntryTime = [defaultFormatter stringFromDate:wellheadData.entryTime];
    NSString *strCheckTime = [defaultFormatter stringFromDate:wellheadData.checkTime];
    [dic setValue:strEntryTime forKey:@"entryTime"];
    [dic setValue:strCheckTime forKey:@"checkTime"];
    [dic setValue:wellheadData.lease forKey:@"lease"];
    [dic setValue:wellheadData.deviceID forKey:@"deviceID"];
    [dic setValue:wellheadData.wellNumber forKey:@"wellNumber"];
    
    [dic setValue:wellheadData.wellProblem forKey:@"wellProblem"];
    [dic setValue:wellheadData.prodType forKey:@"prodType"];
    [dic setValue:wellheadData.choke forKey:@"choke"];
    [dic setValue:wellheadData.pumpSize forKey:@"pumpSize"];
    [dic setValue:wellheadData.spm forKey:@"spm"];
    [dic setValue:wellheadData.strokeSize forKey:@"strokeSize"];
    [dic setValue:wellheadData.timeOn forKey:@"timeOn"];
    [dic setValue:wellheadData.timeOff forKey:@"timeOff"];
    [dic setValue:wellheadData.casingPressure forKey:@"casingPressure"];
    [dic setValue:wellheadData.tubingPressure forKey:@"tubingPressure"];
    [dic setValue:wellheadData.bradenheadPressure forKey:@"bradenheadPressure"];
    
    [dic setValue:wellheadData.waterCut forKey:@"waterCut"];
    [dic setValue:wellheadData.emulsionCut forKey:@"emulsionCut"];
    [dic setValue:wellheadData.oilCut forKey:@"oilCut"];
    
    [dic setValue:wellheadData.pound forKey:@"pound"];
    if (wellheadData.statusArrival)
        [dic setValue:@"1" forKey:@"statusArrival"];
    else
        [dic setValue:@"0" forKey:@"statusArrival"];
    
    if (wellheadData.statusDepart)
        [dic setValue:@"1" forKey:@"statusDepart"];
    else
        [dic setValue:@"0" forKey:@"statusDepart"];
    
    [dic setValue:wellheadData.espHz forKey:@"espHz"];
    [dic setValue:wellheadData.espAmp forKey:@"espAmp"];
    
    [dic setValue:wellheadData.comments forKey:@"comments"];
    [dic setValue:[NSString stringWithFormat:@"%d", wellheadData.userid] forKey:@"userid"];
    
    return dic;
}

-(NSDictionary *)getInvoiceDictionary:(Invoices*)invoice
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:[NSString stringWithFormat:@"%d", invoice.invoiceID] forKey:@"invoiceID"];
    [dic setValue:invoice.invoiceAppID forKey:@"invoiceAppID"];
    [dic setValue:[self getStringFromDate:invoice.invoiceDate] forKey:@"invoiceDate"];
    [dic setValue:invoice.lease forKey:@"lease"];
    [dic setValue:invoice.wellNumber forKey:@"wellNumber"];
    [dic setValue:invoice.deviceID forKey:@"deviceID"];
    [dic setValue:[NSString stringWithFormat:@"%d", invoice.userid] forKey:@"userid"];
    [dic setValue:invoice.company forKey:@"company"];
    [dic setValue:invoice.comments forKey:@"comments"];
    [dic setValue:invoice.tubingComments forKey:@"tubingComments"];
    [dic setValue:invoice.rodComments forKey:@"rodComments"];
    [dic setValue:invoice.dailyCost forKey:@"dailyCost"];
    [dic setValue:invoice.totalCost forKey:@"totalCost"];
    [dic setValue:invoice.invoiceImages forKey:@"invoiceImages"];
    
    if (invoice.approval0)
        [dic setValue:@"1" forKey:@"approval0"];
    else
        [dic setValue:@"0" forKey:@"approval0"];
    
    if (invoice.approval1)
        [dic setValue:@"1" forKey:@"approval1"];
    else
        [dic setValue:@"0" forKey:@"approval1"];
    
    
    if (invoice.approval2)
        [dic setValue:@"1" forKey:@"approval2"];
    else
        [dic setValue:@"0" forKey:@"approval2"];
    
    
    if (invoice.outsideBill)
        [dic setValue:@"1" forKey:@"outsideBill"];
    else
        [dic setValue:@"0" forKey:@"outsideBill"];
    
    if (invoice.noBill)
        [dic setValue:@"1" forKey:@"noBill"];
    else
        [dic setValue:@"0" forKey:@"noBill"];
    
    
    if (invoice.approvalDt0) {
        [dic setValue:[self getStringFromDate:invoice.approvalDt0] forKey:@"approvalDt0"];
    }
    
    if (invoice.approvalDt1) {
        [dic setValue:[self getStringFromDate:invoice.approvalDt1] forKey:@"approvalDt1"];
    }
    
    if (invoice.approvalDt2) {
        [dic setValue:[self getStringFromDate:invoice.approvalDt2] forKey:@"approvalDt2"];
    }
    
    if (invoice.outsideBillDt) {
        [dic setValue:[self getStringFromDate:invoice.outsideBillDt] forKey:@"outsideBillDt"];
    }
    
    if (invoice.noBillDt) {
        [dic setValue:[self getStringFromDate:invoice.noBillDt] forKey:@"noBillDt"];
    }
    
    [dic setValue:invoice.app0Emp forKey:@"app0Emp"];
    [dic setValue:invoice.app1Emp forKey:@"app1Emp"];
    [dic setValue:invoice.app2Emp forKey:@"app2Emp"];
    [dic setValue:invoice.outsideBillEmp forKey:@"outsideBillEmp"];
    [dic setValue:invoice.noBillEmp forKey:@"noBillEmp"];
    
    if (invoice.deleted) {
        [dic setValue:@"1" forKey:@"deleted"];
    } else {
        [dic setValue:@"0" forKey:@"deleted"];
    }
    
    return dic;
}

-(NSDictionary *)getInvoiceDetailDictionary:(InvoicesDetail*)invoiceDetail
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:[NSString stringWithFormat:@"%d", invoiceDetail.invoiceID] forKey:@"invoiceID"];
    [dic setValue:invoiceDetail.invoiceAppID forKey:@"invoiceAppID"];
    
    [dic setValue:[NSString stringWithFormat:@"%d", invoiceDetail.account] forKey:@"account"];
    [dic setValue:[NSString stringWithFormat:@"%d", invoiceDetail.accountSub] forKey:@"accountSub"];
    [dic setValue:invoiceDetail.accountTime forKey:@"accountTime"];
    [dic setValue:invoiceDetail.accountUnit forKey:@"accountUnit"];
    
    
    if (invoiceDetail.deleted) {
        [dic setValue:@"1" forKey:@"deleted"];
    } else {
        [dic setValue:@"0" forKey:@"deleted"];
    }
    
    return dic;
}

-(NSDictionary *)getScheduleDictionary:(Schedules*)schedule
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:schedule.lease forKey:@"lease"];
    [dic setValue:schedule.wellNumber forKey:@"wellNumber"];
    [dic setValue:schedule.scheduleType forKey:@"scheduleType"];
    [dic setValue:[self getStringFromDate:schedule.initialPlanStartDt] forKey:@"initPlanStartDt"];
    [dic setValue:[self getStringFromDate:schedule.updatedPlanStartDt] forKey:@"updatedPlanStartDt"];
    [dic setValue:[NSString stringWithFormat:@"%d", schedule.entryUserID] forKey:@"entryUserID"];
    NSString *strUpdatedPlanUserID = schedule.updatedPlanUserID == 0 ? nil : [NSString stringWithFormat:@"%d", schedule.updatedPlanUserID];
    [dic setValue:strUpdatedPlanUserID forKey:@"updatedPlanUserID"];
    [dic setValue:[self getStringFromDate:schedule.actualStartDt] forKey:@"actualStartDt"];
    [dic setValue:[self getStringFromDate:schedule.actualEndDt] forKey:@"actualEndDt"];
    
    NSString *strActStartUserID = schedule.actStartUserID == 0 ? nil : [NSString stringWithFormat:@"%d", schedule.actStartUserID];
    [dic setValue:strActStartUserID forKey:@"actStartUserID"];
    NSString *strActEndUserID = schedule.actEndUserID == 0 ? nil : [NSString stringWithFormat:@"%d", schedule.actEndUserID];
    [dic setValue:strActEndUserID forKey:@"actEndUserID"];
    
    [dic setValue:schedule.engrComments forKey:@"engrComments"];
    [dic setValue:schedule.acctComments forKey:@"acctComments"];
    [dic setValue:schedule.fieldComments forKey:@"fieldComments"];
    
    return dic;
}

-(NSDictionary *)getRigReportsDictionary:(RigReports*)rigReports
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
    [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    [dic setValue:rigReports.lease forKey:@"lease"];
    [dic setValue:rigReports.wellNum forKey:@"wellNumber"];
    [dic setValue:rigReports.company forKey:@"company"];
    [dic setValue:[defaultFormatter stringFromDate:rigReports.reportDate] forKey:@"reportDate"];
    [dic setValue:[NSString stringWithFormat:@"%d", rigReports.entryUser] forKey:@"entryUser"];
    [dic setValue:[defaultFormatter stringFromDate:rigReports.entryDate] forKey:@"entryDate"];
    [dic setValue:rigReports.reportAppID forKey:@"reportAppID"];
    [dic setValue:rigReports.comments forKey:@"comments"];
    [dic setValue:rigReports.dailyCost forKey:@"dailyCost"];
    [dic setValue:rigReports.totalCost forKey:@"totalCost"];
    [dic setValue:rigReports.tubing forKey:@"tubing"];
    [dic setValue:rigReports.rods forKey:@"rods"];
    [dic setValue:rigReports.rigImages forKey:@"rigImage"];
    
    
    return dic;
}

-(NSDictionary *)getRigReportsRodsDictionary:(RigReportsRods*)rod
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:[NSString stringWithFormat:@"%d", rod.reportID] forKey:@"reportID"];
    [dic setValue:rod.rodSize forKey:@"rodSize"];
    [dic setValue:rod.rodType forKey:@"rodType"];
    [dic setValue:rod.rodLength forKey:@"rodLength"];
    [dic setValue:[NSString stringWithFormat:@"%d", rod.rodCount] forKey:@"rodCount"];
    [dic setValue:rod.rodFootage forKey:@"rodFootage"];
    [dic setValue:[NSString stringWithFormat:@"%d", rod.rodOrder] forKey:@"rodOrder"];
    [dic setValue:rod.reportAppID forKey:@"reportAppID"];
    [dic setValue:[NSString stringWithFormat:@"%d", rod.inOut] forKey:@"inOut"];
    
    return dic;
}

-(NSDictionary *)getRigReportsPumpDictionary:(RigReportsPump*)pump
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:pump.pumpSize forKey:@"pumpSize"];
    [dic setValue:pump.pumpType forKey:@"pumpType"];
    [dic setValue:pump.pumpLength forKey:@"pumpLength"];
    [dic setValue:[NSString stringWithFormat:@"%d", pump.pumpOrder] forKey:@"pumpOrder"];
    [dic setValue:pump.reportAppID forKey:@"reportAppID"];
    [dic setValue:[NSString stringWithFormat:@"%d", pump.inOut] forKey:@"inOut"];
    
    return dic;
}

-(NSDictionary *)getRigReportsTubingDictionary:(RigReportsTubing*)tubing
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:tubing.tubingSize forKey:@"tubingSize"];
    [dic setValue:tubing.tubingType forKey:@"tubingType"];
    [dic setValue:tubing.tubingLength forKey:@"tubingLength"];
    [dic setValue:[NSString stringWithFormat:@"%d", tubing.tubingCount] forKey:@"tubingCount"];
    [dic setValue:tubing.tubingFootage forKey:@"tubingFootage"];
    [dic setValue:[NSString stringWithFormat:@"%d", tubing.tubingOrder] forKey:@"tubingOrder"];
    [dic setValue:tubing.reportAppID forKey:@"reportAppID"];
    [dic setValue:[NSString stringWithFormat:@"%d", tubing.inOut] forKey:@"inOut"];
    
    return dic;
}

#pragma mark -
-(NSString*) getStringFromDate:(NSDate*)date
{
    NSString *strDate = @"";
    
    if (date != nil) {
        NSDateFormatter *defaultFormatter = [[NSDateFormatter alloc] init];
        [defaultFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        
        strDate = [defaultFormatter stringFromDate:date];
    }
    
    return strDate;
}

@end
