#import "CompletionVC.h"
#import "PerforationCompletionCell.h"
#import "TreatmentsCompletionCell.h"


@interface CompletionVC ()

@end

@implementation CompletionVC
@synthesize arrPerforations;
@synthesize arrTreatments;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrPerforations = [[NSArray alloc] init];
    arrTreatments = [[NSArray alloc] init];
    
    self.treatmentsTableview.rowHeight = UITableViewAutomaticDimension;
    self.treatmentsTableview.estimatedRowHeight = 40;
    
    
    [self.viewPerforationHeader.layer setMasksToBounds:NO];
    self.viewPerforationHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewPerforationHeader.layer.shadowOffset = CGSizeMake(1, 1);
    self.viewPerforationHeader.layer.shadowRadius = 3.0f;
    self.viewPerforationHeader.layer.shadowOpacity = 0.3f;
    
    [self.viewTreatmentsHeader.layer setMasksToBounds:NO];
    self.viewTreatmentsHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewTreatmentsHeader.layer.shadowOffset = CGSizeMake(1, 1);
    self.viewTreatmentsHeader.layer.shadowRadius = 3.0f;
    self.viewTreatmentsHeader.layer.shadowOpacity = 0.3f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

-(void) reloadData
{
    NSString *lease = self.welllist.grandparentPropNum;
    NSString *wellNumber = self.welllist.wellNumber;
    
    arrTreatments = [[DBManager sharedInstance] getWBDTreatments:lease wellNum:wellNumber];
    arrPerforations = [[DBManager sharedInstance] getWBDPerfs:lease wellNum:wellNumber];
    
    [self.treatmentsTableview reloadData];
    [self.perforationTableview reloadData];
}


#pragma mark - tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    
    if (tableView == self.perforationTableview) {
        number = arrPerforations.count;
    } else if (tableView == self.treatmentsTableview) {
        number = arrTreatments.count;
    }
    
    return number;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    if (tableView == self.perforationTableview) {
        PerforationCompletionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PerforationCompletionCell" forIndexPath:indexPath];
        
        WBDPerfs *perf = arrPerforations[row];
        
        cell.lblDepth.text = [NSString stringWithFormat:@"%d'-%d'", perf.perfZoneStart, perf.perfZoneEnd];
        cell.lblDescription.text = perf.perfDesc;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy"];
        cell.lblDate.text = [df stringFromDate:perf.perfDate];
        cell.lblCurrent.text = perf.wellPerf ? @"Open" : @"Closed";
        
        return cell;
        
    } else if (tableView == self.treatmentsTableview) {
        TreatmentsCompletionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TreatmentsCompletionCell" forIndexPath:indexPath];
        
        WBDTreatments *treatment = arrTreatments[row];
        
        
        NSString *treatmentDate = @"(No Date)";
        NSString *treatmentDesc = @"(No Description)";
        
        if (treatment.treatmentDate) {
            treatmentDate = treatment.treatmentDate;
        }
        
        if (treatment.treatmentDesc) {
            treatmentDesc = treatment.treatmentDesc;
        }
        
        cell.lblTitle.text = [NSString stringWithFormat:@"%d. %@ %@", (int)row+1, treatmentDate, treatmentDesc];
        cell.lblNotes.text = treatment.treatmentNotes == nil ? @"" : treatment.treatmentNotes;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    if (tableView == self.perforationTableview) {
        height = 30;
    }
    
    return height;
}


#pragma mark - button events

- (IBAction)onPerforationHeader:(id)sender {
    
    if (self.perforationContentHeight.constant > 0) {
        self.perforationContentHeight.constant = 0.0f;
        self.imgPerforationDropdown.image = [UIImage imageNamed:@"dropdown_icon"];
    } else {
        self.perforationContentHeight.constant = 200.0f;
        self.imgPerforationDropdown.image = [UIImage imageNamed:@"dropup_icon"];
    }
    [self.view layoutIfNeeded];
}

- (IBAction)onTreatmentsHeader:(id)sender{
    if (self.treatmentsTableview.isHidden){
        [self.treatmentsTableview setHidden:NO];
        self.imgTreatmentsDropdown.image = [UIImage imageNamed:@"dropup_icon"];
    } else {
        [self.treatmentsTableview setHidden:YES];
        self.imgTreatmentsDropdown.image = [UIImage imageNamed:@"dropdown_icon"];
    }
}

@end
