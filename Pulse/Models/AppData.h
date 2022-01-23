#import <Foundation/Foundation.h>

#import "DBManager.h"
#import "BackgroundTask.h"
#import "TOPasscodeViewController.h"

typedef enum Status{
    Synced,
    SyncFailed,
    UploadFailed,
    Syncing,
}SyncStatus;

typedef enum InvoiceApprovalType {
    Field,
    Office
} InvoiceApprovalType;

@protocol DownloadedDelegate <NSObject>
-(void) downloadedCommonData;
@end

@protocol ChangedSyncStatusDelegate <NSObject>
-(void) changedSyncStatus;

@end


@interface AppData : NSObject <TOPasscodeViewControllerDelegate>

@property BOOL isBackground;

@property BOOL isSyncing;
@property int successCount;
@property int failedCount;

@property SyncStatus syncStatus;

@property (strong, nonatomic) BackgroundTask * bgTask;

// Invoice Approval Type
@property InvoiceApprovalType invoiceApprovalType;

// New Invoice data
@property (nonatomic, assign) BOOL              isEdit;
@property (nonatomic, strong) NSArray           *arrAccounts;
@property (nonatomic, strong) NSMutableArray    *arrSelectedAccounts;
@property (nonatomic, strong) NSMutableArray    *arrSelectedAccountTimes;
@property (nonatomic, strong) NSMutableArray    *arrSelectedAccountTimeUnits;

@property (nonatomic, strong) NSArray           *arrPeople;
@property (nonatomic, strong) NSMutableArray    *arrSelectedPeople;
@property (nonatomic, strong) NSString          *strComment;
@property (nonatomic, strong) NSString          *strTubingComment;
@property (nonatomic, strong) NSString          *strRodComment;

@property (nonatomic, strong) NSArray   *arrRoutes;
@property (nonatomic, strong) NSArray   *arrOperatings;
@property (nonatomic, strong) NSArray   *arrOwns;
@property (nonatomic, strong) NSString  *isEmptyPermission;

@property (nonatomic, strong) NSMutableArray *arrLeases;
@property (nonatomic, strong) NSMutableArray *arrLeaseNames;
@property (nonatomic, strong) NSMutableArray        *arrDownloadStatus;
@property (nonatomic, strong) NSMutableArray        *arrSecondDownloadStatus;
// New Schedule
@property (nonatomic, strong) NSMutableArray        *arrSelectedDates;
@property (nonatomic, strong) NSMutableArray        *arrScheduleComments;

@property (nonatomic, strong) WaterPumpInfo *selectedWaterMeterPumpInfo;

@property (nonatomic, strong) id<DownloadedDelegate> downloadedDelegate;
@property (nonatomic, strong) id<ChangedSyncStatusDelegate> changedStatusDelegate;


/**************************************************/

+(instancetype)sharedInstance;

-(void) initialize;

-(void) startAutoSyncing;
-(void) syncData:(NSTimer*)timer;
-(void) stopAutoSyncing;

-(void) changedSyncStatus:(SyncStatus)syncStatus;
-(void) mannualSync;

// Show/Hide progressbar
-(void) showProgressBarWithTitle:(NSString*)str;
-(void) hideProgressBar;

// download all data
-(void)doSyncFailedData;
-(void) downloadData:(BOOL)isProgressBar;
//-(void) downloadPersonnels;
//-(void) downloadLeaseRoutes;
//-(void) downloadListCompanies;
//-(void) downloadScheduleTypes;

// Productions module
//-(void) downloadAllLeases;
//-(void) downloadPulseProdField;
//-(void) downloadProductions;
//-(void) downloadProductionField;
//-(void) downloadProductionAvgs;
//-(void) downloadProductionAvgFields;
//-(void) downloadTanks;
//-(void) downloadTankGaugeEntries;
//-(void) downloadTankStrappings;
//-(void) downloadRunTickets;
//
//-(void) downloadListMeterProblem;
//-(void) downloadMeters;
//-(void) downloadGasMeterData;
//-(void) downloadWaterMeterData;
//-(void) downloadListWellProblem;
//-(void) downloadWellList;
//-(void) downloadWellheadData;
//
//-(void) downloadWBDCasingTubing;
//-(void) downloadWBDSurveys;
//-(void) downloadWBDPlugs;
//-(void) downloadWBDRods;
//-(void) downloadWBDInfo;
//-(void) downloadWBDInfoSource;
//-(void) downloadWBDPumps;
//-(void) downloadWBDTreatments;
//-(void) downloadWBDPerfs;
//
//-(void) downloadInvoices;
//-(void) downloadSchedules;
//-(void) downloadListAssetLocations;
//-(void) downloadInvoiceAccounts;
//
//-(void) downloadAllRigReports;
//-(void) downloadAllRigReportsRods;
//-(void) downloadRodSize;
//-(void) downloadRodType;
//-(void) downloadRodLength;
//
//-(void) downloadAllRigReportsPump;
//-(void) downloadPumpSize;
//-(void) downloadPumpType;
//
//-(void) downloadAllRigReportsTubing;
//-(void) downloadTubingSize;
//-(void) downloadTubingType;
//-(void) downloadTubingLength;
//
//-(void) downloadWaterPumpInfo;

// Sync status
-(SyncStatus) getSyncStatus;


// Get Invoices data
-(void) getUserPermissions;

// for new invoices/schedules
-(void) getLeases;

// upload all data
-(void) uploadRunTickets:(NSArray *)arrData;
-(void) uploadTankGaugeEntries:(NSArray*)arrData;

-(void) uploadGasMeterData:(NSArray*)arrData;
-(void) uploadWaterMeterData:(NSArray*)arrData;
-(void) uploadWellheadData:(NSArray*)arrData;

-(void) uploadInvoiceData:(NSArray*)arrData;
-(void) uploadInvoiceDetailData:(NSArray*)arrData;
-(void) uploadInvoicePersonnelData:(NSArray*)arrData;

-(void) uploadScheduleData:(NSArray*)arrData;

-(void) uploadRigReports:(NSArray*)arrData;
-(void)downloadRigReportsWithWellNum:(NSString *)wellNum lease:(NSString *)lease completionHandler:(void(^)(BOOL isSuccess))completionBlock;
-(void) uploadRigReportsRods:(NSArray *)arrData;
-(void) uploadRigReportsPump:(NSArray *)arrData;
-(void) uploadRigReportsTubing:(NSArray *)arrData;

// upload entries
-(void) uploadRunTickets:(NSArray *)arrData isAll:(BOOL)isAll;
-(void) uploadTankGaugeEntries:(NSArray*)arrData isAll:(BOOL)isAll;

-(void) uploadGasMeterData:(NSArray*)arrData isAll:(BOOL)isAll;
-(void) uploadWaterMeterData:(NSArray*)arrData isAll:(BOOL)isAll;
-(void) uploadWellheadData:(NSArray*)arrData isAll:(BOOL)isAll;

-(void) uploadInvoiceData:(NSArray*)arrData isAll:(BOOL)isAll;
-(void) uploadInvoiceDetailData:(NSArray*)arrData isAll:(BOOL)isAll;
-(void) uploadInvoicePersonnelData:(NSArray*)arrData isAll:(BOOL)isAll;

-(void) uploadScheduleData:(NSArray*)arrData isAll:(BOOL)isAll;

-(void) uploadRigReports:(NSArray*)arrData isAll:(BOOL)isAll;
-(void) uploadRigReportsRods:(NSArray *)arrData isAll:(BOOL)isAll;
-(void) uploadRigReportsPump:(NSArray *)arrData isAll:(BOOL)isAll;
-(void) uploadRigReportsTubing:(NSArray *)arrData isAll:(BOOL)isAll;

@end
