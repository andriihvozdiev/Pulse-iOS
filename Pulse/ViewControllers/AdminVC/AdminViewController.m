#import "AdminViewController.h"
#import "MainTabbarViewController.h"
#import "ChangePasswordViewController.h"
#import "MyProfileVC.h"
#import "HapticHelper.h"

#import "ActionSheetStringPicker.h"
#import "AppDelegate.h"

@interface AdminViewController ()
{
    NSArray *arrSectionTitles;
    NSArray *arrTitles;
}
@end

@implementation AdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    
    arrSectionTitles = @[@"Account Settings", @"App Settings"];
    arrTitles = @[@[@"Profile Settings", @"Change Password", @"Log out"], @[@"Days to Sync", @"Sync Interval", @"Download all Well Chrons", @"Review APP"]];
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppData sharedInstance].changedStatusDelegate = self;
    [self showSyncStatus];
}

#pragma mark -
-(void) showSyncStatus
{
    [self.redStatusView setBackgroundColor:[UIColor lightGrayColor]];
    [self.yellowStatusView setBackgroundColor:[UIColor lightGrayColor]];
    [self.blueStatusView setBackgroundColor:[UIColor lightGrayColor]];
    [self.greenStatusView setBackgroundColor:[UIColor lightGrayColor]];
    
    switch ([AppData sharedInstance].syncStatus) {
        case SyncFailed:
            [self.redStatusView setBackgroundColor:[UIColor redColor]];
            break;
        case UploadFailed:
            [self.yellowStatusView setBackgroundColor:[UIColor yellowColor]];
            break;
        case Syncing:
            [self.blueStatusView setBackgroundColor:[UIColor blueColor]];
            break;
        case Synced:
            [self.greenStatusView setBackgroundColor:[UIColor greenColor]];
            break;
        default:
            break;
    }
}

#pragma mark - ChangedStatusDelegate
-(void)changedSyncStatus
{
    [self showSyncStatus];
}


#pragma mark - tableview datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrSectionTitles.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:32/255.0f green:36/255.0 blue:63/255.0 alpha:1.0f];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = [arrSectionTitles objectAtIndex:section];
    lblTitle.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    lblTitle.textColor = [UIColor whiteColor];
    
    [sectionHeaderView addSubview:lblTitle];
    
    [sectionHeaderView.layer setMasksToBounds:NO];
    sectionHeaderView.layer.shadowColor = [UIColor blackColor].CGColor;
    sectionHeaderView.layer.shadowOffset = CGSizeMake(1, 2);
    sectionHeaderView.layer.shadowRadius = 3.0f;
    sectionHeaderView.layer.shadowOpacity = 0.3f;
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrTitles[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdminCell"];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    cell.backgroundColor = [UIColor clearColor];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 250, 25)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = [[arrTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    lblTitle.font = lblTitle.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    lblTitle.textColor =  [UIColor whiteColor];
    
    [cell.contentView addSubview:lblTitle];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (section == 1) {
        switch (row) {
            case 0:
            {
                NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
                lblTitle.text = [NSString stringWithFormat:@"Days to Sync: (%@ days)", daysToSync];
                break;
            }
            case 1: // Sync Interval
            {
                NSString *interval = [[NSUserDefaults standardUserDefaults] valueForKey:S_SyncInterval];
                if (!interval) {
                    lblTitle.text = @"Sync Interval: ( Never )";
                } else {
                    int minutes = [interval intValue];
                    if (minutes < 60) {
                        lblTitle.text = [NSString stringWithFormat:@"Sync Interval: (%d minutes)", minutes];
                    } else {
                        lblTitle.text = [NSString stringWithFormat:@"Sync Interval: (%d hours)", minutes / 60];
                    }
                    
                }
                break;
            }
            case 2:
            {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:S_DownloadAllChron]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            default:
                break;
        }        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            MyProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 1) {
            ChangePasswordViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
        }
        
        if (indexPath.row == 2) { // Log out
            [self logout];
        }
        
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0: // Days to Sync
                [self setNumberOfDaysToSync];
                break;
            case 1: // Sync Settings
                [self onSyncSetting];
                break;
            case 2:
            {
                NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                if (cell.accessoryType == UITableViewCellAccessoryNone) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    [userDefault setBool:YES forKey:S_DownloadAllChron];
                } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    [userDefault setBool:NO forKey:S_DownloadAllChron];
                }
                [userDefault synchronize];
                break;
            }
            case 3: // Review App
                
                break;
            default:
                break;
        }
    }
}

-(void) logout
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
        [[AppData sharedInstance] stopAutoSyncing];
        
        [[AppData sharedInstance] initialize];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *navVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"InitNavVC"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:navVC];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:yesAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void) setNumberOfDaysToSync {
    NSArray *arrInterval = @[@"7", @"15", @"30", @"45", @"60", @"90", @"180", @"365"];
    NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
    NSInteger settedIndex = 0;
    if (daysToSync) {
        settedIndex = [arrInterval indexOfObject:daysToSync];
    }
    
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Number of Days to Sync" rows:arrInterval initialSelection:settedIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
                                             {
                                                [[NSUserDefaults standardUserDefaults] setValue:arrInterval[selectedIndex] forKey:S_DaysToSync];
                                                [[WebServiceManager sharedInstance] setDaysToSync];
                                                [self.tableView reloadData];
                                             } cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 
                                             } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

-(void) onSyncSetting
{
    NSArray *arrInterval = @[@"Never", @"10", @"15", @"20", @"25", @"30", @"60", @"120", @"180", @"360"];
    NSArray *arrIntervalString = @[@"Never", @"10 minutes", @"15 minutes", @"20 minutes", @"25 minutes", @"30 minutes", @"1 hour", @"2 hours", @"3 hours", @"6 hours"];
    
    NSString *strInterval = [[NSUserDefaults standardUserDefaults] valueForKey:S_SyncInterval];
    NSInteger settedIndex = 0;
    if (strInterval) {
        settedIndex = [arrInterval indexOfObject:strInterval];
    }
    
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Sync Interval" rows:arrIntervalString initialSelection:settedIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
        {
            if (selectedIndex != 0) {
                [[NSUserDefaults standardUserDefaults] setValue:arrInterval[selectedIndex] forKey:S_SyncInterval];
                [[AppData sharedInstance] startAutoSyncing];
            } else {
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:S_SyncInterval];
                [[AppData sharedInstance] stopAutoSyncing];
            }
            [self.tableView reloadData];
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 
        } origin:self.tableView];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

#pragma mark - button events

- (IBAction)onStoplight:(id)sender {    
    [[AppData sharedInstance] mannualSync];
}

- (IBAction)onSyncForFailedData:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [HapticHelper generateFeedback:FeedbackType_Impact_Heavy];
        [[AppData sharedInstance] doSyncFailedData];
    }
}

@end
