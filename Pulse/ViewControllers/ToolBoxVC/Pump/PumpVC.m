#import "PumpVC.h"
#import "PumpSizingContentCell.h"
#import "ActionSheetStringPicker.h"

#import "PumpGraphVC.h"

@interface PumpVC ()
{
    NSArray *arrPumpInfoTitles;
    NSMutableArray *arrBrand;
    NSMutableArray *arrModel;
    NSMutableArray *arrModelIndex;
}
@end

@implementation PumpVC
@synthesize arrWaterPumpInfo;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    arrPumpInfoTitles = @[@"Model", @"Pump Brand", @"Pump Type", @"Plunger Action", @"Pump Title", @"Minimum Plunger Diameter", @"Maximum Plunger Diameter", @"Stroke", @"Maximum Working Pressure", @"Max GPM", @"Max BPD", @"Max BHP", @"RPM @ Rated BPH", @"Rated Plunger Load (lbs)", @"Fluid End", @"Crankshaft Extension Diameter", @"Crankshaft Extension Length", @"Keyway Width", @"Keyway Depth", @"Maximum Sheave Diameter", @"Crankcase Oil Capacity"];

    arrWaterPumpInfo = [[DBManager sharedInstance] getAllPumpInfo];
    
    arrBrand = [[NSMutableArray alloc] init];
    arrModel = [[NSMutableArray alloc] init];
    arrModelIndex = [[NSMutableArray alloc] init];
    
    for (WaterPumpInfo *waterPumpInfo in arrWaterPumpInfo) {
        if (![self isExistingBrand:waterPumpInfo.brand]) {
            [arrBrand addObject:waterPumpInfo.brand];
            
            arrBrand = [[arrBrand sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        }
    }
    
    [AppData sharedInstance].selectedWaterMeterPumpInfo = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(BOOL) isExistingBrand:(NSString*)newBrand
{
    for (NSString *brand in arrBrand) {
        if ([brand isEqual:newBrand]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrPumpInfoTitles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PumpSizingContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PumpSizingContentCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    cell.lblTitle.text = arrPumpInfoTitles[row];
    cell.lblContent.text = @"";
    
    if ([AppData sharedInstance].selectedWaterMeterPumpInfo)
    {
        WaterPumpInfo *selectedWaterMeterPumpInfo = [AppData sharedInstance].selectedWaterMeterPumpInfo;
        
        switch (row) {
            case 0:
            {
                NSString *strModel = selectedWaterMeterPumpInfo.oldName;
                if (selectedWaterMeterPumpInfo.newName) {
                    strModel = [NSString stringWithFormat:@"%@ / %@", strModel, selectedWaterMeterPumpInfo.newName];
                }
                cell.lblContent.text = strModel;
            }
                break;
            case 1:
                cell.lblContent.text = selectedWaterMeterPumpInfo.brand;
                break;
            case 2:
                cell.lblContent.text = selectedWaterMeterPumpInfo.pumpType;
                break;
            case 3:
                cell.lblContent.text = selectedWaterMeterPumpInfo.plungerAction;
                break;
            case 4:
                cell.lblContent.text = selectedWaterMeterPumpInfo.pumpTitle;
                break;
            case 5:
                cell.lblContent.text = selectedWaterMeterPumpInfo.minPlungerD;
                break;
            case 6:
                cell.lblContent.text = selectedWaterMeterPumpInfo.maxPlungerD;
                break;
            case 7:
                cell.lblContent.text = selectedWaterMeterPumpInfo.stroke;
                break;
            case 8:
                cell.lblContent.text = [NSString stringWithFormat:@"%d", selectedWaterMeterPumpInfo.maxPressure];
                break;
            case 9: // Max GPM
                cell.lblContent.text = [NSString stringWithFormat:@"%d", selectedWaterMeterPumpInfo.maxGPM];
                break;
            case 10: // Max BPD
                cell.lblContent.text = [NSString stringWithFormat:@"%d", selectedWaterMeterPumpInfo.maxBPD];
                break;
            case 11: // Max BHP
                cell.lblContent.text = selectedWaterMeterPumpInfo.maxBHP;
                break;
            case 12: // RPM @ Rated BHP
                cell.lblContent.text = [NSString stringWithFormat:@"%d", selectedWaterMeterPumpInfo.rpMatBHP];
                break;
            case 13:
                cell.lblContent.text = [NSString stringWithFormat:@"%d", selectedWaterMeterPumpInfo.plungerLoad];
                break;
            case 14:
                cell.lblContent.text = selectedWaterMeterPumpInfo.fluidEnd;
                break;
            case 15:
                cell.lblContent.text = selectedWaterMeterPumpInfo.crankExtD;
                break;
            case 16:
                cell.lblContent.text = selectedWaterMeterPumpInfo.crankExtL;
                break;
            case 17:
                cell.lblContent.text = selectedWaterMeterPumpInfo.keywayWidth;
                break;
            case 18:
                cell.lblContent.text = selectedWaterMeterPumpInfo.keywayDepth;
                break;
            case 19:
                cell.lblContent.text = selectedWaterMeterPumpInfo.maxSheaveD;
                break;
            case 20:
                cell.lblContent.text = selectedWaterMeterPumpInfo.crankcaseOilCap;
                break;
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PumpSizingHeaderCell"];
    
    return cell.contentView;
}


#pragma mark - button events

- (IBAction)onBrand:(id)sender {
    
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Brand" rows:arrBrand initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        if (![self.lblBrand.text isEqual:arrBrand[selectedIndex]])
        {
            self.lblBrand.text = arrBrand[selectedIndex];
            [self.lblBrand setTextColor:[UIColor whiteColor]];
            
            self.lblModel.text = @"Model";
            [self.lblModel setTextColor:[UIColor lightGrayColor]];
            
            [self getModelArray];
            
            [AppData sharedInstance].selectedWaterMeterPumpInfo = nil;
            [self.tableView reloadData];
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.lblBrand];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}

-(void) getModelArray
{
    [arrModel removeAllObjects];
    [arrModelIndex removeAllObjects];
    
    for (int i = 0; i < arrWaterPumpInfo.count; i++)
    {
        WaterPumpInfo *waterPumpInfo = arrWaterPumpInfo[i];
        if ([waterPumpInfo.brand isEqual:self.lblBrand.text])
        {
            [arrModel addObject:waterPumpInfo.oldName];
            [arrModelIndex addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
}


- (IBAction)onModel:(id)sender {
    if (arrModel.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Select a Brand" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    ActionSheetStringPicker *stringPicker = [ActionSheetStringPicker showPickerWithTitle:@"Model" rows:arrModel initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        self.lblModel.text = arrModel[selectedIndex];
        [self.lblModel setTextColor:[UIColor whiteColor]];
        
        [AppData sharedInstance].selectedWaterMeterPumpInfo = arrWaterPumpInfo[[arrModelIndex[selectedIndex] intValue]];
        [self.tableView reloadData];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.lblModel];
    
    [stringPicker.toolbar setBarTintColor:[UIColor colorWithRed:44/255.0f green:59/255.0f blue:99/255.0f alpha:1.0f]];
    [stringPicker.toolbar setTintColor:[UIColor whiteColor]];
    
    [stringPicker setPickerBackgroundColor:[UIColor colorWithRed:32/255.0f green:36/255.0f blue:63/255.0f alpha:0.95f]];
    [stringPicker setTextColor:[UIColor whiteColor]];
    stringPicker.toolbarBackgroundColor = [UIColor whiteColor];
}


@end
