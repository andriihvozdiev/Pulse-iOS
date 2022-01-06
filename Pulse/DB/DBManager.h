#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "WebServiceManager.h"
#import "MBProgressHUD.h"

#import "Personnel+CoreDataClass.h"
#import "LeaseRoutes+CoreDataClass.h"
#import "ListCompany+CoreDataClass.h"
#import "ScheduleType+CoreDataClass.h"

#import "PulseProdHome+CoreDataClass.h"
#import "PulseProdField+CoreDataClass.h"
#import "Production+CoreDataClass.h"
#import "ProductionField+CoreDataClass.h"
#import "ProductionAvg+CoreDataClass.h"
#import "ProductionAvgField+CoreDataClass.h"
#import "Tanks+CoreDataClass.h"
#import "TankGaugeEntry+CoreDataClass.h"
#import "TankStrappings+CoreDataClass.h"

#import "RunTickets+CoreDataClass.h"

#import "ListMeterProblem+CoreDataClass.h"
#import "Meters+CoreDataClass.h"
#import "GasMeterData+CoreDataClass.h"
#import "WaterMeterData+CoreDataClass.h"

#import "ListWellProblem+CoreDataClass.h"
#import "WellList+CoreDataClass.h"
#import "WellheadData+CoreDataClass.h"

#import "WBDCasingTubing+CoreDataClass.h"
#import "WBDSurveys+CoreDataClass.h"
#import "WBDPlugs+CoreDataClass.h"
#import "WBDRods+CoreDataClass.h"

#import "WBDInfo+CoreDataClass.h"
#import "WBDInfoSource+CoreDataClass.h"
#import "WBDPumps+CoreDataClass.h"
#import "WBDTreatments+CoreDataClass.h"
#import "WBDPerfs+CoreDataClass.h"

#import "Invoices+CoreDataClass.h"
#import "InvoiceAccounts+CoreDataClass.h"
#import "InvoicesDetail+CoreDataClass.h"
#import "InvoicesPersonnel+CoreDataClass.h"

#import "Schedules+CoreDataClass.h"
#import "ListAssetLocations+CoreDataClass.h"

#import "RigReports+CoreDataClass.h"
#import "RigReportsRods+CoreDataClass.h"
#import "RodSize+CoreDataClass.h"
#import "RodType+CoreDataClass.h"
#import "RodLength+CoreDataClass.h"

#import "RigReportsPump+CoreDataClass.h"
#import "PumpSize+CoreDataClass.h"
#import "PumpType+CoreDataClass.h"

#import "RigReportsTubing+CoreDataClass.h"
#import "TubingSize+CoreDataClass.h"
#import "TubingType+CoreDataClass.h"
#import "TubingLength+CoreDataClass.h"

#import "WaterPumpInfo+CoreDataClass.h"



@interface DBManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

+(instancetype)sharedInstance;

-(BOOL) saveAllPersonnels:(NSArray*)arrData;
-(BOOL) saveLeaseRoutes:(NSArray*)arrData;
-(BOOL) saveListCompanies:(NSArray*)arrData;
-(BOOL) saveScheduleTypes:(NSArray*)arrData;

-(BOOL) saveAllLease:(NSArray*)arrData;
-(BOOL) savePulseProdField:(NSArray*)arrData;
-(BOOL) saveAllProductions:(NSArray*)arrData;
-(BOOL) saveProductionField:(NSArray*)arrData;
-(BOOL) saveAllProductionAvgs:(NSArray*)arrData;
-(BOOL) saveAllProductionAvgFields:(NSArray*)arrData;
-(BOOL) saveAllTanks:(NSArray*)arrData;
-(BOOL) saveAllTankGaugeEntries:(NSArray*)arrData;
-(BOOL) saveAllTankStrappings:(NSArray*)arrData;
-(BOOL) saveAllRunTickets:(NSArray*)arrData;

-(BOOL) saveListMeterProblem:(NSArray*)arrData;
-(BOOL) saveAllMeters:(NSArray*)arrData;
-(BOOL) saveAllGasMeterData:(NSArray*)arrData;
-(BOOL) saveAllWaterMeterData:(NSArray*)arrData;

-(BOOL) saveListWellProblem:(NSArray*)arrData;
-(BOOL) saveAllWellList:(NSArray*)arrData;
-(BOOL) saveAllWellheadData:(NSArray*)arrData;

-(BOOL) saveWBDCasingTubing:(NSArray*)arrData;
-(BOOL) saveWBDSurveys:(NSArray*)arrData;
-(BOOL) saveWBDPlugs:(NSArray*)arrData;
-(BOOL) saveWBDRods:(NSArray*)arrData;

-(BOOL) saveWBDInfo:(NSArray*)arrData;
-(BOOL) saveWBDInfoSource:(NSArray*)arrData;
-(BOOL) saveWBDPumps:(NSArray*)arrData;
-(BOOL) saveAllWBDTreatments:(NSArray*)arrData;
-(BOOL) saveAllWBDPerfs:(NSArray*)arrData;

-(BOOL) saveAllInvoicesData:(NSArray*)arrData;
//-(BOOL) saveSpecificInvoicesData:(NSArray*)arrData;

-(BOOL) saveAllSchedules:(NSArray*)arrData;
-(BOOL) saveListAssetLocations:(NSArray*)arrData;
-(BOOL) saveInvoiceAccounts:(NSArray*)arrData;

-(BOOL) saveAllRigReports:(NSArray*)arrData;
-(BOOL) saveAllRigReportsRods:(NSArray*)arrData;
-(BOOL) saveRodSize:(NSArray*)arrData;
-(BOOL) saveRodType:(NSArray*)arrData;
-(BOOL) saveRodLength:(NSArray*)arrData;

-(BOOL) saveAllRigReportsPump:(NSArray*)arrData;
-(BOOL) savePumpSize:(NSArray*)arrData;
-(BOOL) savePumpType:(NSArray*)arrData;

-(BOOL) saveAllRigReportsTubing:(NSArray*)arrData;
-(BOOL) saveTubingSize:(NSArray*)arrData;
-(BOOL) saveTubingType:(NSArray*)arrData;
-(BOOL) saveTubingLength:(NSArray*)arrData;

-(BOOL) saveAllPumpInfo:(NSArray*)arrData;


//
- (BOOL)coreDataHasEntriesForEntityName:(NSString *)entityName;

// get User
-(NSString*)    getUserName:(int)userid;
-(Personnel*)   getPersonnel:(int)userid;

// get lease data
-(NSArray*) getLeaseDataByAll;
-(NSArray*) getLeaseDataByDate;
-(NSArray*) getLeaseDataByRoute;
-(NSArray*) getLeaseDataByOperator;
-(NSArray*) getLeaseDataByOwner;

-(NSArray*) getPulseProdFields:(NSString*)lease;
-(NSMutableArray*) getProductionLeaseFields:(NSString*)lease;
-(NSArray*) getProductionFields:(NSString*)lease leaseField:(NSString*)leaseField;
-(NSArray*) getProductionFields:(NSString*)lease productionDate:(NSDate*)date;
-(NSString*) getProductionLeaseName:(NSString*) leaseField;

-(NSArray*)         getProductionByLease:(NSString*)lease;
-(ProductionAvg*)   getProductionAvgByLease:(NSString*)lease;
-(ProductionAvgField*) getProductionAvgFieldByLease:(NSString *)lease leaseField:(NSString*)leaseField;
-(NSArray*)         getTanksByLease:(NSString*)lease;
-(NSString*)        getTankRRCById:(int)tankID;
-(NSArray*)         getTankGaugeEntry:(NSString*)lease tankID:(int)tankID;
-(TankStrappings*)  getTankStrappingsWithRRC:(NSString*)rrc;
-(NSArray*)         getRunTickets:(NSString*)lease tankID:(int)tankID;

-(NSArray*)     getMeterProblems;
-(NSString*)    getMeterProblemReason:(NSString*)reasonCode;
-(NSString*)    getMeterProblemReasonCode:(NSString*)reason;
-(NSArray*)     getMetersByLease:(NSString*)lease;
-(NSArray*)     getMeterDataByLease:(NSString*)lease meterID:(NSString*)meterID meterType:(NSString*)meterType;

-(NSArray*)     getWellProblems;
-(NSString*)    getWellproblemReason:(NSString*)reasonCode;
-(NSString*)    getWellproblemReasonCode:(NSString*)reason;

-(NSArray*)     getWellListByLease:(NSString*)lease;
-(NSArray*)     getWellheadDataByLease:(NSString*)lease wellNum:(NSString*)wellNum;
-(NSMutableDictionary*) getWellheadDataByLeaseForOverview:(NSString *)lease wellNum:(NSString *)wellNum;

// Get WBD data
-(NSArray*)     getWBDSurveys:(NSString*)lease wellNum:(NSString*)wellNum;
-(NSArray*)     getWBDPlugs:(NSString*)lease wellNum:(NSString*)wellNum;
-(NSArray*)     getCasing:(NSString*)lease wellNum:(NSString*)wellNum;
-(NSArray*)     getWBDTubings:(NSString*)lease wellNum:(NSString*)wellNum;
-(NSArray*)     getWBDRods:(NSString*)lease wellNum:(NSString*)wellNum;

-(NSArray*)     getWBDInfos:(NSString*)tblName recordID:(int)recordID lease:(NSString*)lease wellNum:(NSString*)wellNum;
-(NSString*)    getWBDInfoSourceType:(int)sourceID;

-(NSArray*)     getWBDPumps:(NSString*)lease wellNum:(NSString*)wellNum;
-(NSArray*)     getWBDTreatments:(NSString*)lease wellNum:(NSString*)wellNum;
-(NSArray*)     getWBDPerfs:(NSString*)lease wellNum:(NSString*)wellNum;

-(NSString*)    getCompanyName:(NSString*)companyCode;
-(NSString*)    getCompanyCode:(NSString*)company;
-(NSString*)    getRouteName:(NSString*)strID;

// Get Invoices methods
-(NSMutableDictionary*) getInvoicesForLastCommentsWithWellNum:(NSString*)wellNum withLease:(NSString*)lease;
-(Invoices*)    getInvoice:(int)invoiceID withAppID:(NSString*)invoiceAppID;

-(NSArray*) getInvoices:(NSString*) sortType;

-(NSArray*)     getInvoicesByDate;
-(NSArray*)     getInvoicesByLease;
-(NSArray*)     getInvoicesByAcccount;
-(NSArray*)     getInvoicesByPeople;

-(NSArray*)     getInvoiceDetail:(int)invoiceID appID:(NSString*)invoiceAppID;
-(NSArray*)     getInvoicePersonnel:(int)invoiceID appID:(NSString*)invoiceAppID;

-(NSArray*)         getAllAccounts;
-(NSString*)        getAccountDescription:(int)acctID withSubAccount:(int)subAcctID;
-(InvoiceAccounts*) getAccount:(int)acctID withSub:(int)subAcctID;
-(NSArray*)         getPersonnels;
-(float)            getTotalCostWithLease:(NSString *)lease wellNum:(NSString *)wellNumber;


// Get Schedule methods
-(NSArray*) getSchedulesByLease;
-(NSArray*) getSchedulesByType;
-(NSArray*) getSchedulesByDate;
-(NSArray*) getSchedulesByStatus;

-(NSArray*) getScheduleTypesByCategory:(NSString*)category;
-(NSArray*) getLeases;
-(NSArray*) getLeasesForInvoice;

-(NSString*) getLeaseNameFromLease:(NSString*)lease;
-(NSString*) getLeaseNameFromPropNum:(NSString *)propNum;

// get RigReports data
- (float)   getTotalCostFromRigReportsWithLease:(NSString *)lease wellNum:(NSString *)wellNumber;
-(NSArray*) getRigReportsByDate;
-(NSArray*) getRigReportsByLease;
-(NSArray*) getRigReportsByWellNum:(NSString*)wellNum withLease:(NSString*)lease;
-(NSMutableDictionary*) getCommentsForRigReportsByWellNum:(NSString*)wellNum withLease:(NSString*)lease;

-(NSMutableArray*) getRigReportsRods:(int)reportID inOut:(BOOL)isIn withAppID:(NSString*)reportAppID;
-(NSArray*) getRodSize;
-(NSArray*) getRodTypes;
-(NSArray*) getRodLength;

-(NSMutableArray*) getRigReportsPump:(int)reportID inOut:(BOOL)isIn withAppID:(NSString*)reportAppID;
-(NSArray*) getPumpSize;
-(NSArray*) getPumpType;

-(NSMutableArray*) getRigReportsTubing:(int)reportID inOut:(BOOL)isIn withAppID:(NSString*)reportAppID;
-(NSArray*) getTubingSize;
-(NSArray*) getTubingType;
-(NSArray*) getTubingLength;

-(NSArray*) getAllPumpInfo;

-(BOOL) addTankGaugeEntry:(NSDictionary*)dicData;
-(BOOL) addRunTicket:(NSDictionary*)dicData;
-(BOOL) deleteRunTicket:(int)ticketId ticketNumber:(NSString*)ticketNumber;
-(BOOL) addMeterData:(NSDictionary*)dicData;
-(BOOL) addWellheadData:(NSDictionary*)dicData;

-(BOOL) createInvoices:(NSDictionary*)dicData;
-(BOOL) editInvoices:(NSDictionary *)dicData;
-(BOOL) changeInvoice:(NSDictionary*)dicData;
-(BOOL) addInvoiceAccount:(NSDictionary*)dicData;
-(BOOL) changeAccountTime:(NSDictionary*)dicData;
-(BOOL) removeAccountFromInvoice:(NSDictionary*)dicData;
-(BOOL) removeInvoice:(int)invoiceID withAppID:(NSString*)invoiceAppID;
-(BOOL) removePersonnels:(int)invoiceID withAppID:(NSString*)invoiceAppID;

-(BOOL) createSchedule:(NSDictionary*)dicData;

-(BOOL) addRigReports:(NSDictionary*)dicData;
-(BOOL) addRigReportsRods:(NSDictionary*)dicData inOut:(BOOL)inOut;
-(BOOL) addRigReportsPump:(NSDictionary*)dicData inOut:(BOOL)inOut;
-(BOOL) addRigReportsTubing:(NSDictionary*)dicData inOut:(BOOL)inOut;
-(void) changeRodOrders:(NSMutableArray*)arrChangedRods;
-(void) changeTubingOrders:(NSMutableArray*)arrChangedTubing;
-(void) changePumpOrders:(NSMutableArray*)arrChangedPump;

/*********** sync data **************/
-(void) syncData;
-(void) syncRunTicketsData;
-(void) syncTankGaugeEntryData;
-(void) syncGasMeterData;
-(void) syncWaterMeterData;
-(void) syncWellheadData;
-(void) syncInvoicesData;
-(void) syncInvoicesDetailData;
-(void) syncInvoicesPersonnel;

-(void) syncSchedulesData;

-(void) syncRigReports;
-(void) syncRigReportsRods;
-(void) syncRigReportsPump;
-(void) syncRigReportsTubing;

// get updated data
-(NSArray*) getUpdatedInvoicesDetails;
-(NSArray*) getUpdatedInvoicesPersonnel;

// chagne local's status after uploading
-(void) uploadedRunTickets:(NSArray*)arrData;
-(void) uploadedTankGaugeEntries:(NSArray*)arrData;
-(void) uploadedGasMeterData:(NSArray*)arrData;
-(void) uploadedWaterMeterData:(NSArray*)arrData;
-(void) uploadedWellheadData:(NSArray*)arrData;

-(void) uploadedInvoicesFromLocal:(NSArray*)arrData;
-(void) uploadedInvoicesDetailFromLocal:(NSArray*)arrData;
-(void) uploadedInvoicesPersonnelFromLocal:(NSArray*)arrData;

-(void) uploadedScheduleData:(NSArray*)arrData;
-(void) uploadedRigReports:(NSArray*)arrData;
-(void) uploadedRigReportRods:(NSArray*)arrData;
-(void) uploadedRigReportPump:(NSArray*)arrData;
-(void) uploadedRigReportTubing:(NSArray*)arrData;

@end
