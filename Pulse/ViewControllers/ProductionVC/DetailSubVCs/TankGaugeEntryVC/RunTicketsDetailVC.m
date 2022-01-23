#import "RunTicketsDetailVC.h"
#import "AddRunTicketsVC.h"
#import "BFRImageViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "HapticHelper.h"

@interface RunTicketsDetailVC ()

@end

@implementation RunTicketsDetailVC
@synthesize ticket;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.redStatusView.layer.cornerRadius = 4;
    self.yellowStatusView.layer.cornerRadius = 4;
    self.blueStatusView.layer.cornerRadius = 4;
    self.greenStatusView.layer.cornerRadius = 4;
    
    self.btnEditRunTicket.layer.cornerRadius = 5;
    self.btnDeleteRunTicket.layer.cornerRadius = 5;
    
    [self.imgTicket.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.imgTicket.layer.borderWidth = 1.0f;
    self.imgTicket.layer.cornerRadius = 3.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showSyncStatus];
    [AppData sharedInstance].changedStatusDelegate = self;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    self.lblLease.text =[[DBManager sharedInstance] getLeaseNameFromLease:self.ticket.lease];
    self.lblTankNumber.text = self.tank.rrc;
    self.lblTicketNumber.text = self.ticket.ticketNumber;
    self.lblDate.text = [df stringFromDate:self.ticket.ticketTime];
    
    if (self.ticket.ticketImage) {
        
        if ([ticket.ticketImage rangeOfString:@"runticketimageurl"].location == NSNotFound) {
            NSData *imageData = [[NSData alloc]initWithBase64EncodedString:self.ticket.ticketImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
            if (imageData) {
                self.imgTicket.image = [UIImage imageWithData:imageData];
                [self.lblNoImageForTicket setHidden:YES];
            } else {
                [self.lblNoImageForTicket setHidden:NO];
            }
        } else {
            [self.lblNoImageForTicket setHidden:YES];
            NSString *url_str = [NSString stringWithFormat:@"%@%@%@", BASE_URL, ASSETS_BASE_URL, ticket.ticketImage];
            [self.imgTicket setImageWithURL:[NSURL URLWithString:url_str] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        }
    }
    
    [self initViews];
}

-(void) initViews
{
    if (ticket.temp1 == 0) {
        self.lblTemperature1.text = @"-";
    } else {
        self.lblTemperature1.text = [NSString stringWithFormat:@"%d", ticket.temp1];
    }
    if (ticket.oilFeet1 == 0) {
        self.lblOilFeet1.text = @"-";
    } else {
        self.lblOilFeet1.text = [NSString stringWithFormat:@"%d", ticket.oilFeet1];
    }
    if (ticket.oilInch1 == 0) {
        self.lblOilInches1.text = @"-";
    } else {
        self.lblOilInches1.text = [NSString stringWithFormat:@"%d",     ticket.oilInch1];
    }
    if (ticket.oilFraction1 == 0) {
        self.lblOil1.text = @"-";
    } else {
        self.lblOil1.text = [NSString stringWithFormat:@"%d", ticket.oilFraction1];
    }
    if (ticket.bottomsFeet1 == 0) {
        self.lblBottomsFeet1.text = @"-";
    } else {
        self.lblBottomsFeet1.text = [NSString stringWithFormat:@"%d", ticket.bottomsFeet1];
    }
    if (ticket.bottomsInch1 == 0) {
        self.lblBottomsInches1.text = @"-";
    } else {
        self.lblBottomsInches1.text = [NSString stringWithFormat:@"%d", ticket.bottomsInch1];
    }
    if (ticket.temp2 == 0) {
        self.lblTemperature2.text = @"-";
    } else {
        self.lblTemperature2.text = [NSString stringWithFormat:@"%d", ticket.temp2];
    }
    if (ticket.oilFeet2 == 0) {
        self.lblOilFeet2.text = @"-";
    } else {
        self.lblOilFeet2.text = [NSString stringWithFormat:@"%d", ticket.oilFeet2];
    }
    if (ticket.oilInch2 == 0) {
        self.lblOilInches2.text = @"-";
    } else {
        self.lblOilInches2.text = [NSString stringWithFormat:@"%d", ticket.oilInch2];
    }
    if (ticket.oilFraction2 == 0) {
        self.lblOil2.text = @"-";
    } else {
        self.lblOil2.text = [NSString stringWithFormat:@"%d", ticket.oilFraction2];
    }
    if (ticket.bottomsFeet2 == 0) {
        self.lblBottomsFeet2.text = @"-";
    } else {
        self.lblBottomsFeet2.text = [NSString stringWithFormat:@"%d", ticket.bottomsFeet2];
    }
    if (ticket.bottomsInch2 == 0) {
        self.lblBottomsInches2.text = @"-";
    } else {
        self.lblBottomsInches2.text = [NSString stringWithFormat:@"%d", ticket.bottomsInch2];
    }
    
    
    // Observed Fluid Characteristics
    if (ticket.obsGrav == nil || [ticket.obsGrav floatValue] == 0) {
        self.lblObsGrav.text = @"-";
    } else {
        self.lblObsGrav.text = [self floatString:ticket.obsGrav];
    }
    
    if (ticket.obsTemp == 0) {
        self.lblObsTemp.text = @"-";
    } else {
        self.lblObsTemp.text = [NSString stringWithFormat:@"%d", ticket.obsTemp];
    }
    
    if (ticket.bsw == nil || [ticket.bsw floatValue] == 0) {
        self.lblObsBSW.text = @"-";
    } else {
        self.lblObsBSW.text = [self floatString:ticket.bsw];
    }
    // Run Totals and Specs
    if (ticket.grossVol == nil || [ticket.grossVol isEqualToString:@""] || [ticket.grossVol floatValue] == 0) {
        self.lblGrossVol.text = @"-";
    } else {
        self.lblGrossVol.text = [self floatString:ticket.grossVol];
    }
    
    if (ticket.netVol == nil || [ticket.netVol isEqualToString:@""] || [ticket.netVol floatValue] == 0) {
        self.lblNetVol.text = @"-";
    } else {
        self.lblNetVol.text = [self floatString:ticket.netVol];
    }
    self.lblCalcGrossVol.text = ticket.calcGrossVol == nil || [ticket.calcGrossVol isEqualToString:@""] || [ticket.calcGrossVol floatValue] == 0 ? @"-" : ticket.calcGrossVol;
    self.lblCalcNetVol.text = ticket.calcNetVol == nil || [ticket.calcNetVol isEqualToString:@""] || [ticket.calcNetVol floatValue] == 0 ? @"-" : ticket.calcNetVol;
    self.lblHauler.text = ticket.carrier == nil || [ticket.carrier isEqualToString:@""] || [ticket.carrier floatValue] == 0 ? @"-" : ticket.carrier;
    self.lblDriver.text = ticket.driver == nil || [ticket.driver isEqualToString:@""] || [ticket.driver floatValue] == 0 ? @"-" : ticket.driver;

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"M/d/yyyy h:mm a"];
    
    self.lblTimeOn.text = ticket.timeOn == nil ? @"-" : [df stringFromDate:ticket.timeOn];
    self.lblTimeOff.text = ticket.timeOff == nil ? @"-" : [df stringFromDate:ticket.timeOff];
    
    // Comments
    if (ticket.comments != nil && ![ticket.comments isEqual:@""]) {
        self.lblComments.text = ticket.comments;
        float maxWidth = [UIScreen mainScreen].bounds.size.width - 32;
        float height = [self heightForString:ticket.comments font:self.lblComments.font maxWidth:maxWidth];
        self.scrollHeight.constant = 580 + height;
    } else {
        [self.lblCommentLabel setHidden:YES];
        [self.lblComments setHidden:YES];
        self.scrollHeight.constant = 580;
    }
    
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEdit:(id)sender {
    AddRunTicketsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddRunTicketsVC"];
    
    vc.runTickets = ticket;
    vc.tank = self.tank;
    vc.pulseProdHome = self.pulseProdHome;
    vc.isEdit = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onDelete:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure delete this Run Ticket?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[DBManager sharedInstance] deleteRunTicket:ticket.internalTicketID ticketNumber:ticket.ticketNumber])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)onTicketImage:(id)sender {
    
    if (self.ticket.ticketImage) {
        
        if ([ticket.ticketImage rangeOfString:@"runticketimageurl"].location == NSNotFound) {
            NSData *imageData = [[NSData alloc]initWithBase64EncodedString:self.ticket.ticketImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
            if (imageData) {
                self.imgFullTicket.image = [UIImage imageWithData:imageData];
                BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:[NSArray arrayWithObject:[UIImage imageWithData:imageData]]];
                imageVC.startingIndex = 0;
                [self presentViewController:imageVC animated:YES completion:nil];
            }
        } else {
            NSString *url_str = [NSString stringWithFormat:@"%@%@%@", BASE_URL, ASSETS_BASE_URL, ticket.ticketImage];
            BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:[NSArray arrayWithObject:url_str]];
            imageVC.startingIndex = 0;
            [self presentViewController:imageVC animated:YES completion:nil];
        }
        
//        [self.viewTicketImagePopup setHidden:NO];
    }
    
}

- (IBAction)onFullTicketImage:(id)sender {
    [self.viewTicketImagePopup setHidden:YES];
}

#pragma mark -
- (CGFloat)heightForString:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    if (![text isKindOfClass:[NSString class]] || !text.length) {
        // no text means no height
        return 0;
    }
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options attributes:attributes context:nil].size;
    CGFloat height = ceilf(size.height) + 1; // add 1 point as padding
    
    return height;
}

-(NSString*) floatString:(NSString*)str
{
    if (str == nil || [str isEqual:@""])
    {
        return @"-";
    }
    
    float val = [str floatValue];
    NSString *result = [NSString stringWithFormat:@"%.2f", val];
    return result;
}
@end
