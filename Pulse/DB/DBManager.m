#import "DBManager.h"
#import "AppDelegate.h"
#import "AppData.h"

@implementation DBManager

@synthesize context;

+(instancetype)sharedInstance
{
    static DBManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        singleton = [[DBManager alloc] init];        
    });
    return singleton;
}

-(id)init
{
    self = [super init];
    if (self) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        context = [appDelegate managedObjectContext];
    }
    return self;
}


#pragma mark -
-(NSDate*) getDateFromString:(id)dateString
{
    NSDate *result = nil;
    if (dateString == [NSNull null]) {
        result = nil;
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        result = [dateFormatter dateFromString:dateString];
    }
    return result;
}

-(NSString*) getStringFromObject:(id)str
{
    return str == [NSNull null] ? nil : (NSString*)str;
}

#pragma mark -
-(BOOL) saveAllPersonnels:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Personnel"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        
        Personnel *personnel = [NSEntityDescription insertNewObjectForEntityForName:@"Personnel" inManagedObjectContext:context];
        
        // set data
        personnel.userid = [[dicData valueForKey:@"userid"] intValue];
        personnel.employeeName = [dicData valueForKey:@"employeeName"];
        personnel.email = [dicData valueForKey:@"email"] == [NSNull null] ? nil : [dicData valueForKey:@"email"];
        personnel.department = [dicData valueForKey:@"department"] == [NSNull null] ? nil : [dicData valueForKey:@"department"];
        personnel.active = [[dicData valueForKey:@"active"] boolValue];
        personnel.invPersonnel = [[dicData valueForKey:@"invPersonnel"] boolValue];
        
        personnel.primaryApp = [[dicData valueForKey:@"primaryApp"] boolValue];
        personnel.secondaryApp = [[dicData valueForKey:@"secondaryApp"] boolValue];
        personnel.outsideBillApp = [[dicData valueForKey:@"outsideBillApp"] boolValue];
        personnel.noBillApp = [[dicData valueForKey:@"noBillApp"] boolValue];
        
        NSError *error;
        
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveLeaseRoutes:(NSArray*)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"LeaseRoutes"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {

        LeaseRoutes *route = [NSEntityDescription insertNewObjectForEntityForName:@"LeaseRoutes" inManagedObjectContext:context];
        
        // set data
        route.routeID = [[dicData valueForKey:@"id"] intValue];
        route.routeName = [dicData valueForKey:@"routeName"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveListCompanies:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ListCompany"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        
        ListCompany *listCompany = [NSEntityDescription insertNewObjectForEntityForName:@"ListCompany" inManagedObjectContext:context];
        
        // set data
        listCompany.companyCode = [dicData valueForKey:@"companyCode"];
        listCompany.company = [dicData valueForKey:@"company"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveScheduleTypes:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ScheduleType"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        
        ScheduleType *scheduleType = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleType" inManagedObjectContext:context];
        
        // set data
        scheduleType.scheduleTypeID = [[dicData valueForKey:@"scheduleTypeID"] intValue];
        scheduleType.type = [dicData valueForKey:@"type"];
        scheduleType.category = [dicData valueForKey:@"category"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;

}

#pragma mark -
-(BOOL) saveAllLease:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PulseProdHome"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        int prodID = [[dicData valueForKey:@"prodID"] intValue];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"PulseProdHome" inManagedObjectContext:context];
        [fetchRequest setEntity:entityModel];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"prodID == %d", prodID];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *arrExistingPulseProdHome = [context executeFetchRequest:fetchRequest error:&error];
        
        PulseProdHome *pulseProdHome = nil;
        if (!error && arrExistingPulseProdHome.count > 0) {
            pulseProdHome = arrExistingPulseProdHome[0];
        } else {
            pulseProdHome = [NSEntityDescription insertNewObjectForEntityForName:@"PulseProdHome" inManagedObjectContext:context];
        }
        
        // set data
        pulseProdHome.prodID = prodID;
        pulseProdHome.lease = [dicData valueForKey:@"lease"];
        pulseProdHome.leaseName = [dicData valueForKey:@"leaseName"];
        pulseProdHome.date = [dicData valueForKey:@"date"] == [NSNull null] ? nil : [df dateFromString:[dicData valueForKey:@"date"]];
        pulseProdHome.oilVol = [dicData valueForKey:@"oilVol"] == [NSNull null] ? nil : [dicData valueForKey:@"oilVol"];
        pulseProdHome.gasVol = [dicData valueForKey:@"gasVol"] == [NSNull null] ? nil : [dicData valueForKey:@"gasVol"];
        pulseProdHome.waterVol = [dicData valueForKey:@"waterVol"] == [NSNull null] ? nil : [dicData valueForKey:@"waterVol"];
        pulseProdHome.allocatedVolume = [[dicData valueForKey:@"allocatedVolume"] boolValue];
        pulseProdHome.route = [[dicData valueForKey:@"route"] intValue];
        pulseProdHome.operator = [dicData valueForKey:@"operator"];
        pulseProdHome.owner = [dicData valueForKey:@"owner"];
        pulseProdHome.oilComments = [dicData valueForKey:@"oilComments"] == [NSNull null] ? nil : [dicData valueForKey:@"oilComments"];
        pulseProdHome.gasComments = [dicData valueForKey:@"gasComments"] == [NSNull null] ? nil : [dicData valueForKey:@"gasComments"];
        pulseProdHome.waterComments = [dicData valueForKey:@"waterComments"] == [NSNull null] ? nil : [dicData valueForKey:@"waterComments"];
        pulseProdHome.wellheadComments = [dicData valueForKey:@"wellheadComments"] == [NSNull null] ? nil : [dicData valueForKey:@"wellheadComments"];
        pulseProdHome.wellheadData = [dicData valueForKey:@"wellheadData"] == [NSNull null] ? nil : [dicData valueForKey:@"wellheadData"];
        
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) savePulseProdField:(NSArray*)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PulseProdField"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        int prodID = [[dicData valueForKey:@"prodID"] intValue];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"PulseProdField" inManagedObjectContext:context];
        [fetchRequest setEntity:entityModel];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"prodID == %d", prodID];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *arrExistingPulseProdHome = [context executeFetchRequest:fetchRequest error:&error];
        
        PulseProdField *pulseProdField = nil;
        if (!error && arrExistingPulseProdHome.count > 0) {
            pulseProdField = arrExistingPulseProdHome[0];
        } else {
            pulseProdField = [NSEntityDescription insertNewObjectForEntityForName:@"PulseProdField" inManagedObjectContext:context];
        }
        
        // set data
        pulseProdField.prodID = prodID;
        pulseProdField.lease = [dicData valueForKey:@"lease"];
        pulseProdField.leaseName = [dicData valueForKey:@"leaseName"];
        pulseProdField.fieldName = [dicData valueForKey:@"fieldName"];
        pulseProdField.oilVol = [dicData valueForKey:@"oilVol"] == [NSNull null] ? nil : [dicData valueForKey:@"oilVol"];
        pulseProdField.oilCalcType = [dicData valueForKey:@"oilCalcType"] == [NSNull null] ? nil : [dicData valueForKey:@"oilCalcType"];
        pulseProdField.gasVol = [dicData valueForKey:@"gasVol"] == [NSNull null] ? nil : [dicData valueForKey:@"gasVol"];
        pulseProdField.gasCalcType = [dicData valueForKey:@"gasCalcType"] == [NSNull null] ? nil : [dicData valueForKey:@"gasCalcType"];
        pulseProdField.waterVol = [dicData valueForKey:@"waterVol"] == [NSNull null] ? nil : [dicData valueForKey:@"waterVol"];
        pulseProdField.waterCalcType = [dicData valueForKey:@"waterCalcType"] == [NSNull null] ? nil : [dicData valueForKey:@"waterCalcType"];
        
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveAllProductions:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Production"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        Production *production = [NSEntityDescription insertNewObjectForEntityForName:@"Production" inManagedObjectContext:context];
        
        // set data
        production.prodID = [[dicData valueForKey:@"prodID"] intValue];
        production.lease = [dicData valueForKey:@"lease"];
        production.leaseName = [dicData valueForKey:@"leaseName"] == [NSNull null] ? @"" : [dicData valueForKey:@"leaseName"];
        NSDate *productionDate = [dateFormatter dateFromString:[dicData valueForKey:@"productionDate"]];
        production.productionDate = productionDate;
        production.oilVol = [dicData valueForKey:@"oilVol"] == [NSNull null] ? nil : [dicData valueForKey:@"oilVol"];
        production.gasVol = [dicData valueForKey:@"gasVol"] == [NSNull null] ? nil : [dicData valueForKey:@"gasVol"];
        production.waterVol = [dicData valueForKey:@"waterVol"] == [NSNull null] ? nil : [dicData valueForKey:@"waterVol"];
        production.allocatedVolume = [[dicData valueForKey:@"allocatedVolume"] boolValue];
        production.oilComments = [dicData valueForKey:@"oilComments"] == [NSNull null] ? nil : [dicData valueForKey:@"oilComments"];
        production.gasComments = [dicData valueForKey:@"gasComments"] == [NSNull null] ? nil : [dicData valueForKey:@"gasComments"];
        production.waterComments = [dicData valueForKey:@"waterComments"] == [NSNull null] ? nil : [dicData valueForKey:@"waterComments"];
        production.wellheadComments = [dicData valueForKey:@"wellheadComments"] == [NSNull null] ? nil : [dicData valueForKey:@"wellheadComments"];
        production.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
        production.wellheadData = [dicData valueForKey:@"wellheadData"] == [NSNull null] ? nil : [dicData valueForKey:@"wellheadData"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveProductionField:(NSArray*)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ProductionField"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        int prodID = [[dicData valueForKey:@"prodID"] intValue];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"ProductionField" inManagedObjectContext:context];
        [fetchRequest setEntity:entityModel];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"prodID == %d", prodID];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *arrExistingProductionField = [context executeFetchRequest:fetchRequest error:&error];
        
        ProductionField *productionField = nil;
        if (!error && arrExistingProductionField.count > 0) {
            productionField = arrExistingProductionField[0];
        } else {
            productionField = [NSEntityDescription insertNewObjectForEntityForName:@"ProductionField" inManagedObjectContext:context];
        }
        
        // set data
        productionField.prodID = prodID;
        productionField.lease = [dicData valueForKey:@"lease"];
        
        if ([[dicData valueForKey:@"leaseName"] isKindOfClass:[NSNull class]]) {
            productionField.leaseName = @"";
        } else {
            productionField.leaseName = [dicData valueForKey:@"leaseName"];
        }
        
        productionField.leaseField = [dicData valueForKey:@"leaseField"];
        productionField.oilVol = [dicData valueForKey:@"oilVol"] == [NSNull null] ? nil : [dicData valueForKey:@"oilVol"];
        productionField.gasVol = [dicData valueForKey:@"gasVol"] == [NSNull null] ? nil : [dicData valueForKey:@"gasVol"];
        productionField.waterVol = [dicData valueForKey:@"waterVol"] == [NSNull null] ? nil : [dicData valueForKey:@"waterVol"];
        productionField.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
        productionField.oilComments = [dicData valueForKey:@"oilComments"] == [NSNull null] ? nil : [dicData valueForKey:@"oilComments"];
        productionField.gasComments = [dicData valueForKey:@"gasComments"] == [NSNull null] ? nil : [dicData valueForKey:@"gasComments"];
        productionField.waterComments = [dicData valueForKey:@"waterComments"] == [NSNull null] ? nil : [dicData valueForKey:@"waterComments"];
        productionField.wellheadComments = [dicData valueForKey:@"wellheadComments"] == [NSNull null] ? nil : [dicData valueForKey:@"wellheadComments"];
        productionField.wellheadData = [dicData valueForKey:@"wellheadData"] == [NSNull null] ? nil : [dicData valueForKey:@"wellheadData"];
        
        NSDate *productionDate = [dateFormatter dateFromString:[dicData valueForKey:@"productionDate"]];
        productionField.productionDate = productionDate;
        
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveAllProductionAvgs:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ProductionAvg"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        ProductionAvg *productionAvg = [NSEntityDescription insertNewObjectForEntityForName:@"ProductionAvg" inManagedObjectContext:context];
        
        // set data
        productionAvg.prodID = [[dicData valueForKey:@"prodID"] intValue];
        productionAvg.lease = [dicData valueForKey:@"lease"];
        productionAvg.leaseName = [dicData valueForKey:@"leaseName"];
        productionAvg.productionDate = [dateFormatter dateFromString:[dicData valueForKey:@"productionDate"]];
        productionAvg.allocatedVolume = [dicData valueForKey:@"allocatedVolume"] == [NSNull null] ? NO : [[dicData valueForKey:@"allocatedVolume"] boolValue];
        productionAvg.oil7 = [dicData valueForKey:@"oil7"] == [NSNull null] ? nil : [dicData valueForKey:@"oil7"];
        productionAvg.oil30 = [dicData valueForKey:@"oil30"] == [NSNull null] ? nil : [dicData valueForKey:@"oil30"];
        productionAvg.oil365 = [dicData valueForKey:@"oil365"] == [NSNull null] ? nil : [dicData valueForKey:@"oil365"];
        productionAvg.gas7 = [dicData valueForKey:@"gas7"] == [NSNull null] ? nil : [dicData valueForKey:@"gas7"];
        productionAvg.gas30 = [dicData valueForKey:@"gas30"] == [NSNull null] ? nil : [dicData valueForKey:@"gas30"];
        productionAvg.gas365 = [dicData valueForKey:@"gas365"] == [NSNull null] ? nil : [dicData valueForKey:@"gas365"];
        productionAvg.water7 = [dicData valueForKey:@"water7"] == [NSNull null] ? nil : [dicData valueForKey:@"water7"];
        productionAvg.water30 = [dicData valueForKey:@"water30"] == [NSNull null] ? nil : [dicData valueForKey:@"water30"];
        productionAvg.water365 = [dicData valueForKey:@"water365"] == [NSNull null] ? nil : [dicData valueForKey:@"water365"];
        productionAvg.oilP30 = [dicData valueForKey:@"oilP30"] == [NSNull null] ? nil : [dicData valueForKey:@"oilP30"];
        productionAvg.gasP30 = [dicData valueForKey:@"gasP30"] == [NSNull null] ? nil : [dicData valueForKey:@"gasP30"];
        productionAvg.waterP30 = [dicData valueForKey:@"waterP30"] == [NSNull null] ? nil : [dicData valueForKey:@"waterP30"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveAllProductionAvgFields:(NSArray*)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ProductionAvgField"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        ProductionAvgField *prodAvgField = [NSEntityDescription insertNewObjectForEntityForName:@"ProductionAvgField" inManagedObjectContext:context];
        
        // set data
        prodAvgField.prodID = [[dicData valueForKey:@"prodID"] intValue];
        prodAvgField.lease = [dicData valueForKey:@"lease"];
        prodAvgField.leaseName = [dicData valueForKey:@"leaseName"];
        prodAvgField.leaseField = [dicData valueForKey:@"leaseField"];
        prodAvgField.productionDate = [dateFormatter dateFromString:[dicData valueForKey:@"productionDate"]];
        prodAvgField.allocatedVolume = [dicData valueForKey:@"allocatedVolume"] == [NSNull null] ? NO : [[dicData valueForKey:@"allocatedVolume"] boolValue];
        prodAvgField.oil7 = [dicData valueForKey:@"oil7"] == [NSNull null] ? nil : [dicData valueForKey:@"oil7"];
        prodAvgField.oil30 = [dicData valueForKey:@"oil30"] == [NSNull null] ? nil : [dicData valueForKey:@"oil30"];
        prodAvgField.oil365 = [dicData valueForKey:@"oil365"] == [NSNull null] ? nil : [dicData valueForKey:@"oil365"];
        prodAvgField.gas7 = [dicData valueForKey:@"gas7"] == [NSNull null] ? nil : [dicData valueForKey:@"gas7"];
        prodAvgField.gas30 = [dicData valueForKey:@"gas30"] == [NSNull null] ? nil : [dicData valueForKey:@"gas30"];
        prodAvgField.gas365 = [dicData valueForKey:@"gas365"] == [NSNull null] ? nil : [dicData valueForKey:@"gas365"];
        prodAvgField.water7 = [dicData valueForKey:@"water7"] == [NSNull null] ? nil : [dicData valueForKey:@"water7"];
        prodAvgField.water30 = [dicData valueForKey:@"water30"] == [NSNull null] ? nil : [dicData valueForKey:@"water30"];
        prodAvgField.water365 = [dicData valueForKey:@"water365"] == [NSNull null] ? nil : [dicData valueForKey:@"water365"];
        prodAvgField.oilP30 = [dicData valueForKey:@"oilP30"] == [NSNull null] ? nil : [dicData valueForKey:@"oilP30"];
        prodAvgField.gasP30 = [dicData valueForKey:@"gasP30"] == [NSNull null] ? nil : [dicData valueForKey:@"gasP30"];
        prodAvgField.waterP30 = [dicData valueForKey:@"waterP30"] == [NSNull null] ? nil : [dicData valueForKey:@"waterP30"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveAllTanks:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Tanks"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        Tanks *tanks = [NSEntityDescription insertNewObjectForEntityForName:@"Tanks" inManagedObjectContext:context];
        
        // set data
        tanks.tankID = [[dicData valueForKey:@"tankID"] intValue];
        tanks.lease = [dicData valueForKey:@"lease"];
        tanks.rrc = [dicData valueForKey:@"RRC"];
        tanks.tankType = [dicData valueForKey:@"tankType"];
        tanks.current = [[dicData valueForKey:@"current"] boolValue];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveAllTankGaugeEntries:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [TankGaugeEntry fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        
        int tankGaugeID = [[dicData valueForKey:@"tankGaugeID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"tankGaugeID == %d", tankGaugeID];
        fetchRequest = [TankGaugeEntry fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrTankGagueEntry = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrTankGagueEntry.count > 0) {
            return YES;
        }
        
        TankGaugeEntry *tankgaugeentry = [NSEntityDescription insertNewObjectForEntityForName:@"TankGaugeEntry" inManagedObjectContext:context];
        
        tankgaugeentry.tankGaugeID = tankGaugeID;
        
        NSDate *gaugeTime = [dateFormatter dateFromString:[dicData valueForKey:@"gaugeTime"]];
        tankgaugeentry.gaugeTime = gaugeTime;
        
        NSDate *entryTime = [dateFormatter dateFromString:[dicData valueForKey:@"entryTime"]];
        tankgaugeentry.entryTime = entryTime;
        
        tankgaugeentry.deviceID = [dicData valueForKey:@"deviceID"];
        tankgaugeentry.lease = [dicData valueForKey:@"lease"];
        tankgaugeentry.comments = [self getStringFromDictionry:dicData WithKey:@"comments"];
        
        tankgaugeentry.tankID1 = [[dicData valueForKey:@"tankID1"] intValue];
        tankgaugeentry.tankID2 = [[dicData valueForKey:@"tankID2"] intValue];
        tankgaugeentry.tankID3 = [[dicData valueForKey:@"tankID3"] intValue];
        tankgaugeentry.tankID4 = [[dicData valueForKey:@"tankID4"] intValue];
        tankgaugeentry.tankID5 = [[dicData valueForKey:@"tankID5"] intValue];
        tankgaugeentry.tankID6 = [[dicData valueForKey:@"tankID6"] intValue];
        tankgaugeentry.tankID7 = [[dicData valueForKey:@"tankID7"] intValue];
        tankgaugeentry.tankID8 = [[dicData valueForKey:@"tankID8"] intValue];
        tankgaugeentry.tankID9 = [[dicData valueForKey:@"tankID9"] intValue];
        tankgaugeentry.tankID10 = [[dicData valueForKey:@"tankID10"] intValue];
        
        tankgaugeentry.oilFeet1 = [[dicData valueForKey:@"oilFeet1"] intValue];
        tankgaugeentry.oilFeet2 = [[dicData valueForKey:@"oilFeet2"] intValue];
        tankgaugeentry.oilFeet3 = [[dicData valueForKey:@"oilFeet3"] intValue];
        tankgaugeentry.oilFeet4 = [[dicData valueForKey:@"oilFeet4"] intValue];
        tankgaugeentry.oilFeet5 = [[dicData valueForKey:@"oilFeet5"] intValue];
        tankgaugeentry.oilFeet6 = [[dicData valueForKey:@"oilFeet6"] intValue];
        tankgaugeentry.oilFeet7 = [[dicData valueForKey:@"oilFeet7"] intValue];
        tankgaugeentry.oilFeet8 = [[dicData valueForKey:@"oilFeet8"] intValue];
        tankgaugeentry.oilFeet9 = [[dicData valueForKey:@"oilFeet9"] intValue];
        tankgaugeentry.oilFeet10 = [[dicData valueForKey:@"oilFeet10"] intValue];
        
        
        NSDate *lastGgDt = [dicData valueForKey:@"lastGgDt"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"lastGgDt"]];
        tankgaugeentry.lastGgDt = lastGgDt;
        
        NSDate *Hr24GgDt = [dicData valueForKey:@"24HrGgDt"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"24HrGgDt"]];
        tankgaugeentry.hr24GgDt = Hr24GgDt;
        
        tankgaugeentry.calcBbls = [self getStringFromDictionry:dicData WithKey:@"calcBbls"];
        tankgaugeentry.calc24Bbls = [self getStringFromDictionry:dicData WithKey:@"24CalcBbls"];
        tankgaugeentry.runTicketVol = [self getStringFromDictionry:dicData WithKey:@"runTicketVol"];
        tankgaugeentry.runTicketVol24 = [self getStringFromDictionry:dicData WithKey:@"runTicketVol24"];
        tankgaugeentry.bswVol = [self getStringFromDictionry:dicData WithKey:@"bswVol"];
        tankgaugeentry.bswVol24 = [self getStringFromDictionry:dicData WithKey:@"bswVol24"];
        tankgaugeentry.onHandOil = [self getStringFromDictionry:dicData WithKey:@"onHandOil"];
        tankgaugeentry.negProdQC = [[dicData valueForKey:@"negProdQC"] boolValue];
        tankgaugeentry.userid = [dicData valueForKey:@"userid"] == [NSNull null] ? 0 : [[dicData valueForKey:@"userid"] intValue];
        tankgaugeentry.downloaded = YES;
        
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(NSString*)getStringFromDictionry:(NSDictionary*)dic WithKey:(NSString*)key
{
    return [dic valueForKey:key] == [NSNull null] ? nil : [dic valueForKey:key];
}

-(BOOL) saveAllTankStrappings:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TankStrappings"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        
        TankStrappings *tankStrappings = [NSEntityDescription insertNewObjectForEntityForName:@"TankStrappings" inManagedObjectContext:context];
        
        // set data
        tankStrappings.rrc = [dicData valueForKey:@"rrc"];
        tankStrappings.inc1 = [self getStringFromDictionry:dicData WithKey:@"inc1"];
        tankStrappings.inc2 = [self getStringFromDictionry:dicData WithKey:@"inc2"];
        tankStrappings.inc3 = [self getStringFromDictionry:dicData WithKey:@"inc3"];
        tankStrappings.inc4 = [self getStringFromDictionry:dicData WithKey:@"inc4"];
        tankStrappings.inc5 = [self getStringFromDictionry:dicData WithKey:@"inc5"];
        tankStrappings.inc6 = [self getStringFromDictionry:dicData WithKey:@"inc6"];
        tankStrappings.inc7 = [self getStringFromDictionry:dicData WithKey:@"inc7"];
        tankStrappings.inc8 = [self getStringFromDictionry:dicData WithKey:@"inc8"];
        tankStrappings.inc9 = [self getStringFromDictionry:dicData WithKey:@"inc9"];
        tankStrappings.inc10 = [self getStringFromDictionry:dicData WithKey:@"inc10"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveAllRunTickets:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [RunTickets fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        int internalTicketID = [[dicData valueForKey:@"internalTicketID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"internalTicketID == %d", internalTicketID];
        fetchRequest = [RunTickets fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrRunTickets = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrRunTickets.count > 0) {
            return YES;
        }
        
        RunTickets *ticket = [NSEntityDescription insertNewObjectForEntityForName:@"RunTickets" inManagedObjectContext:context];
        
        // set data
        ticket.internalTicketID = internalTicketID;
        ticket.deviceID = [dicData valueForKey:@"deviceID"];
        ticket.entryTime = [dateFormatter dateFromString:[dicData valueForKey:@"entryTime"]];
        ticket.ticketTime = [dateFormatter dateFromString:[dicData valueForKey:@"ticketTime"]];
        ticket.lease = [dicData valueForKey:@"lease"];
        ticket.tankNumber = [[dicData valueForKey:@"tankNumber"] intValue];
        ticket.ticketNumber = [dicData valueForKey:@"ticketNumber"] == [NSNull null] ? nil : [dicData valueForKey:@"ticketNumber"];
        ticket.temp1 = [dicData valueForKey:@"temp1"] == [NSNull null] ? 0 : [[dicData valueForKey:@"temp1"] intValue];
        ticket.oilFeet1 = [dicData valueForKey:@"oilFeet1"] == [NSNull null] ? 0 : [[dicData valueForKey:@"oilFeet1"] intValue];
        ticket.oilInch1 = [dicData valueForKey:@"oilInch1"] == [NSNull null] ? 0 : [[dicData valueForKey:@"oilInch1"] intValue];
        ticket.oilFraction1 = [dicData valueForKey:@"oilFraction1"] == [NSNull null] ? 0 : [[dicData valueForKey:@"oilFraction1"] intValue];
        ticket.bottomsFeet1 = [dicData valueForKey:@"bottomsFeet1"] == [NSNull null] ? 0 : [[dicData valueForKey:@"bottomsFeet1"] intValue];
        ticket.bottomsInch1 = [dicData valueForKey:@"bottomsInch1"] == [NSNull null] ? 0: [[dicData valueForKey:@"bottomsInch1"] intValue];
        ticket.temp2 = [dicData valueForKey:@"temp2"] == [NSNull null] ? 0 : [[dicData valueForKey:@"temp2"] intValue];
        ticket.oilFeet2 = [dicData valueForKey:@"oilFeet2"] == [NSNull null] ? 0 : [[dicData valueForKey:@"oilFeet2"] intValue];
        ticket.oilInch2 = [dicData valueForKey:@"oilInch2"] == [NSNull null] ? 0 : [[dicData valueForKey:@"oilInch2"] intValue];
        ticket.oilFraction2 = [dicData valueForKey:@"oilFraction2"] == [NSNull null] ? 0 : [[dicData valueForKey:@"oilFraction2"] intValue];
        ticket.bottomsFeet2 = [dicData valueForKey:@"bottomsFeet2"] == [NSNull null] ? 0 : [[dicData valueForKey:@"bottomsFeet2"] intValue];
        ticket.bottomsInch2 = [dicData valueForKey:@"bottomsInch2"] == [NSNull null] ? 0 : [[dicData valueForKey:@"bottomsInch2"] intValue];
        ticket.obsGrav = [self getStringFromDictionry:dicData WithKey:@"obsGrav"];
        ticket.obsTemp = [dicData valueForKey:@"obsTemp"] == [NSNull null] ? 0 : [[dicData valueForKey:@"obsTemp"] intValue];
        ticket.bsw = [self getStringFromDictionry:dicData WithKey:@"bsw"];
        ticket.grossVol = [self getStringFromDictionry:dicData WithKey:@"grossVol"];
        ticket.netVol = [self getStringFromDictionry:dicData WithKey:@"netVol"];
        ticket.timeOn = [dicData valueForKey:@"timeOn"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"timeOn"]];
        ticket.timeOff = [dicData valueForKey:@"timeOff"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"timeOff"]];
        ticket.carrier = [self getStringFromDictionry:dicData WithKey:@"carrier"];
        ticket.driver = [self getStringFromDictionry:dicData WithKey:@"driver"];
        ticket.comments = [self getStringFromDictionry:dicData WithKey:@"comments"];
        ticket.glMonth = [dicData valueForKey:@"glMonth"] == [NSNull null] ? 0 : [[dicData valueForKey:@"glMonth"] intValue];
        ticket.glYear = [dicData valueForKey:@"glYear"] == [NSNull null] ? 0 : [[dicData valueForKey:@"glYear"] intValue];
        ticket.ticketOption = [dicData valueForKey:@"ticketOption"] == [NSNull null] ? 0 : [[dicData valueForKey:@"ticketOption"] intValue];
        ticket.userid = [dicData valueForKey:@"userid"] == [NSNull null] ? 0 : [[dicData valueForKey:@"userid"] intValue];
        
        if ([dicData valueForKey:@"ticketImage"] == [NSNull null]) {
            ticket.ticketImage = nil;
        } else {
            ticket.ticketImage = [dicData valueForKey:@"ticketImage"];
        }
        
        ticket.deleted = NO;
        ticket.downloaded = YES;
        
        ticket.calcGrossVol = [self getStringFromDictionry:dicData WithKey:@"calcGrossVol"];
        ticket.calcNetVol = [self getStringFromDictionry:dicData WithKey:@"calcNetVol"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -
-(BOOL) saveListMeterProblem:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ListMeterProblem"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        
        ListMeterProblem *listMeterProblem = [NSEntityDescription insertNewObjectForEntityForName:@"ListMeterProblem" inManagedObjectContext:context];
        
        // set data
        listMeterProblem.reason = [dicData valueForKey:@"reason"];
        listMeterProblem.reasonCode = [dicData valueForKey:@"reasonCode"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveAllMeters:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Meters"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        Meters *meters = [NSEntityDescription insertNewObjectForEntityForName:@"Meters" inManagedObjectContext:context];
        
        // set data
        meters.meterID = [[dicData valueForKey:@"meterID"] intValue];
        meters.meterLease = [dicData valueForKey:@"meterLease"];
        meters.meterWell = [dicData valueForKey:@"meterWell"] == [NSNull null] ? nil : [dicData valueForKey:@"meterWell"];
        meters.meterName = [dicData valueForKey:@"meterName"];
        meters.active = [[dicData valueForKey:@"active"] boolValue];
        meters.meterType = [dicData valueForKey:@"meterType"];
        meters.waterMeterID = [dicData valueForKey:@"waterMeterID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"waterMeterID"] intValue];
        meters.gasMeterID = [dicData valueForKey:@"gasMeterID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"gasMeterID"] intValue];
        meters.appName = [dicData valueForKey:@"appName"] == [NSNull null] ? nil : [dicData valueForKey:@"appName"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}


-(BOOL) saveAllGasMeterData:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [GasMeterData fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    for (NSDictionary *dicData in arrData) {
        
        int dataID = [[dicData valueForKey:@"dataID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"dataID == %d", dataID];
        fetchRequest = [GasMeterData fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrGasMeterData = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrGasMeterData.count > 0) {
            return YES;
        }
        
        GasMeterData *gasMeterData = [NSEntityDescription insertNewObjectForEntityForName:@"GasMeterData" inManagedObjectContext:context];
        
        // set data
        gasMeterData.dataID = dataID;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        
        NSDate *date = [dateFormatter dateFromString:[dicData valueForKey:@"checkTime"]];
        
        gasMeterData.checkTime = date;
        gasMeterData.deviceID = [dicData valueForKey:@"deviceID"] == [NSNull null] ? nil : [dicData valueForKey:@"deviceID"];
        gasMeterData.idGasMeter = [dicData valueForKey:@"idGasMeter"] == [NSNull null] ? 0 : [[dicData valueForKey:@"idGasMeter"] intValue];
        gasMeterData.lease = [dicData valueForKey:@"lease"];
        gasMeterData.wellNumber = [dicData valueForKey:@"wellNumber"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNumber"];
        gasMeterData.meterProblem = [dicData valueForKey:@"meterProblem"] == [NSNull null] ? nil : [dicData valueForKey:@"meterProblem"];
        gasMeterData.linePressure = [dicData valueForKey:@"linePressure"] == [NSNull null] ? nil : [dicData valueForKey:@"linePressure"];
        gasMeterData.currentFlow = [dicData valueForKey:@"currentFlow"] == [NSNull null] ? nil : [dicData valueForKey:@"currentFlow"];
        gasMeterData.yesterdayFlow = [dicData valueForKey:@"yesterdayFlow"] == [NSNull null] ? nil : [dicData valueForKey:@"yesterdayFlow"];
        gasMeterData.diffPressure = [dicData valueForKey:@"diffPressure"] == [NSNull null] ? nil : [dicData valueForKey:@"diffPressure"];
        gasMeterData.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
        
        
        NSDate *entryTime = [dicData valueForKey:@"entryTime"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"entryTime"]];
        gasMeterData.entryTime = entryTime;
        gasMeterData.meterCumVol = [dicData valueForKey:@"meterCumVol"] == [NSNull null] ? nil : [dicData valueForKey:@"meterCumVol"];
        gasMeterData.userid = [dicData valueForKey:@"userid"] == [NSNull null] ? 0 : [[dicData valueForKey:@"userid"] intValue];
        
        gasMeterData.downloaded = YES;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveAllWaterMeterData:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [WaterMeterData fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    for (NSDictionary *dicData in arrData) {
        
        int wmdID = [[dicData valueForKey:@"wmdID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"wmdID == %d", wmdID];
        fetchRequest = [WaterMeterData fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrWaterMeterData = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrWaterMeterData.count > 0) {
            return YES;
        }
        
        WaterMeterData *waterMeterData = [NSEntityDescription insertNewObjectForEntityForName:@"WaterMeterData" inManagedObjectContext:context];
        
        // set data
        waterMeterData.wmdID = wmdID;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:[dicData valueForKey:@"checkTime"]];
        
        waterMeterData.checkTime = date;
        waterMeterData.deviceID = [dicData valueForKey:@"deviceID"] == [NSNull null] ? nil : [dicData valueForKey:@"deviceID"];
        waterMeterData.lease = [dicData valueForKey:@"lease"];
        waterMeterData.meterNum = [dicData valueForKey:@"meterNum"] == [NSNull null] ? 0 : [[dicData valueForKey:@"meterNum"] intValue];
        waterMeterData.location = [dicData valueForKey:@"location"] == [NSNull null] ? nil : [dicData valueForKey:@"location"];
        waterMeterData.meterProblem = [dicData valueForKey:@"meterProblem"] == [NSNull null] ? nil : [dicData valueForKey:@"meterProblem"];
        waterMeterData.totalVolume = [dicData valueForKey:@"totalVolume"] == [NSNull null] ? nil : [dicData valueForKey:@"totalVolume"];
        waterMeterData.currentFlow = [dicData valueForKey:@"currentFlow"] == [NSNull null] ? nil : [dicData valueForKey:@"currentFlow"];
        waterMeterData.yesterdayFlow = [dicData valueForKey:@"yesterdayFlow"] == [NSNull null] ? nil : [dicData valueForKey:@"yesterdayFlow"];
        waterMeterData.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
        waterMeterData.netFlow = [dicData valueForKey:@"netFlow"] == [NSNull null] ? nil : [dicData valueForKey:@"netFlow"];
        waterMeterData.resetVolume = [dicData valueForKey:@"resetVolume"] == [NSNull null] ? nil : [dicData valueForKey:@"resetVolume"];
        
        NSDate *entryTime = [dicData valueForKey:@"entryTime"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"entryTime"]];
        waterMeterData.entryTime = entryTime;
        
        waterMeterData.vol24Hr = [dicData valueForKey:@"24HrVol"] == [NSNull null] ? nil : [dicData valueForKey:@"24HrVol"];
        waterMeterData.time24Hr = [dicData valueForKey:@"24HrTime"] == [NSNull null] ? nil : [dicData valueForKey:@"24HrTime"];
        waterMeterData.userid = [dicData valueForKey:@"userid"] == [NSNull null] ? 0 : [[dicData valueForKey:@"userid"] intValue];
        
        waterMeterData.downloaded = YES;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -
-(BOOL) saveListWellProblem:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ListWellProblem"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        
        ListWellProblem *listWellProblem = [NSEntityDescription insertNewObjectForEntityForName:@"ListWellProblem" inManagedObjectContext:context];
        
        // set data
        listWellProblem.reason = [dicData valueForKey:@"reason"];
        listWellProblem.reasonCode = [dicData valueForKey:@"reasonCode"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveAllWellList:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WellList"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        WellList *wellList = [NSEntityDescription insertNewObjectForEntityForName:@"WellList" inManagedObjectContext:context];
        
        // set data
        wellList.wellID = [[dicData valueForKey:@"wellID"] intValue];
        wellList.lease = [dicData valueForKey:@"lease"];
        wellList.wellNumber = [dicData valueForKey:@"wellNumber"];
        wellList.grandparentPropNum = [dicData valueForKey:@"grandparentPropNum"];
        wellList.prodCat = [dicData valueForKey:@"prodCat"] == [NSNull null] ? nil : [dicData valueForKey:@"prodCat"];
        wellList.rrcLease = [dicData valueForKey:@"RRCLease"] == [NSNull null] ? nil : [dicData valueForKey:@"RRCLease"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveAllWellheadData:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [WellheadData fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    for (NSDictionary *dicData in arrData) {
        
        int dataID = [[dicData valueForKey:@"dataID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"dataID == %d", dataID];
        fetchRequest = [WellheadData fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrWellheadData.count > 0) {
            return YES;
        }
        
        WellheadData *wellheadData = [NSEntityDescription insertNewObjectForEntityForName:@"WellheadData" inManagedObjectContext:context];
        
        // set data
        wellheadData.dataID = dataID;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:[dicData valueForKey:@"checkTime"]];
        
        wellheadData.checkTime = date;
        
        wellheadData.deviceID = [dicData valueForKey:@"deviceID"] == [NSNull null] ? nil : [dicData valueForKey:@"deviceID"];
        wellheadData.userid = [dicData valueForKey:@"userid"] == [NSNull null] ? 0 : [[dicData valueForKey:@"userid"] intValue];
        wellheadData.lease = [dicData valueForKey:@"lease"];
        wellheadData.wellNumber = [dicData valueForKey:@"wellNumber"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNumber"];
        wellheadData.wellOn = [[dicData valueForKey:@"wellOn"] boolValue];
        wellheadData.wellProblem = [dicData valueForKey:@"wellProblem"] == [NSNull null] ? nil : [dicData valueForKey:@"wellProblem"];
        wellheadData.prodType = [dicData valueForKey:@"prodType"] == [NSNull null] ? nil : [dicData valueForKey:@"prodType"];
        wellheadData.pound = [dicData valueForKey:@"pound"] == [NSNull null] ? nil : [dicData valueForKey:@"pound"];
        wellheadData.spm = [dicData valueForKey:@"spm"] == [NSNull null] ? nil : [dicData valueForKey:@"spm"];
        wellheadData.pumpSize = [dicData valueForKey:@"pumpSize"] == [NSNull null] ? nil : [dicData valueForKey:@"pumpSize"];
        wellheadData.strokeSize = [dicData valueForKey:@"strokeSize"] == [NSNull null] ? nil : [dicData valueForKey:@"strokeSize"];
        wellheadData.choke = [dicData valueForKey:@"choke"] == [NSNull null] ? nil : [dicData valueForKey:@"choke"];
        wellheadData.casingPressure = [dicData valueForKey:@"casingPressure"] == [NSNull null] ? nil : [dicData valueForKey:@"casingPressure"];
        wellheadData.bradenheadPressure = [dicData valueForKey:@"bradenheadPressure"] == [NSNull null] ? nil : [dicData valueForKey:@"bradenheadPressure"];
        wellheadData.tubingPressure = [dicData valueForKey:@"tubingPressure"] == [NSNull null] ? nil : [dicData valueForKey:@"tubingPressure"];
        wellheadData.emulsionCut = [dicData valueForKey:@"emulsionCut"] == [NSNull null] ? nil : [dicData valueForKey:@"emulsionCut"];
        wellheadData.oilCut = [dicData valueForKey:@"oilCut"] == [NSNull null] ? nil : [dicData valueForKey:@"oilCut"];
        wellheadData.waterCut = [dicData valueForKey:@"waterCut"] == [NSNull null] ? nil : [dicData valueForKey:@"waterCut"];
        
        wellheadData.timeOn = [dicData valueForKey:@"timeOn"] == [NSNull null] ? nil : [dicData valueForKey:@"timeOn"];
        wellheadData.timeOff = [dicData valueForKey:@"timeOff"] == [NSNull null] ? nil : [dicData valueForKey:@"timeOff"];
        wellheadData.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
        
        NSDate *entryTime = [dicData valueForKey:@"entryTime"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"entryTime"]];
        wellheadData.entryTime = entryTime;
        wellheadData.statusArrival = [[dicData valueForKey:@"statusArrival"] boolValue];
        wellheadData.statusDepart = [[dicData valueForKey:@"statusDepart"] boolValue];
        wellheadData.espHz = [dicData valueForKey:@"espHz"] == [NSNull null] ? nil : [dicData valueForKey:@"espHz"];
        wellheadData.espAmp = [dicData valueForKey:@"espAmp"] == [NSNull null] ? nil : [dicData valueForKey:@"espAmp"];
        
        wellheadData.downloaded = YES;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - WBD
-(BOOL) saveWBDCasingTubing:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WBDCasingTubing"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        WBDCasingTubing *casingTubing = [NSEntityDescription insertNewObjectForEntityForName:@"WBDCasingTubing" inManagedObjectContext:context];
        
        // set RigReports data
        casingTubing.wbCasingTubingID = [[dicData valueForKey:@"wbCasingTubingID"] intValue];
        casingTubing.lease = [dicData valueForKey:@"lease"] == [NSNull null] ? nil : [dicData valueForKey:@"lease"];
        casingTubing.wellNum = [dicData valueForKey:@"wellNum"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNum"];
        casingTubing.segmentID = [dicData valueForKey:@"segmentID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"segmentID"] intValue];
        casingTubing.segmentOrder = [dicData valueForKey:@"segmentOrder"] == [NSNull null] ? 0 : [[dicData valueForKey:@"segmentOrder"] intValue];
        
        casingTubing.wbQty = [dicData valueForKey:@"wbQty"] == [NSNull null] ? 0 : [[dicData valueForKey:@"wbQty"] intValue];
        casingTubing.wbDateIn = [dicData valueForKey:@"wbDateIn"] == [NSNull null] ? nil : [df dateFromString:[dicData valueForKey:@"wbDateIn"]];
        
        casingTubing.invQty = [dicData valueForKey:@"invQty"] == [NSNull null] ? 0 : [[dicData valueForKey:@"invQty"] intValue];
        casingTubing.wbCasing = [dicData valueForKey:@"wbCasing"] == [NSNull null] ? NO : [[dicData valueForKey:@"wbCasing"] boolValue];
        casingTubing.wbTubing = [dicData valueForKey:@"wbTubing"] == [NSNull null] ? NO : [[dicData valueForKey:@"wbTubing"] boolValue];
        
        casingTubing.length = [dicData valueForKey:@"length"] == [NSNull null] ? nil : [dicData valueForKey:@"length"];
        casingTubing.extSizeID = [dicData valueForKey:@"extSizeID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"extSizeID"] intValue];
        casingTubing.extSize = [dicData valueForKey:@"extSize"] == [NSNull null] ? nil : [self removeQuotes:[dicData valueForKey:@"extSize"]];
        casingTubing.weight = [dicData valueForKey:@"weight"] == [NSNull null] ? nil : [dicData valueForKey:@"weight"];
        casingTubing.coating = [dicData valueForKey:@"coating"] == [NSNull null] ? nil : [dicData valueForKey:@"coating"];
        casingTubing.threadType = [dicData valueForKey:@"threadType"] == [NSNull null] ? nil : [dicData valueForKey:@"threadType"];
        casingTubing.tubularType = [dicData valueForKey:@"tubularType"] == [NSNull null] ? nil : [dicData valueForKey:@"tubularType"];
        casingTubing.invLinker = [dicData valueForKey:@"invLinker"] == [NSNull null] ? nil : [dicData valueForKey:@"invLinker"];
        casingTubing.startDepth = [dicData valueForKey:@"startDepth"] == [NSNull null] ? 0 : [[dicData valueForKey:@"startDepth"] intValue];
        casingTubing.endDepth = [dicData valueForKey:@"endDepth"] == [NSNull null] ? 0 : [[dicData valueForKey:@"endDepth"] intValue];
        casingTubing.cmtSxQty = [dicData valueForKey:@"cmtSxQty"] == [NSNull null] ? 0 : [[dicData valueForKey:@"cmtSxQty"] intValue];
        casingTubing.cmtVolSlurry = [dicData valueForKey:@"cmtVolSlurry"] == [NSNull null] ? 0 : [[dicData valueForKey:@"cmtVolSlurry"] intValue];
        casingTubing.cmtDesc = [dicData valueForKey:@"cmtDesc"] == [NSNull null] ? nil : [dicData valueForKey:@"cmtDesc"];
        casingTubing.cmtToC = [dicData valueForKey:@"cmtToC"] == [NSNull null] ? 0 : [[dicData valueForKey:@"cmtToC"] intValue];
        casingTubing.cmtCalcToC = [dicData valueForKey:@"cmtCalcToC"] == [NSNull null] ? 0 : [[dicData valueForKey:@"cmtCalcToC"] intValue];
        casingTubing.cmtVerifiedToC = [dicData valueForKey:@"cmtVerifiedToC"] == [NSNull null] ? 0 : [[dicData valueForKey:@"cmtVerifiedToC"] intValue];
        casingTubing.cmtVerificationType = [dicData valueForKey:@"cmtVerificationType"] == [NSNull null] ? nil : [dicData valueForKey:@"cmtVerificationType"];
        
        casingTubing.infoSource = [dicData valueForKey:@"infoSource"] == [NSNull null] ? 0 : [[dicData valueForKey:@"infoSource"] intValue];
        casingTubing.infoDate = [dicData valueForKey:@"infoDate"] == [NSNull null] ? nil : [df dateFromString:[dicData valueForKey:@"infoDate"]];
        
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}



-(NSString*) removeQuotes:(NSString*)extSize
{
    if (extSize.length > 3) {
        NSString *first = [extSize substringWithRange:NSMakeRange(0, 1)];
        NSString *last = [extSize substringWithRange:NSMakeRange(extSize.length-3, 3)];
        if ([first isEqual:@"\""] && [last isEqual:@"\"\"\""]) {
            extSize = [extSize substringWithRange:NSMakeRange(1, extSize.length - 3)];
        }
    }
    
    return extSize;
}

// max MD values grouped by MinHoleSize
-(BOOL) saveWBDSurveys:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WBDSurveys"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        WBDSurveys *surveys = [NSEntityDescription insertNewObjectForEntityForName:@"WBDSurveys" inManagedObjectContext:context];
        
        surveys.surveyPointID = [[dicData valueForKey:@"surveyPointID"] intValue];
        surveys.lease = [dicData valueForKey:@"lease"] == [NSNull null] ? nil : [dicData valueForKey:@"lease"];
        surveys.wellNum = [dicData valueForKey:@"wellNum"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNum"];
        surveys.surveyPointDate = [dicData valueForKey:@"surveyPointDate"] == [NSNull null] ? nil : [df dateFromString:[dicData valueForKey:@"surveyPointDate"]];
        surveys.minHoleSize = [dicData valueForKey:@"minHoleSize"] == [NSNull null] ? 0 : [[dicData valueForKey:@"minHoleSize"] floatValue];
        surveys.md = [dicData valueForKey:@"md"] == [NSNull null] ? 0 : [[dicData valueForKey:@"md"] floatValue];
        surveys.inclination = [dicData valueForKey:@"inclination"] == [NSNull null] ? 0 : [[dicData valueForKey:@"inclination"] floatValue];
        surveys.trueAzimuth = [dicData valueForKey:@"trueAzimuth"] == [NSNull null] ? 0 : [[dicData valueForKey:@"trueAzimuth"] floatValue];
        surveys.tvd = [dicData valueForKey:@"tvd"] == [NSNull null] ? 0 : [[dicData valueForKey:@"tvd"] floatValue];
        surveys.dogLegSeverity = [dicData valueForKey:@"dogLegSeverity"] == [NSNull null] ? 0 : [[dicData valueForKey:@"dogLegSeverity"] floatValue];
        surveys.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveWBDPlugs:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WBDPlugs"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        WBDPlugs *plug = [NSEntityDescription insertNewObjectForEntityForName:@"WBDPlugs" inManagedObjectContext:context];
        
        plug.plugID = [[dicData valueForKey:@"plugID"] intValue];
        plug.lease = [dicData valueForKey:@"lease"] == [NSNull null] ? nil : [dicData valueForKey:@"lease"];
        plug.wellNum = [dicData valueForKey:@"wellNum"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNum"];
        plug.plugType = [dicData valueForKey:@"plugType"] == [NSNull null] ? nil : [dicData valueForKey:@"plugType"];
        plug.plugModel = [dicData valueForKey:@"plugModel"] == [NSNull null] ? nil : [dicData valueForKey:@"plugModel"];
        plug.plugDepth = [dicData valueForKey:@"plugDepth"] == [NSNull null] ? 0 : [[dicData valueForKey:@"plugDepth"] intValue];
        plug.plugDateIn = [dicData valueForKey:@"plugDateIn"] == [NSNull null] ? nil : [df dateFromString:[dicData valueForKey:@"plugDateIn"]];
        plug.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
        
        plug.infoSource = [dicData valueForKey:@"infoSource"] == [NSNull null] ? 0 : [[dicData valueForKey:@"infoSource"] intValue];
        plug.infoNotes = [dicData valueForKey:@"infoNotes"] == [NSNull null] ? nil : [dicData valueForKey:@"infoNotes"];
        plug.infoDate = [dicData valueForKey:@"infoDate"] == [NSNull null] ? nil : [df dateFromString:[dicData valueForKey:@"infoDate"]];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}


-(BOOL) saveWBDRods:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WBDRods"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        WBDRods *rod = [NSEntityDescription insertNewObjectForEntityForName:@"WBDRods" inManagedObjectContext:context];
        
        rod.wbRodsID = [[dicData valueForKey:@"wbRodsID"] intValue];
        rod.lease = [dicData valueForKey:@"lease"] == [NSNull null] ? nil : [dicData valueForKey:@"lease"];
        rod.wellNum = [dicData valueForKey:@"wellNum"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNum"];
        rod.segmentID = [dicData valueForKey:@"segmentID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"segmentID"] intValue];
        rod.segmentOrder = [dicData valueForKey:@"segmentOrder"] == [NSNull null] ? 0 : [[dicData valueForKey:@"segmentOrder"] intValue];
        
        rod.wbRodsQty = [dicData valueForKey:@"wbRodsQty"] == [NSNull null] ? 0 : [[dicData valueForKey:@"wbRodsQty"] intValue];
        rod.wbRodsDesc = [dicData valueForKey:@"wbRodsDesc"] == [NSNull null] ? nil : [dicData valueForKey:@"wbRodsDesc"];
        rod.wbRodsDtIn = [self getDateFromString:[dicData valueForKey:@"wbRodsDtIn"]];
        
        rod.invRodsQty = [dicData valueForKey:@"invRodsQty"] == [NSNull null] ? 0 : [[dicData valueForKey:@"invRodsQty"] intValue];
        rod.length = [dicData valueForKey:@"length"] == [NSNull null] ? nil : [dicData valueForKey:@"length"];
        rod.extSizeID = [dicData valueForKey:@"extSizeID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"extSizeID"] intValue];
        rod.extSize = [dicData valueForKey:@"extSize"] == [NSNull null] ? nil : [self removeQuotes:[dicData valueForKey:@"extSize"]];
        rod.couplingCode = [dicData valueForKey:@"couplingCode"] == [NSNull null] ? nil : [dicData valueForKey:@"couplingCode"];
        rod.rodType = [dicData valueForKey:@"rodType"] == [NSNull null] ? nil : [dicData valueForKey:@"rodType"];
        rod.infoSource = [dicData valueForKey:@"infoSource"] == [NSNull null] ? 0 : [[dicData valueForKey:@"infoSource"] intValue];

        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}


-(BOOL) saveWBDInfo:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WBDInfo"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        WBDInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"WBDInfo" inManagedObjectContext:context];
        
        info.infoID = [[dicData valueForKey:@"infoID"] intValue];
        info.lease = [dicData valueForKey:@"lease"] == [NSNull null] ? nil : [dicData valueForKey:@"lease"];
        info.wellNum = [dicData valueForKey:@"wellNum"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNum"];
        info.tblName = [dicData valueForKey:@"tblName"] == [NSNull null] ? nil : [dicData valueForKey:@"tblName"];
        info.recordID = [dicData valueForKey:@"recordID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"recordID"] intValue];
        info.infoSource = [dicData valueForKey:@"infoSource"] == [NSNull null] ? 0 : [[dicData valueForKey:@"infoSource"] intValue];
        info.infoSourceType = [dicData valueForKey:@"infoSourceType"] == [NSNull null] ? nil : [dicData valueForKey:@"infoSourceType"];
        info.infoDate = [dicData valueForKey:@"infoDate"] == [NSNull null] ? nil : [df dateFromString:[dicData valueForKey:@"infoDate"]];
        info.infoNotes = [dicData valueForKey:@"infoNotes"] == [NSNull null] ? nil : [dicData valueForKey:@"infoNotes"];        
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveWBDInfoSource:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WBDInfoSource"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        WBDInfoSource *infoSource = [NSEntityDescription insertNewObjectForEntityForName:@"WBDInfoSource" inManagedObjectContext:context];
        
        infoSource.sourceID = [[dicData valueForKey:@"sourceID"] intValue];
        infoSource.infoSourceType = [dicData valueForKey:@"infoSourceType"] == [NSNull null] ? nil : [dicData valueForKey:@"infoSourceType"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveWBDPumps:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WBDPumps"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        WBDPumps *pump = [NSEntityDescription insertNewObjectForEntityForName:@"WBDPumps" inManagedObjectContext:context];
        
        // set RigReports data
        pump.pumpID = [[dicData valueForKey:@"sourceID"] intValue];
        pump.lease = [dicData valueForKey:@"lease"] == [NSNull null] ? nil : [dicData valueForKey:@"lease"];
        pump.wellNum = [dicData valueForKey:@"wellNum"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNum"];
        pump.pumpTypeName = [dicData valueForKey:@"pumpTypeName"] == [NSNull null] ? nil : [dicData valueForKey:@"pumpTypeName"];
        pump.pumpDesc = [dicData valueForKey:@"pumpDesc"] == [NSNull null] ? nil : [dicData valueForKey:@"pumpDesc"];
        pump.pumpDateIn = [dicData valueForKey:@"pumpDateIn"] == [NSNull null] ? nil : [df dateFromString:[dicData valueForKey:@"pumpDateIn"]];
        
        pump.infoSource = [dicData valueForKey:@"infoSource"] == [NSNull null] ? 0 : [[dicData valueForKey:@"infoSource"] intValue];
        pump.infoNotes = [dicData valueForKey:@"infoNotes"] == [NSNull null] ? nil : [dicData valueForKey:@"infoNotes"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}



-(BOOL) saveAllWBDTreatments:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WBDTreatments"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        WBDTreatments *treatments = [NSEntityDescription insertNewObjectForEntityForName:@"WBDTreatments" inManagedObjectContext:context];
        
        // set data
        treatments.treatmentID = [[dicData valueForKey:@"treatmentID"] intValue];
        treatments.lease = [dicData valueForKey:@"lease"] == [NSNull null] ? nil : [dicData valueForKey:@"lease"];
        treatments.wellNum = [dicData valueForKey:@"wellNum"];
        
        treatments.treatmentDate = [dicData valueForKey:@"treatmentDate"] == [NSNull null] ? nil : [dicData valueForKey:@"treatmentDate"];
        treatments.treatmentDesc = [dicData valueForKey:@"treatmentDesc"] == [NSNull null] ? nil : [dicData valueForKey:@"treatmentDesc"];
        treatments.treatmentNotes = [dicData valueForKey:@"treatmentNotes"] == [NSNull null] ? nil : [dicData valueForKey:@"treatmentNotes"];
        
        treatments.downloaded = YES;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}


-(BOOL) saveAllWBDPerfs:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WBDPerfs"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        WBDPerfs *perfs = [NSEntityDescription insertNewObjectForEntityForName:@"WBDPerfs" inManagedObjectContext:context];
        
        // set data
        perfs.perfID = [[dicData valueForKey:@"perfID"] intValue];
        perfs.lease = [dicData valueForKey:@"lease"] == [NSNull null] ? nil : [dicData valueForKey:@"lease"];
        perfs.wellNum = [dicData valueForKey:@"wellNum"];
        perfs.perfZoneStart = [dicData valueForKey:@"perfZoneStart"] == [NSNull null] ? 0 : [[dicData valueForKey:@"perfZoneStart"] intValue];
        perfs.perfZoneEnd = [dicData valueForKey:@"perfZoneEnd"] == [NSNull null] ? 0 : [[dicData valueForKey:@"perfZoneEnd"] intValue];
        
        if ([dicData valueForKey:@"perfDate"] != [NSNull null]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            NSDate *perfDate = [dateFormatter dateFromString:[dicData valueForKey:@"perfDate"]];
            
            perfs.perfDate = perfDate;
        } else {
            perfs.perfDate = nil;
        }
        
        perfs.perfDesc = [dicData valueForKey:@"perfDesc"] == [NSNull null] ? nil : [dicData valueForKey:@"perfDesc"];
        perfs.wellPerf = [dicData valueForKey:@"wellPerf"] == [NSNull null] ? NO : [[dicData valueForKey:@"wellPerf"] boolValue];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}


#pragma mark -
-(BOOL) saveAllInvoicesData:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    fetchRequest = [InvoicesDetail fetchRequest];
    predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    [fetchRequest setPredicate:predicate];
    deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    [context executeRequest:deleteReq error:&error];
    
    fetchRequest = [InvoicesPersonnel fetchRequest];
    predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    [fetchRequest setPredicate:predicate];
    deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    [context executeRequest:deleteReq error:&error];
    
    for (NSDictionary *dicData in arrData) {
        
        if ([self saveInvoices:dicData]) {
            [self saveInvoicesDetail:dicData];
            [self saveInvoicePersonnel:dicData];
        }
    }
    
    return YES;
}

//-(BOOL) saveSpecificInvoicesData:(NSArray *)arrData
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
//    NSFetchRequest *fetchRequest = [InvoicesSpec fetchRequest];
//    [fetchRequest setPredicate:predicate];
//    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
//    deleteReq.resultType = NSBatchDeleteResultTypeCount;
//
//    NSError *error = nil;
//    [context executeRequest:deleteReq error:&error];
//
////    fetchRequest = [InvoicesDetail fetchRequest];
////    predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
////    [fetchRequest setPredicate:predicate];
////    deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
////    [context executeRequest:deleteReq error:&error];
////
////    fetchRequest = [InvoicesPersonnel fetchRequest];
////    predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
////    [fetchRequest setPredicate:predicate];
////    deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
////    [context executeRequest:deleteReq error:&error];
//
//    for (NSDictionary *dicData in arrData) {
//
//        if ([self saveInvoicesSpec:dicData]) {
////            [self saveInvoicesDetail:dicData];
////            [self saveInvoicePersonnel:dicData];
//        }
//    }
//
//    return YES;
//}

- (float)getTotalCostWithLease:(NSString *)lease wellNum:(NSString *)wellNumber {
    float totalCost = 0.0f;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"RigReports" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    NSSortDescriptor *sortDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"entryDate" ascending:NO];
    NSArray *sortDateDescriptors = [[NSArray alloc] initWithObjects:sortDateDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDateDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@", lease, wellNumber];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrRigData = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrRigData.count > 0) {
        RigReports *rig = arrRigData[0];
        totalCost = [rig.totalCost floatValue];
//        return totalCost;
    }
    
    entityModel = [NSEntityDescription entityForName:@"Invoices" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    sortDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"invoiceDate" ascending:NO];
    sortDateDescriptors = [[NSArray alloc] initWithObjects:sortDateDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDateDescriptors];
    
    predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNumber == %@", lease, wellNumber];
    [fetchRequest setPredicate:predicate];
    
    NSArray *arrInvoices = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrInvoices.count > 0) {
        for (Invoices *inv in arrInvoices) {
            NSArray *arrInvoiceDetails = [self getInvoiceDetail:inv.invoiceID appID:inv.invoiceAppID];
            BOOL isSupervisor = NO;
            for (InvoicesDetail *inv_detail in arrInvoiceDetails) {
                if (inv_detail.account == 11 || inv_detail.account == 14) {
                    isSupervisor = YES;
                    break;
                }
            }
            if (isSupervisor) {
                totalCost += [inv.totalCost floatValue];
                break;
            }
        }
        return totalCost;
    }
    return totalCost;
}

-(BOOL) saveInvoices:(NSDictionary*)dicData
{
    int invoiceID = [[dicData valueForKey:@"invoiceID"] intValue];
    NSString *invoiceAppID = [dicData valueForKey:@"invoiceAppID"] == [NSNull null] ? nil : [dicData valueForKey:@"invoiceAppID"];
    NSString *lease = [dicData valueForKey:@"lease"];
    NSString *wellNumber = [dicData valueForKey:@"wellNumber"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNumber"];
    NSString *dateString = [dicData valueForKey:@"invoiceDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Invoices" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d", invoiceID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrInvoicesData = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrInvoicesData.count > 0) {
        return YES;
    }
    
    
    Invoices *invoice = [NSEntityDescription insertNewObjectForEntityForName:@"Invoices" inManagedObjectContext:context];
    
    // set data
    invoice.invoiceID = [[dicData valueForKey:@"invoiceID"] intValue];
    invoice.invoiceAppID = invoiceAppID;
    
    invoice.invoiceDate = date;
    
    invoice.lease = lease;
    invoice.wellNumber = wellNumber;
    invoice.route = [dicData valueForKey:@"route"] == [NSNull null] ? nil : [dicData valueForKey:@"route"];
    invoice.opCompany = [dicData valueForKey:@"opCompany"] == [NSNull null] ? nil : [dicData valueForKey:@"opCompany"];;
    invoice.ownCompany = [dicData valueForKey:@"ownCompany"] == [NSNull null] ? nil : [dicData valueForKey:@"ownCompany"];
    invoice.dailyCost = [dicData valueForKey:@"dailyCost"] == [NSNull null] ? nil : [dicData valueForKey:@"dailyCost"];
    invoice.totalCost = [dicData valueForKey:@"totalCost"] == [NSNull null] ? nil : [dicData valueForKey:@"totalCost"];
    invoice.export = [dicData valueForKey:@"export"] == [NSNull null] ? NO : [[dicData valueForKey:@"export"] boolValue];
    
    invoice.approval0 = [dicData valueForKey:@"approval0"] == [NSNull null] ? NO : [[dicData valueForKey:@"approval0"] boolValue];
    invoice.approval1 = [dicData valueForKey:@"approval1"] == [NSNull null] ? NO : [[dicData valueForKey:@"approval1"] boolValue];
    invoice.approval2 = [dicData valueForKey:@"approval2"] == [NSNull null] ? NO : [[dicData valueForKey:@"approval2"] boolValue];
    invoice.outsideBill = [dicData valueForKey:@"outsideBill"] == [NSNull null] ? NO : [[dicData valueForKey:@"outsideBill"] boolValue];
    invoice.noBill = [dicData valueForKey:@"noBill"] == [NSNull null] ? NO : [[dicData valueForKey:@"noBill"] boolValue];
    
    invoice.approvalDt0 = [dicData valueForKey:@"approvalDt0"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"approvalDt0"]];
    invoice.approvalDt1 = [dicData valueForKey:@"approvalDt1"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"approvalDt1"]];
    invoice.approvalDt2 = [dicData valueForKey:@"approvalDt2"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"approvalDt2"]];
    invoice.outsideBillDt = [dicData valueForKey:@"outsideBillDt"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"outsideBillDt"]];
    invoice.noBillDt = [dicData valueForKey:@"noBillDt"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"noBillDt"]];
    
    invoice.app0Emp = [dicData valueForKey:@"app0Emp"] == [NSNull null] ? nil : [dicData valueForKey:@"app0Emp"];
    invoice.app1Emp = [dicData valueForKey:@"app1Emp"] == [NSNull null] ? nil : [dicData valueForKey:@"app1Emp"];
    invoice.app2Emp = [dicData valueForKey:@"app2Emp"] == [NSNull null] ? nil : [dicData valueForKey:@"app2Emp"];
    invoice.outsideBillEmp = [dicData valueForKey:@"outsideBillEmp"] == [NSNull null] ? nil : [dicData valueForKey:@"outsideBillEmp"];
    invoice.noBillEmp = [dicData valueForKey:@"noBillEmp"] == [NSNull null] ? nil : [dicData valueForKey:@"noBillEmp"];
    
    invoice.deviceID = [dicData valueForKey:@"deviceID"] == [NSNull null] ? nil : [dicData valueForKey:@"deviceID"];
    invoice.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
    invoice.userid = [dicData valueForKey:@"userid"] == [NSNull null] ? 0 : [[dicData valueForKey:@"userid"] intValue];
    
    invoice.tubingComments = [dicData valueForKey:@"tubingComments"] == [NSNull null] ? nil : [dicData valueForKey:@"tubingComments"];
    invoice.rodComments = [dicData valueForKey:@"rodComments"] == [NSNull null] ? nil : [dicData valueForKey:@"rodComments"];
    invoice.company = [dicData valueForKey:@"company"] == [NSNull null] ? nil : [dicData valueForKey:@"company"];
    if ([dicData valueForKey:@"invoiceImages"] == [NSNull null] || [dicData valueForKey:@"invoiceImages"] == nil) {
        invoice.invoiceImages = nil;
    } else {
        NSArray *tmpAry = [dicData valueForKey:@"invoiceImages"];
        NSMutableArray *valueToSet = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in tmpAry) {
            [valueToSet addObject:dic];
        }
        invoice.invoiceImages = [valueToSet copy];
    }
    invoice.downloaded = YES;
    invoice.deleted = NO;
    
    if (![context save:&error])
    {
        NSLog(@"Error saving database");
        return NO;
    }
    
    return YES;
}

//-(BOOL) saveInvoicesSpec:(NSDictionary*)dicData
//{
//    int invoiceID = [[dicData valueForKey:@"invoiceID"] intValue];
//    NSString *invoiceAppID = [dicData valueForKey:@"invoiceAppID"] == [NSNull null] ? nil : [dicData valueForKey:@"invoiceAppID"];
//    NSString *lease = [dicData valueForKey:@"lease"];
//    NSString *wellNumber = [dicData valueForKey:@"wellNumber"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNumber"];
//    NSString *dateString = [dicData valueForKey:@"invoiceDate"];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
//    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    NSDate *date = [dateFormatter dateFromString:dateString];
//
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"InvoicesSpec" inManagedObjectContext:context];
//    [fetchRequest setEntity:entityModel];
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d", invoiceID];
//    [fetchRequest setPredicate:predicate];
//
//    NSError *error;
//    NSArray *arrInvoicesData = [context executeFetchRequest:fetchRequest error:&error];
//    if (!error && arrInvoicesData.count > 0) {
//        return YES;
//    }
//
//
//    Invoices *invoice = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicesSpec" inManagedObjectContext:context];
//
//    // set data
//    invoice.invoiceID = [[dicData valueForKey:@"invoiceID"] intValue];
//    invoice.invoiceAppID = invoiceAppID;
//
//    invoice.invoiceDate = date;
//
//    invoice.lease = lease;
//    invoice.wellNumber = wellNumber;
//    invoice.route = [dicData valueForKey:@"route"] == [NSNull null] ? nil : [dicData valueForKey:@"route"];
//    invoice.opCompany = [dicData valueForKey:@"opCompany"] == [NSNull null] ? nil : [dicData valueForKey:@"opCompany"];;
//    invoice.ownCompany = [dicData valueForKey:@"ownCompany"] == [NSNull null] ? nil : [dicData valueForKey:@"ownCompany"];
//
//    invoice.export = [dicData valueForKey:@"export"] == [NSNull null] ? NO : [[dicData valueForKey:@"export"] boolValue];
//
//    invoice.approval0 = [dicData valueForKey:@"approval0"] == [NSNull null] ? NO : [[dicData valueForKey:@"approval0"] boolValue];
//    invoice.approval1 = [dicData valueForKey:@"approval1"] == [NSNull null] ? NO : [[dicData valueForKey:@"approval1"] boolValue];
//    invoice.approval2 = [dicData valueForKey:@"approval2"] == [NSNull null] ? NO : [[dicData valueForKey:@"approval2"] boolValue];
//    invoice.outsideBill = [dicData valueForKey:@"outsideBill"] == [NSNull null] ? NO : [[dicData valueForKey:@"outsideBill"] boolValue];
//    invoice.noBill = [dicData valueForKey:@"noBill"] == [NSNull null] ? NO : [[dicData valueForKey:@"noBill"] boolValue];
//
//    invoice.approvalDt0 = [dicData valueForKey:@"approvalDt0"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"approvalDt0"]];
//    invoice.approvalDt1 = [dicData valueForKey:@"approvalDt1"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"approvalDt1"]];
//    invoice.approvalDt2 = [dicData valueForKey:@"approvalDt2"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"approvalDt2"]];
//    invoice.outsideBillDt = [dicData valueForKey:@"outsideBillDt"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"outsideBillDt"]];
//    invoice.noBillDt = [dicData valueForKey:@"noBillDt"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"noBillDt"]];
//
//    invoice.app0Emp = [dicData valueForKey:@"app0Emp"] == [NSNull null] ? nil : [dicData valueForKey:@"app0Emp"];
//    invoice.app1Emp = [dicData valueForKey:@"app1Emp"] == [NSNull null] ? nil : [dicData valueForKey:@"app1Emp"];
//    invoice.app2Emp = [dicData valueForKey:@"app2Emp"] == [NSNull null] ? nil : [dicData valueForKey:@"app2Emp"];
//    invoice.outsideBillEmp = [dicData valueForKey:@"outsideBillEmp"] == [NSNull null] ? nil : [dicData valueForKey:@"outsideBillEmp"];
//    invoice.noBillEmp = [dicData valueForKey:@"noBillEmp"] == [NSNull null] ? nil : [dicData valueForKey:@"noBillEmp"];
//
//    invoice.deviceID = [dicData valueForKey:@"deviceID"] == [NSNull null] ? nil : [dicData valueForKey:@"deviceID"];
//    invoice.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
//    invoice.userid = [dicData valueForKey:@"userid"] == [NSNull null] ? 0 : [[dicData valueForKey:@"userid"] intValue];
//
//    invoice.tubingComments = [dicData valueForKey:@"tubingComments"] == [NSNull null] ? nil : [dicData valueForKey:@"tubingComments"];
//    invoice.rodComments = [dicData valueForKey:@"rodComments"] == [NSNull null] ? nil : [dicData valueForKey:@"rodComments"];
//    invoice.company = [dicData valueForKey:@"company"] == [NSNull null] ? nil : [dicData valueForKey:@"company"];
//
//    invoice.downloaded = YES;
//    invoice.deleted = NO;
//
//    if (![context save:&error])
//    {
//        NSLog(@"Error saving database");
//        return NO;
//    }
//
//    return YES;
//}

-(BOOL) saveInvoicesDetail:(NSDictionary*)dicData
{
    int invoiceDetailID = [[dicData valueForKey:@"invoiceDetailID"] intValue];
    NSString *invoiceAppID = [dicData valueForKey:@"invoiceAppID"] == [NSNull null] ? nil : [dicData valueForKey:@"invoiceAppID"];
    int account = [[dicData valueForKey:@"account"] intValue];
    int accountSub = [[dicData valueForKey:@"accountSub"] intValue];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"InvoicesDetail" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceDetailID == %d", invoiceDetailID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrData = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrData.count > 0) {
        return YES;
    }
    
    InvoicesDetail *invoiceDetail = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicesDetail" inManagedObjectContext:context];
    
    // set data
    invoiceDetail.invoiceDetailID = invoiceDetailID;
    invoiceDetail.invoiceID = [[dicData valueForKey:@"invoiceID"] intValue];
    invoiceDetail.invoiceAppID = invoiceAppID;
    
    invoiceDetail.account = account;
    invoiceDetail.accountSub = accountSub;
    
    invoiceDetail.accountTime = [dicData valueForKey:@"accountTime"] == [NSNull null] ? nil : [dicData valueForKey:@"accountTime"];
    invoiceDetail.accountUnit = [dicData valueForKey:@"accountUnit"] == [NSNull null] ? nil : [dicData valueForKey:@"accountUnit"];
    
    invoiceDetail.deleted = NO;
    invoiceDetail.downloaded = YES;
    
    if (![context save:&error])
    {
        NSLog(@"Error saving database");
        return NO;
    }
    
    return YES;
}

-(BOOL) saveInvoicePersonnel:(NSDictionary*)dicData
{
    int invoicePersonnelID = [[dicData valueForKey:@"invoicePersonnelID"] intValue];
    NSString *invoiceAppID = [dicData valueForKey:@"invoiceAppID"] == [NSNull null] ? nil : [dicData valueForKey:@"invoiceAppID"];
    int peopleID = [[dicData valueForKey:@"peopleid"] intValue];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"InvoicesPersonnel" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoicePersonnelID == %d", invoicePersonnelID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrData = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrData.count > 0) {
        return YES;
    }
    
    InvoicesPersonnel *invoicePersonnel = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicesPersonnel" inManagedObjectContext:context];
    
    // set data
    invoicePersonnel.invoicePersonnelID = invoicePersonnelID;
    invoicePersonnel.invoiceID = [[dicData valueForKey:@"invoiceID"] intValue];
    invoicePersonnel.invoiceAppID = invoiceAppID;
    invoicePersonnel.userID = peopleID;
    
    invoicePersonnel.deleted = NO;
    invoicePersonnel.downloaded = YES;
    
    if (![context save:&error])
    {
        NSLog(@"Error saving database");
        return NO;
    }
    
    return YES;
}



#pragma mark -
-(BOOL) saveAllSchedules:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [Schedules fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    for (NSDictionary *dicData in arrData) {
        
        int scheduleID = [[dicData valueForKey:@"scheduleID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"scheduleID == %d", scheduleID];
        fetchRequest = [Schedules fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrScheduleData = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrScheduleData.count > 0) {
            return YES;
        }
        
        Schedules *schedules = [NSEntityDescription insertNewObjectForEntityForName:@"Schedules" inManagedObjectContext:context];
        
        // set data
        schedules.downloaded = YES;
        schedules.scheduleID = scheduleID;
        schedules.lease = [dicData valueForKey:@"lease"];
        schedules.wellNumber = [dicData valueForKey:@"wellNumber"] == [NSNull null] ? nil : [dicData valueForKey:@"wellNumber"];
        schedules.scheduleType = [dicData valueForKey:@"scheduleType"];
        schedules.initialPlanStartDt = [dicData valueForKey:@"initPlanStartDt"] == [NSNull null] ? nil : [self getDateFromString:[dicData valueForKey:@"initPlanStartDt"]];
        schedules.updatedPlanStartDt = [dicData valueForKey:@"updatedPlanStartDt"] == [NSNull null] ? nil : [self getDateFromString:[dicData valueForKey:@"updatedPlanStartDt"]];
        schedules.entryUserID = [dicData valueForKey:@"entryUserID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"entryUserID"] intValue];
        schedules.updatedPlanUserID = [dicData valueForKey:@"upadtedPlanUserID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"upadtedPlanUserID"] intValue];
        schedules.planStartDt = [dicData valueForKey:@"planStartDt"] == [NSNull null] ? nil : [self getDateFromString:[dicData valueForKey:@"planStartDt"]];
        schedules.actualStartDt = [dicData valueForKey:@"actualStartDt"] == [NSNull null] ? nil : [self getDateFromString:[dicData valueForKey:@"actualStartDt"]];
        schedules.actualEndDt = [dicData valueForKey:@"actualEndDt"] == [NSNull null] ? nil : [self getDateFromString:[dicData valueForKey:@"actualEndDt"]];
        schedules.actStartUserID = [dicData valueForKey:@"actStartUserID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"actStartUserID"] intValue];
        schedules.actEndUserID = [dicData valueForKey:@"actEndUserID"] == [NSNull null] ? 0 : [[dicData valueForKey:@"actEndUserID"] intValue];
        schedules.engrComments = [dicData valueForKey:@"engrComments"] == [NSNull null] ? nil : [dicData valueForKey:@"engrComments"];
        schedules.acctComments = [dicData valueForKey:@"acctComments"] == [NSNull null] ? nil : [dicData valueForKey:@"acctComments"];
        schedules.fieldComments = [dicData valueForKey:@"fieldComments"] == [NSNull null] ? nil : [dicData valueForKey:@"fieldComments"];
        schedules.criticalEndDt = [dicData valueForKey:@"criticalEndDt"] == [NSNull null] ? nil : [self getDateFromString:[dicData valueForKey:@"criticalEndDt"]];
        schedules.status = [dicData valueForKey:@"status"];
        schedules.date = [self getDateFromString:[dicData valueForKey:@"date"]];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveListAssetLocations:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ListAssetLocations"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        ListAssetLocations *listAssetLocations = [NSEntityDescription insertNewObjectForEntityForName:@"ListAssetLocations" inManagedObjectContext:context];
        
        // set data
        listAssetLocations.propNum = [dicData valueForKey:@"propNum"];
        listAssetLocations.parentPropNum = [dicData valueForKey:@"parentPropNum"];
        listAssetLocations.grandparentPropNum = [dicData valueForKey:@"grandparentPropNum"];
        listAssetLocations.codeProperty = [dicData valueForKey:@"codeProperty"];
        listAssetLocations.propType = [dicData valueForKey:@"propType"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveInvoiceAccounts:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"InvoiceAccounts"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        InvoiceAccounts *account = [NSEntityDescription insertNewObjectForEntityForName:@"InvoiceAccounts" inManagedObjectContext:context];
        
        // set data
        account.acctID = [[dicData valueForKey:@"acctID"] intValue];
        account.subAcctID = [[dicData valueForKey:@"subAcctID"] intValue];
        account.account = [dicData valueForKey:@"account"];
        account.subAccount = [dicData valueForKey:@"subaccount"] == [NSNull null] ? nil : [dicData valueForKey:@"subaccount"];
        account.subAcctTimeUnits = [dicData valueForKey:@"subacctTimeUnits"];
        account.wpExpJournal = [dicData valueForKey:@"WPExpJournal"];
        account.wpExpReference = [dicData valueForKey:@"WPExpReference"];
        account.wpExpAcct = [dicData valueForKey:@"WPExpAcct"];
        account.wpIncJournal = [dicData valueForKey:@"WPIncJournal"];
        account.wpIncReference = [dicData valueForKey:@"WPIncReference"];
        account.wpIncAcct = [dicData valueForKey:@"WPIncAcct"];
        account.wpIncSubAcct = [dicData valueForKey:@"WPIncSubAcct"];
        account.unitCost = [dicData valueForKey:@"UnitCost"];
        account.unitCostOutCharge = [dicData valueForKey:@"UnitCostOutCharge"] == [NSNull null] ? nil : [dicData valueForKey:@"UnitCostOutCharge"];
        account.outbillLookup = [dicData valueForKey:@"OutbillLookup"] == [NSNull null] ? nil : [dicData valueForKey:@"OutbillLookup"];
        
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}


#pragma mark -

- (float)getTotalCostFromRigReportsWithLease:(NSString *)lease wellNum:(NSString *)wellNumber {
    float totalCost = 0.0f;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"RigReports" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@", lease, wellNumber];
    [fetchRequest setPredicate:predicate];

    NSError *error;
    NSArray *arrRigData = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrRigData.count > 0) {

        for (RigReports *inv in arrRigData) {
            totalCost += [inv.dailyCost floatValue];
        }
        return totalCost;
    }

    return 0;
}

-(BOOL) saveAllRigReports:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [RigReports fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        
        int reportID = [[dicData valueForKey:@"reportID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"reportID == %d", reportID];
        fetchRequest = [RigReports fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrRigReports = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrRigReports.count > 0) {
            continue;
        }
        
        RigReports *rigReports = [NSEntityDescription insertNewObjectForEntityForName:@"RigReports" inManagedObjectContext:context];
        
        // set RigReports data
        rigReports.reportID = reportID;
        rigReports.lease = [dicData valueForKey:@"lease"];
        rigReports.wellNum = [dicData valueForKey:@"wellNum"];
        rigReports.company = [dicData valueForKey:@"company"];
        
        NSDate *reportDate = [dicData valueForKey:@"reportDate"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"reportDate"]];
        rigReports.reportDate = reportDate;
        
        rigReports.entryUser = [[dicData valueForKey:@"entryUser"] intValue];
        
        NSDate *entryDate = [dicData valueForKey:@"entryDate"] == [NSNull null] ? nil : [dateFormatter dateFromString:[dicData valueForKey:@"entryDate"]];
        rigReports.entryDate = entryDate;
        
        rigReports.reportAppID = [dicData valueForKey:@"reportAppID"] == [NSNull null] ? nil : [dicData valueForKey:@"reportAppID"];
        rigReports.comments = [dicData valueForKey:@"comments"] == [NSNull null] ? nil : [dicData valueForKey:@"comments"];
        rigReports.tubing = [dicData valueForKey:@"tubing"] == [NSNull null] ? nil : [dicData valueForKey:@"tubing"];
        rigReports.rods = [dicData valueForKey:@"rods"] == [NSNull null] ? nil : [dicData valueForKey:@"rods"];
        rigReports.engrApproval = [dicData valueForKey:@"engrApproval"] == [NSNull null] ? NO : [[dicData valueForKey:@"engrApproval"] boolValue];
        rigReports.dailyCost = [dicData valueForKey:@"dailyCost"] == [NSNull null] ? nil : [dicData valueForKey:@"dailyCost"];
        rigReports.totalCost = [dicData valueForKey:@"totalCost"] == [NSNull null] ? nil : [dicData valueForKey:@"totalCost"];
//        rigReports.rigImages = [dicData valueForKey:@"rigImages"] == [NSNull null] ? nil : [dicData valueForKey:@"rigImages"];
        
        if ([dicData valueForKey:@"rigImages"] == [NSNull null] || [dicData valueForKey:@"rigImages"] == nil) {
            rigReports.rigImages = nil;
        } else {
            NSArray *tmpAry = [dicData valueForKey:@"rigImages"];
            NSMutableArray *valueToSet = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in tmpAry) {
                [valueToSet addObject:dic];
            }
            rigReports.rigImages = [valueToSet copy];
        }
        
        //TODO for multiple
//        rigReports.rigImage = [dicData valueForKey:@"rigImage"] == [NSNull null] ? nil : [dicData valueForKey:@"rigImage"];
        rigReports.downloaded = YES;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}


-(BOOL) saveAllRigReportsRods:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [RigReportsRods fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    for (NSDictionary *dicData in arrData) {
        int rodID = [[dicData valueForKey:@"rodID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"rodID == %d", rodID];
        fetchRequest = [RigReportsRods fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrRigReportsRods = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrRigReportsRods.count > 0) {
            return YES;
        }
        
        RigReportsRods *rigReportsRods = [NSEntityDescription insertNewObjectForEntityForName:@"RigReportsRods" inManagedObjectContext:context];
        
        // set RigReportsRods data
        rigReportsRods.reportID = [[dicData valueForKey:@"reportID"] intValue];
        rigReportsRods.reportAppID = [dicData valueForKey:@"reportAppID"] == [NSNull null] ? nil : [dicData valueForKey:@"reportAppID"];
        
        // RigReportsRods
        rigReportsRods.rodID = rodID;
        rigReportsRods.rodSize = [dicData valueForKey:@"rodSize"] == [NSNull null] ? nil : [dicData valueForKey:@"rodSize"];
        rigReportsRods.rodType = [dicData valueForKey:@"rodType"] == [NSNull null] ? nil : [dicData valueForKey:@"rodType"];
        rigReportsRods.rodLength = [dicData valueForKey:@"rodLength"] == [NSNull null] ? nil : [dicData valueForKey:@"rodLength"];
        rigReportsRods.rodCount = [dicData valueForKey:@"rodCount"] == [NSNull null] ? 0 : [[dicData valueForKey:@"rodCount"] intValue];
        rigReportsRods.rodFootage = [dicData valueForKey:@"rodFootage"] == [NSNull null] ? nil : [dicData valueForKey:@"rodFootage"];
        rigReportsRods.rodOrder = [dicData valueForKey:@"rodOrder"] == [NSNull null] ? 0 : [[dicData valueForKey:@"rodOrder"] intValue];
        rigReportsRods.inOut = [[dicData valueForKey:@"inOut"] boolValue];
        rigReportsRods.downloaded = YES;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveRodSize:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RodSize"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        RodSize *rodSize = [NSEntityDescription insertNewObjectForEntityForName:@"RodSize" inManagedObjectContext:context];
        
        // set RigReports data
        rodSize.rodSizeID = [[dicData valueForKey:@"rodSizeID"] intValue];
        rodSize.rodSize = [dicData valueForKey:@"rodSize"] == [NSNull null] ? nil : [dicData valueForKey:@"rodSize"];
        rodSize.nominalSize = [dicData valueForKey:@"nominalSize"] == [NSNull null] ? nil : [dicData valueForKey:@"nominalSize"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveRodType:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RodType"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        RodType *rodType = [NSEntityDescription insertNewObjectForEntityForName:@"RodType" inManagedObjectContext:context];
        
        // set RigReports data
        rodType.rodTypeID = [[dicData valueForKey:@"rodTypeID"] intValue];
        rodType.rodType = [dicData valueForKey:@"rodType"] == [NSNull null] ? nil : [dicData valueForKey:@"rodType"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveRodLength:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RodLength"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        RodLength *rodLength = [NSEntityDescription insertNewObjectForEntityForName:@"RodLength" inManagedObjectContext:context];
        
        // set RigReports data
        rodLength.rodLengthID = [[dicData valueForKey:@"rodLengthID"] intValue];
        rodLength.rodSize = [dicData valueForKey:@"rodSize"] == [NSNull null] ? nil : [dicData valueForKey:@"rodSize"];
        rodLength.nominalSize = [dicData valueForKey:@"nominalSize"] == [NSNull null] ? nil : [dicData valueForKey:@"nominalSize"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveAllRigReportsPump:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [RigReportsPump fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        
        int pumpID = [[dicData valueForKey:@"pumpID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"pumpID == %d", pumpID];
        fetchRequest = [RigReportsPump fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrRigReportsPump = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrRigReportsPump.count > 0) {
            return YES;
        }
        
        RigReportsPump *rigReportsPump = [NSEntityDescription insertNewObjectForEntityForName:@"RigReportsPump" inManagedObjectContext:context];
        
        // set RigReportsPump data
        rigReportsPump.reportID = [[dicData valueForKey:@"reportID"] intValue];
        rigReportsPump.reportAppID = [dicData valueForKey:@"reportAppID"] == [NSNull null] ? nil : [dicData valueForKey:@"reportAppID"];
        
        rigReportsPump.pumpID = pumpID;
        rigReportsPump.pumpSize = [dicData valueForKey:@"pumpSize"] == [NSNull null] ? nil : [dicData valueForKey:@"pumpSize"];
        rigReportsPump.pumpType = [dicData valueForKey:@"pumpType"] == [NSNull null] ? nil : [dicData valueForKey:@"pumpType"];
        rigReportsPump.pumpLength = [dicData valueForKey:@"pumpLength"] == [NSNull null] ? nil : [dicData valueForKey:@"pumpLength"];
        rigReportsPump.pumpOrder = [dicData valueForKey:@"pumpOrder"] == [NSNull null] ? 0 : [[dicData valueForKey:@"pumpOrder"] intValue];
        rigReportsPump.inOut = [[dicData valueForKey:@"inOut"] boolValue];
        
        rigReportsPump.downloaded = YES;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PumpSize"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    return YES;
}

-(BOOL) savePumpSize:(NSArray *)arrData
{
    
    for (NSDictionary *dicData in arrData) {
        PumpSize *pumpSize = [NSEntityDescription insertNewObjectForEntityForName:@"PumpSize" inManagedObjectContext:context];
        
        // set PumpSize data
        pumpSize.size = [dicData valueForKey:@"size"] == [NSNull null] ? nil : [dicData valueForKey:@"size"];
        pumpSize.nominalSize = [dicData valueForKey:@"nominalSize"] == [NSNull null] ? nil : [dicData valueForKey:@"nominalSize"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) savePumpType:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PumpType"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        PumpType *pumpType = [NSEntityDescription insertNewObjectForEntityForName:@"PumpType" inManagedObjectContext:context];
        
        // set PumpType data
        pumpType.pumpType = [dicData valueForKey:@"pumpType"] == [NSNull null] ? nil : [dicData valueForKey:@"pumpType"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveAllRigReportsTubing:(NSArray *)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == YES"];
    NSFetchRequest *fetchRequest = [RigReportsTubing fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteReq.resultType = NSBatchDeleteResultTypeCount;
    
    NSError *error = nil;
    [context executeRequest:deleteReq error:&error];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    for (NSDictionary *dicData in arrData) {
        
        int tubingID = [[dicData valueForKey:@"tubingID"] intValue];
        
        predicate = [NSPredicate predicateWithFormat:@"tubingID == %d", tubingID];
        fetchRequest = [RigReportsTubing fetchRequest];
        [fetchRequest setPredicate:predicate];
        NSArray *arrRigReportsTubing = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrRigReportsTubing.count > 0) {
            return YES;
        }
        
        RigReportsTubing *rigReportsTubing = [NSEntityDescription insertNewObjectForEntityForName:@"RigReportsTubing" inManagedObjectContext:context];
        
        // set RigReports data
        rigReportsTubing.reportID = [[dicData valueForKey:@"reportID"] intValue];
        rigReportsTubing.reportAppID = [dicData valueForKey:@"reportAppID"] == [NSNull null] ? nil : [dicData valueForKey:@"reportAppID"];
        
        rigReportsTubing.tubingID = tubingID;
        rigReportsTubing.tubingSize = [dicData valueForKey:@"tubingSize"] == [NSNull null] ? nil : [dicData valueForKey:@"tubingSize"];
        rigReportsTubing.tubingType = [dicData valueForKey:@"tubingType"] == [NSNull null] ? nil : [dicData valueForKey:@"tubingType"];
        rigReportsTubing.tubingCount = [dicData valueForKey:@"tubingCount"] == [NSNull null] ? 0 : [[dicData valueForKey:@"tubingCount"] intValue];
        rigReportsTubing.tubingLength = [dicData valueForKey:@"tubingLength"] == [NSNull null] ? nil : [dicData valueForKey:@"tubingLength"];
        rigReportsTubing.tubingFootage = [dicData valueForKey:@"tubingFootage"] == [NSNull null] ? nil : [dicData valueForKey:@"tubingFootage"];
        rigReportsTubing.tubingOrder = [dicData valueForKey:@"tubingOrder"] == [NSNull null] ? 0 : [[dicData valueForKey:@"tubingOrder"] intValue];
        rigReportsTubing.inOut = [[dicData valueForKey:@"inOut"] boolValue];
        
        rigReportsTubing.downloaded = YES;
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveTubingSize:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TubingSize"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        TubingSize *tubingSize = [NSEntityDescription insertNewObjectForEntityForName:@"TubingSize" inManagedObjectContext:context];
        
        // set TubingSize data
        tubingSize.tbgSizeID = [[dicData valueForKey:@"tbgSizeID"] intValue];
        tubingSize.tbgSize = [dicData valueForKey:@"tbgSize"];
        tubingSize.nominalSize = [dicData valueForKey:@"nominalSize"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveTubingType:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TubingType"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        TubingType *tubingType = [NSEntityDescription insertNewObjectForEntityForName:@"TubingType" inManagedObjectContext:context];
        
        // set TubingType data
        tubingType.tbgTypeID = [[dicData valueForKey:@"tbgTypeID"] intValue];
        tubingType.tbgType = [dicData valueForKey:@"tbgType"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

-(BOOL) saveTubingLength:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TubingLength"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        TubingLength *tubingLength = [NSEntityDescription insertNewObjectForEntityForName:@"TubingLength" inManagedObjectContext:context];
        
        // set TubingLength data
        tubingLength.tbgLengthID = [[dicData valueForKey:@"tbgLengthID"] intValue];
        tubingLength.tbgLength = [dicData valueForKey:@"tbgLength"];
        tubingLength.nominalSize = [dicData valueForKey:@"nominalSize"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    return YES;
}

#pragma mark -
-(BOOL) saveAllPumpInfo:(NSArray *)arrData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WaterPumpInfo"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *myPersistentStoreCoordinator = [context persistentStoreCoordinator];
    [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
    
    for (NSDictionary *dicData in arrData) {
        WaterPumpInfo *waterPumpInfo = [NSEntityDescription insertNewObjectForEntityForName:@"WaterPumpInfo" inManagedObjectContext:context];
        
        waterPumpInfo.brand = [dicData valueForKey:@"brand"];
        waterPumpInfo.pumpType = [dicData valueForKey:@"pumpType"];
        waterPumpInfo.plungerAction = [dicData valueForKey:@"plungerAction"];
        waterPumpInfo.pumpTitle = [dicData valueForKey:@"pumpTitle"];
        waterPumpInfo.oldName = [dicData valueForKey:@"oldName"] == [NSNull null] ? nil : [dicData valueForKey:@"oldName"];
        waterPumpInfo.newName = [dicData valueForKey:@"newName"] == [NSNull null] ? nil : [dicData valueForKey:@"newName"];
        waterPumpInfo.minPlungerD = [dicData valueForKey:@"minPlungerD"];
        waterPumpInfo.maxPlungerD = [dicData valueForKey:@"maxPlungerD"];
        waterPumpInfo.stroke = [dicData valueForKey:@"stroke"];
        waterPumpInfo.maxPressure = [[dicData valueForKey:@"maxPressure"] intValue];
        waterPumpInfo.maxGPM = [[dicData valueForKey:@"maxGPM"] intValue];
        waterPumpInfo.maxBPD = [[dicData valueForKey:@"maxBPD"] intValue];
        waterPumpInfo.maxBHP = [dicData valueForKey:@"maxBHP"];
        waterPumpInfo.rpMatBHP = [[dicData valueForKey:@"rpMatBHP"] intValue];
        waterPumpInfo.plungerLoad = [[dicData valueForKey:@"plungerLoad"] intValue];
        waterPumpInfo.fluidEnd = [dicData valueForKey:@"fluidEnd"] == [NSNull null] ? nil : [dicData valueForKey:@"fluidEnd"];
        waterPumpInfo.crankExtD = [dicData valueForKey:@"crankExtD"] == [NSNull null] ? nil : [dicData valueForKey:@"crankExtD"];
        waterPumpInfo.crankExtL = [dicData valueForKey:@"crankExtL"] == [NSNull null] ? nil : [dicData valueForKey:@"crankExtL"];
        waterPumpInfo.keywayWidth = [dicData valueForKey:@"keywayWidth"] == [NSNull null] ? nil : [dicData valueForKey:@"keywayWidth"];
        waterPumpInfo.keywayDepth = [dicData valueForKey:@"keywayDepth"] == [NSNull null] ? nil : [dicData valueForKey:@"keywayDepth"];
        waterPumpInfo.maxSheaveD = [dicData valueForKey:@"maxSheaveD"] == [NSNull null] ? nil : [dicData valueForKey:@"maxSheaveD"];
        waterPumpInfo.crankcaseOilCap = [dicData valueForKey:@"crankcaseOilCap"] == [NSNull null] ? nil : [dicData valueForKey:@"crankcaseOilCap"];
        
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error saving database");
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - detect empty data on entity
- (BOOL)coreDataHasEntriesForEntityName:(NSString *)entityName {
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    [request setFetchLimit:1];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    if ([results count] == 0) {
        return NO;
    }
    return YES;
}


#pragma mark - Get User
-(NSString*) getUserName:(int)userid
{
    if (userid == 0) {
        return @"";
    }
    NSFetchRequest *fetchRequest = [Personnel fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid == %d", userid];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrPersonnel = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return nil;
    }
    
    NSString *strName = @"";
    if (arrPersonnel.count > 0) {
        Personnel *personnel = arrPersonnel[0];
        strName = personnel.employeeName;
    }
    
    return strName;
}

-(Personnel*) getPersonnel:(int)userid
{
    if (userid == 0) {
        return nil;
    }
    
    Personnel *personnel = nil;
    
    NSFetchRequest *fetchRequest = [Personnel fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid == %d", userid];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrPersonnel = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrPersonnel.count > 0) {
        personnel = arrPersonnel[0];
    }
    
    return personnel;
}


#pragma mark - Get Lease data
-(NSArray*) getLeaseDataByAll
{
    NSMutableArray *arrLeaseByAll = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [PulseProdHome fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"leaseName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrLeaseData = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrLeaseData.count > 0) {
        NSDictionary *dic = @{@"sortvalue":@"all", @"data":arrLeaseData};
        [arrLeaseByAll addObject:dic];
    }
    
    return arrLeaseByAll;
}

-(NSArray*) getLeaseDataByDate
{
    NSMutableArray *arrLeaseByAll = [[NSMutableArray alloc] init];

    NSFetchRequest *fetchRequest = [PulseProdHome fetchRequest];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"leaseName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSSortDescriptor *sortDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDateDescriptors = [[NSArray alloc] initWithObjects:sortDateDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDateDescriptors];
    
    NSError *error;
    NSArray *arrLeaseData = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrLeaseData.count > 0) {
        NSDictionary *dic = @{@"sortvalue":@"date", @"data":arrLeaseData};
        [arrLeaseByAll addObject:dic];
    }

    return arrLeaseByAll;
}

-(NSArray*) getLeaseDataByRoute
{
    NSMutableArray *arrLeaseByRoute = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [PulseProdHome fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"route" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrLeaseData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrLeaseData.count == 0) {
        return arrLeaseByRoute;
    }
    
    PulseProdHome *firstModel = arrLeaseData[0];
    int sortValue = firstModel.route;
    NSMutableArray *arrSubLeaseData = [[NSMutableArray alloc] init];
    
    for (PulseProdHome *pulseProdHome in arrLeaseData) {
        
        if (sortValue != pulseProdHome.route) {
            NSFetchRequest *fetchRequestRoute = [LeaseRoutes fetchRequest];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routeID == %d", sortValue];
            [fetchRequestRoute setPredicate:predicate];
            
            NSArray *arrLeaseRoutes = [context executeFetchRequest:fetchRequestRoute error:&error];
            if (!error && arrLeaseRoutes.count > 0) {
                LeaseRoutes *leaseRoutes = arrLeaseRoutes[0];
                NSDictionary *dic = @{@"sortvalue":leaseRoutes.routeName, @"data":arrSubLeaseData};
                [arrLeaseByRoute addObject:dic];
            }
            
            sortValue = pulseProdHome.route;
            arrSubLeaseData = [[NSMutableArray alloc] init];
        }
        
        [arrSubLeaseData addObject:pulseProdHome];
    }
    
    // add last sub array to result.
    NSFetchRequest *fetchRequestRoute = [LeaseRoutes fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routeID == %d", sortValue];
    [fetchRequestRoute setPredicate:predicate];
    
    NSArray *arrLeaseRoutes = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (!error && arrLeaseRoutes.count > 0) {
        LeaseRoutes *leaseRoutes = arrLeaseRoutes[0];
        NSDictionary *dic = @{@"sortvalue":leaseRoutes.routeName, @"data":arrSubLeaseData};
        [arrLeaseByRoute addObject:dic];
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sortvalue" ascending:YES];
    NSArray *result = [arrLeaseByRoute sortedArrayUsingDescriptors:@[descriptor]];
    return result;
}


-(NSArray*) getLeaseDataByOperator
{
    NSMutableArray *arrLeaseByOperator = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [PulseProdHome fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"operator" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrLeaseData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrLeaseData.count == 0) {
        return arrLeaseByOperator;
    }
    
    PulseProdHome *firstModel = arrLeaseData[0];
    NSString *sortValue = firstModel.operator;
    NSMutableArray *arrSubLeaseData = [[NSMutableArray alloc] init];
    
    for (PulseProdHome *pulseProdHome in arrLeaseData) {
        
        if (![sortValue isEqual:pulseProdHome.operator]) {
            
            NSString *companyName = [self getCompanyName:sortValue];
            NSDictionary *dic = @{@"sortvalue":companyName, @"data":arrSubLeaseData};
            [arrLeaseByOperator addObject:dic];
            
            sortValue = pulseProdHome.operator;
            arrSubLeaseData = [[NSMutableArray alloc] init];
        }
        
        [arrSubLeaseData addObject:pulseProdHome];
    }
    
    // add last sub array to result.
    NSString *companyName = [self getCompanyName:sortValue];
    NSDictionary *dic = @{@"sortvalue":companyName, @"data":arrSubLeaseData};
    [arrLeaseByOperator addObject:dic];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sortvalue" ascending:YES];
    NSArray *result = [arrLeaseByOperator sortedArrayUsingDescriptors:@[descriptor]];
    return result;
}

-(NSArray*) getLeaseDataByOwner
{
    NSMutableArray *arrLeaseByOwner = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [PulseProdHome fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"owner" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrLeaseData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrLeaseData.count == 0) {
        return arrLeaseByOwner;
    }
    
    PulseProdHome *firstModel = arrLeaseData[0];
    NSString *sortValue = firstModel.owner;
    NSMutableArray *arrSubLeaseData = [[NSMutableArray alloc] init];
    
    for (PulseProdHome *pulseProdHome in arrLeaseData) {
        
        if (![sortValue isEqual:pulseProdHome.owner]) {
            
            NSString *companyName = [self getCompanyName:sortValue];
            NSDictionary *dic = @{@"sortvalue":companyName, @"data":arrSubLeaseData};
            [arrLeaseByOwner addObject:dic];
            
            sortValue = pulseProdHome.owner;
            arrSubLeaseData = [[NSMutableArray alloc] init];
        }
        
        [arrSubLeaseData addObject:pulseProdHome];
    }
    
    // add last sub array to result.
    NSString *companyName = [self getCompanyName:sortValue];
    NSDictionary *dic = @{@"sortvalue":companyName, @"data":arrSubLeaseData};
    [arrLeaseByOwner addObject:dic];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sortvalue" ascending:YES];
    NSArray *result = [arrLeaseByOwner sortedArrayUsingDescriptors:@[descriptor]];
    return result;
}

#pragma mark -
-(NSArray*) getPulseProdFields:(NSString*)lease
{
    NSArray *arrResults = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [PulseProdField fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@", lease];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"leaseName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrResults = [context executeFetchRequest:fetchRequest error:&error];
    
    return arrResults;
}

-(NSMutableArray*) getProductionLeaseFields:(NSString*)lease
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ProductionField fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@", lease];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"leaseName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrProdFields = [context executeFetchRequest:fetchRequest error:&error];
    
    NSString *leaseField = @"";
    for (ProductionField *field in arrProdFields) {
        if ([field.leaseField isEqualToString:leaseField]) {
            continue;
        }
        [arrResult addObject:field.leaseField];
        leaseField = field.leaseField;
    }
    
    return arrResult;
}

-(NSArray*) getProductionFields:(NSString*)lease leaseField:(NSString*)leaseField
{
    NSArray *arrResults = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ProductionField fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND leaseField == %@", lease, leaseField];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productionDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrResults = [context executeFetchRequest:fetchRequest error:&error];
    
    return arrResults;
}

-(NSArray*) getProductionFields:(NSString*)lease productionDate:(NSDate*)date
{
    NSArray *arrResults = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ProductionField fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND productionDate == %@", lease, date];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"leaseName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrResults = [context executeFetchRequest:fetchRequest error:&error];
    
    return arrResults;
}

-(NSString*) getProductionLeaseName:(NSString*) leaseField
{
    NSArray *arrResults = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ProductionField fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"leaseField == %@", leaseField];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"leaseName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrResults = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error || arrResults.count == 0) {
        return @"";
    }
    ProductionField *prodField = arrResults[0];
    
    return prodField.leaseName;
}

#pragma mark -
-(NSArray*) getProductionByLease:(NSString *)lease
{
    NSArray *arrProductions = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [Production fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@", lease];
    [fetchRequest setPredicate:predicate];
        
    NSError *error;
    arrProductions = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrProductions.count == 0) {
        return [[NSArray alloc] init];
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    Production *tmpProduction = arrProductions[0];
    [result addObject:tmpProduction];
    
    for (int i = 0; i < arrProductions.count; i++) {
        Production *production = arrProductions[i];
        if ([production.productionDate isEqual:tmpProduction.productionDate]) {
            if (production.allocatedVolume == YES) {
                [result replaceObjectAtIndex:(result.count-1) withObject:production];
                tmpProduction = production;
            }
        } else {
            [result addObject:production];
            tmpProduction = production;
        }
    }
    
    return result;
}

-(ProductionAvg*) getProductionAvgByLease:(NSString *)lease
{
    NSArray *arrTanks = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ProductionAvg fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@", lease];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    arrTanks = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrTanks.count > 0) {
        return arrTanks[0];
    }
    
    return nil;
}

-(ProductionAvgField*) getProductionAvgFieldByLease:(NSString *)lease leaseField:(NSString*)leaseField
{
    NSArray *arrTanks = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ProductionAvgField fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND leaseField == %@", lease, leaseField];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    arrTanks = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrTanks.count > 0) {
        return arrTanks[0];
    }
    
    return nil;
}

-(NSArray*) getTanksByLease:(NSString *)lease
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ListAssetLocations fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"grandparentPropNum == %@ AND propType != 'Commingle'", lease];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrListAssetLocations = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrListAssetLocations.count == 0) {
        return [[NSArray alloc] init];
    } else {
        for (ListAssetLocations *listAssetLocation in arrListAssetLocations) {
            
            fetchRequest = [Tanks fetchRequest];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND current == YES", listAssetLocation.parentPropNum];
            [fetchRequest setPredicate:predicate];
            
            NSError *error;
            NSArray *arrTanks = [context executeFetchRequest:fetchRequest error:&error];
            if (!error) {
                [arrResult addObjectsFromArray:arrTanks];
            }
        }
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"rrc" ascending:YES];
    NSArray *result = [arrResult sortedArrayUsingDescriptors:@[descriptor]];
    
    return result;
}

-(NSString*) getTankRRCById:(int)tankID
{
    NSFetchRequest *fetchRequest = [Tanks fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tankID == %d", tankID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrTanks = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrTanks.count == 0) {
        return nil;
    }
    Tanks *tank = arrTanks[0];
    
    return tank.rrc;
}

-(NSArray*) getTankGaugeEntry:(NSString *)lease tankID:(int)tankID
{
    NSArray *arrTankGaugeEntries = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [TankGaugeEntry fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tankID1 == %d OR tankID2 == %d OR tankID3 == %d OR tankID4 == %d OR tankID5 == %d OR tankID6 == %d OR tankID7 == %d OR tankID8 == %d OR tankID9 == %d OR tankID10 == %d)", tankID, tankID, tankID, tankID, tankID, tankID, tankID, tankID, tankID, tankID];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gaugeTime" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrTankGaugeEntries = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrTankGaugeEntries;
}


-(TankStrappings*) getTankStrappingsWithRRC:(NSString *)rrc
{
    NSArray *arrTanks = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"TankStrappings" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rrc == %@", rrc];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    arrTanks = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrTanks.count > 0) {
        return arrTanks[0];
    }
    
    return nil;
}


-(NSArray*) getRunTickets:(NSString *)lease tankID:(int)tankID
{
    NSArray *arrTickets = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [RunTickets fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND tankNumber == %d AND deleted == NO", lease, tankID];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ticketTime" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrTickets = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrTickets;
}


#pragma mark -
-(NSArray*) getMeterProblems
{
    NSArray *arrResult = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ListMeterProblem fetchRequest];
    
    NSError *error;
    arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        arrResult = [[NSArray alloc] init];
    }
    
    return arrResult;
}

-(NSString*) getMeterProblemReason:(NSString *)reasonCode
{
    NSString *reason = @"";
    
    NSFetchRequest *fetchRequest = [ListMeterProblem fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reasonCode == %@", reasonCode];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrMeterProblem = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrMeterProblem.count == 0) {
        return nil;
    } else {
        ListMeterProblem *meterProblem = arrMeterProblem[0];
        reason = meterProblem.reason;
    }
    
    return reason;
}

-(NSString*) getMeterProblemReasonCode:(NSString *)reason
{
    NSString *reasonCode = @"";
    
    NSFetchRequest *fetchRequest = [ListMeterProblem fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reason == %@", reason];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrMeterProblem = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrMeterProblem.count == 0) {
        return nil;
    } else {
        ListMeterProblem *meterProblem = arrMeterProblem[0];
        reasonCode = meterProblem.reasonCode;
    }
    
    return reasonCode;
}

-(NSArray*) getMetersByLease:(NSString *)lease
{
    NSArray *arrMeters = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Meters" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"meterLease == %@ AND active == YES", lease];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    arrMeters = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrMeters;
}

-(NSArray*) getMeterDataByLease:(NSString *)lease meterID:(NSString *)meterID meterType:(NSString *)meterType
{
    NSArray *arrMeterData = [[NSArray alloc] init];
    
    if ([[meterType lowercaseString] isEqual:@"gas"]) {
        
        NSFetchRequest *fetchRequest = [GasMeterData fetchRequest];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lease == %@) AND (idGasMeter == %@)", lease, meterID];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError *error;
        arrMeterData = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            return [[NSArray alloc] init];
        }
        
    } else {
        NSFetchRequest *fetchRequest = [WaterMeterData fetchRequest];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lease == %@) AND (meterNum == %@)", lease, meterID];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError *error;
        arrMeterData = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            return [[NSArray alloc] init];
        }
    }
    
    return arrMeterData;
}

#pragma mark -
-(NSArray*) getWellProblems
{
    NSArray *arrResult = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ListWellProblem fetchRequest];
    
    NSError *error;
    arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        arrResult = [[NSArray alloc] init];
    }
    
    return arrResult;
}

-(NSString*) getWellproblemReason:(NSString *)reasonCode
{
    NSString *reason = @"";
    
    NSFetchRequest *fetchRequest = [ListWellProblem fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reasonCode == %@", reasonCode];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrMeterProblem = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrMeterProblem.count == 0) {
        return nil;
    } else {
        ListWellProblem *wellProblem = arrMeterProblem[0];
        reason = wellProblem.reason;
    }
    
    return reason;
}

-(NSString*) getWellproblemReasonCode:(NSString *)reason
{
    NSString *reasonCode = @"";
    
    
    NSFetchRequest *fetchRequest = [ListWellProblem fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reason == %@", reason];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrMeterProblem = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrMeterProblem.count == 0) {
        return nil;
    } else {
        ListWellProblem *wellProblem = arrMeterProblem[0];
        reasonCode = wellProblem.reasonCode;
    }
    
    return reasonCode;
}

-(NSArray*) getWellListByLease:(NSString *)lease
{
    NSArray *arrResult = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WellList fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"grandparentPropNum == %@", lease];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wellNumber" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrResult.count == 0) {
        return [[NSArray alloc] init];
    }
    
    arrResult = [arrResult sortedArrayUsingComparator:^NSComparisonResult(WellList *obj1, WellList *obj2) {
        
        if ([obj1.wellNumber intValue] == [obj2.wellNumber intValue])
            return NSOrderedSame;
        
        else if ([obj1.wellNumber intValue] < [obj2.wellNumber intValue])
            return NSOrderedAscending;
        
        else
            return NSOrderedDescending;
        
    }];
    
    return arrResult;
}


-(NSArray*) getWellheadDataByLease:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSArray *arrWellheadData = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WellheadData fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lease == %@) AND (wellNumber == %@)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrWellheadData;
}

-(NSMutableDictionary*) getWellheadDataByLeaseForOverview:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    NSArray *arrWellheadData = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WellheadData fetchRequest];
    
    //spm
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (spm != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"spm"];
        
        WellheadData *tmp1 = arrWellheadData[0];
        
        NSDate *date1 = tmp1.checkTime;
        
        NSLog(@"date1: %@", date1);
    }
    if (arrWellheadData.count > 1) {
        
        
        WellheadData *tmp2 = arrWellheadData[1];
        
        NSDate *date2 = tmp2.checkTime;
        NSLog(@"date2: %@", date2);
    }
    
    
    
    //choke
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (choke != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"choke"];
    }
    
    //strokeSize
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (strokeSize != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"strokeSize"];
    }
    
    //pound
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (pound != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"pound"];
    }
    
    //timeOn
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (timeOn != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"timeOn"];
    }
    
    //timeOff
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (timeOff != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"timeOff"];
    }
    
    //espHz
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (espHz != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"espHz"];
    }
    
    //espAmp
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (espAmp != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"espAmp"];
    }
    
    //casingPressure
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (casingPressure != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"casingPressure"];
    }
    
    //tubingPressure
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (tubingPressure != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"tubingPressure"];
    }
    
    //bradenheadPressure
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (bradenheadPressure != NULL)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"bradenheadPressure"];
    }
    
    //oilCut
    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND ((oilCut != NULL) || (emulsionCut != NULL) || (waterCut != NULL))", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableDictionary alloc] init];
    }
    
    if (arrWellheadData.count > 0) {
        [retDic setValue:arrWellheadData[0] forKey:@"oilCut"];
        [retDic setValue:arrWellheadData[0] forKey:@"emulsionCut"];
        [retDic setValue:arrWellheadData[0] forKey:@"waterCut"];
    }
    
//    //emulsionCut
//    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (emulsionCut != NULL)", lease, wellNum];
//    [fetchRequest setPredicate:predicate];
//
//    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
//    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [fetchRequest setSortDescriptors:sortDescriptors];
//
//    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
//    if (error) {
//        return [[NSMutableDictionary alloc] init];
//    }
//
//    if (arrWellheadData.count > 0) {
//        [retDic setValue:arrWellheadData[0] forKey:@"emulsionCut"];
//    }
//
//    //waterCut
//    predicate = [NSPredicate predicateWithFormat:@"((lease == %@) AND (wellNumber == %@)) AND (waterCut != NULL)", lease, wellNum];
//    [fetchRequest setPredicate:predicate];
//
//    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkTime" ascending:NO];
//    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [fetchRequest setSortDescriptors:sortDescriptors];
//
//    arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
//    if (error) {
//        return [[NSMutableDictionary alloc] init];
//    }
//
//    if (arrWellheadData.count > 0) {
//        [retDic setValue:arrWellheadData[0] forKey:@"waterCut"];
//    }
    
    return retDic;
}


#pragma mark - Get WBD data
-(NSArray*) getWBDSurveys:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSArray *arrData = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WBDSurveys fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"md" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrData;

}

-(NSArray*) getWBDPlugs:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSArray *arrData = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WBDPlugs fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@ AND plugType != %@", lease, wellNum, nil];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"plugDepth" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrData;
}

-(NSArray*) getCasing:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WBDCasingTubing fetchRequest];
    
    NSPredicate *casingPredicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@ AND wbCasing == YES", lease, wellNum];
    [fetchRequest setPredicate:casingPredicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"segmentID" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrCasing = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrCasing.count > 0) {
        int segmentID = -1;
        
        for (int i = 0; i < arrCasing.count; i++) {
            WBDCasingTubing *casing = arrCasing[i];
            
            if (segmentID != casing.segmentID) {
                NSArray *arrSub = [self getWBDCasingWithSegment:casing.segmentID lease:lease wellNum:wellNum];
                if (arrSub.count > 0) {
                    for (WBDCasingTubing *wbdCasing in arrSub) {
                        [arrData addObject:wbdCasing];
                    }
                }
                segmentID = casing.segmentID;
            }
            
        }
        
    }
    
    return arrData;
}


-(NSArray*) getWBDCasingWithSegment:(int)segmentID lease:(NSString*)lease wellNum:(NSString*) wellNum
{
    NSFetchRequest *fetchRequest = [WBDCasingTubing fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@ AND wbCasing == YES AND segmentID == %d", lease, wellNum, segmentID];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"segmentOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrTubings = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        return [[NSMutableArray alloc] init];
    }
    
    return arrTubings;
}



-(NSArray*) getWBDTubings:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WBDCasingTubing fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@ AND wbTubing == YES", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"segmentID" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrTubings = [context executeFetchRequest:fetchRequest error:&error];
    
    
    int segmentID = -1;
    
    if (!error && arrTubings.count > 0) {
        for (int i = 0; i < arrTubings.count; i++) {
            WBDCasingTubing *tubing = arrTubings[i];
            
            if (segmentID != tubing.segmentID) {
                NSMutableArray *arrSub = [self getWBDTubingsWithSegment:tubing.segmentID lease:lease wellNum:wellNum];
                if (arrSub.count > 0) {
                    [arrData addObject:arrSub];
                }
                segmentID = tubing.segmentID;
            }
            
        }
    }
    
    return arrData;
}

-(NSMutableArray*) getWBDTubingsWithSegment:(int)segmentID lease:(NSString*)lease wellNum:(NSString*) wellNum
{
    NSFetchRequest *fetchRequest = [WBDCasingTubing fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@ AND wbTubing == YES AND segmentID == %d", lease, wellNum, segmentID];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"segmentOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrTubings = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        return [[NSMutableArray alloc] init];
    }
    
    return [arrTubings mutableCopy];
}

-(NSArray*) getWBDRods:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WBDRods fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"segmentID" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrRods = [context executeFetchRequest:fetchRequest error:&error];
    
    int segmentID = -1;
    
    if (!error && arrRods.count > 0) {
        for (int i = 0; i < arrRods.count; i++) {
            WBDRods *rod = arrRods[i];
            
            if (segmentID != rod.segmentID) {
                NSArray *arrSub = [self getWBDRodsWithSegment:rod.segmentID lease:rod.lease wellNum:rod.wellNum];
                if (arrSub.count > 0) {
                    [arrData addObject:arrSub];
                }
                segmentID = rod.segmentID;
            }
        }
    }
    
    return arrData;
}

-(NSArray*) getWBDRodsWithSegment:(int)segmentID lease:(NSString*)lease wellNum:(NSString*)wellNum
{
    NSFetchRequest *fetchRequest = [WBDRods fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNum == %@ AND segmentID == %d", lease, wellNum, segmentID];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"segmentOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrRods = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrRods;
}



-(NSArray*) getWBDInfos:(NSString *)tblName recordID:(int)recordID lease:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSArray *arrData = [[NSArray alloc] init];
    NSFetchRequest *fetchRequest = [WBDInfo fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tblName == %@) AND (lease == %@) AND (wellNum == %@) And (recordID == %d)", tblName, lease, wellNum, recordID];
    [fetchRequest setPredicate:predicate];
   
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"infoDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrData = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrData;
}

-(NSString*) getWBDInfoSourceType:(int)sourceID
{
    NSFetchRequest *fetchRequest = [WBDInfoSource fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sourceID == %d", sourceID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrInfoSources = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrInfoSources.count > 0) {
        WBDInfoSource *infoSource = arrInfoSources[0];
        return infoSource.infoSourceType;
    }
    
    return @"";
}


-(NSArray*) getWBDPumps:(NSString*)lease wellNum:(NSString*)wellNum
{
    NSFetchRequest *fetchRequest = [WBDPumps fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lease == %@) AND (wellNum == %@)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pumpDateIn" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrPumps = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrPumps;
}

-(NSArray*) getWBDTreatments:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSArray *arrTreatments = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WBDTreatments fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lease == %@) AND (wellNum == %@)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"treatmentDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrTreatments = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrTreatments;
}

-(NSArray*) getWBDPerfs:(NSString *)lease wellNum:(NSString *)wellNum
{
    NSArray *arrPerfs = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WBDPerfs fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lease == %@) AND (wellNum == %@)", lease, wellNum];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"perfDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrPerfs = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrPerfs;
}


#pragma mark -

-(NSString*) getCompanyName:(NSString*)companyCode
{
    NSFetchRequest *fetchRequestRoute = [ListCompany fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"companyCode == %@", companyCode];
    [fetchRequestRoute setPredicate:predicate];
    
    NSError *error;
    NSArray *arrListCompany = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (!error && arrListCompany.count > 0) {
        ListCompany *listCompany = arrListCompany[0];
        
        return listCompany.company;
    }
    return nil;
}

-(NSString*) getCompanyCode:(NSString*)company
{
    NSFetchRequest *fetchRequestRoute = [ListCompany fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"company == %@", company];
    [fetchRequestRoute setPredicate:predicate];
    
    NSError *error;
    NSArray *arrListCompany = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (!error && arrListCompany.count > 0) {
        ListCompany *listCompany = arrListCompany[0];
        
        return listCompany.company;
    }
    return nil;
}


-(NSString*) getRouteName:(NSString*)strID
{
    NSFetchRequest *fetchRequestRoute = [LeaseRoutes fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", [strID intValue]];
    [fetchRequestRoute setPredicate:predicate];
    
    NSError *error;
    NSArray *arrLeaseRoute = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (!error && arrLeaseRoute.count > 0) {
        LeaseRoutes *leaseRoute = arrLeaseRoute[0];
        
        return leaseRoute.routeName;
    }
    
    return nil;
}

#pragma mark - Get Invoices data

-(NSMutableDictionary*) getInvoicesForLastCommentsWithWellNum:(NSString*)wellNum withLease:(NSString*)lease
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    NSArray *arrInvoices = [[NSArray alloc] init];
    //for comments
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wellNumber == %@ AND lease == %@ AND comments != NULL AND comments != %@", wellNum, lease, @""]; //for Comments
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"invoiceDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrInvoices = [context executeFetchRequest:fetchRequest error:&error];
    [retDic setObject:[arrInvoices copy] forKey:@"comments"];
    
    // for rodComments
    predicate = [NSPredicate predicateWithFormat:@"wellNumber == %@ AND lease == %@ AND rodComments != NULL AND rodComments != %@", wellNum, lease, @""]; //for rods
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrInvoices = [context executeFetchRequest:fetchRequest error:&error];
    [retDic setObject:[arrInvoices copy] forKey:@"rodComments"];
    
    // for tubingComments
    predicate = [NSPredicate predicateWithFormat:@"wellNumber == %@ AND lease == %@ AND tubingComments != NULL AND tubingComments != %@", wellNum, lease, @""]; //for tubingComments
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrInvoices = [context executeFetchRequest:fetchRequest error:&error];
    [retDic setObject:[arrInvoices copy] forKey:@"tubingComments"];
    
    return retDic;
}

-(Invoices*) getInvoice:(int)invoiceID withAppID:(NSString*)invoiceAppID
{
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d", invoiceID];
    if (invoiceID == 0) {
        predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %d", invoiceAppID];
    }
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrInvoices = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrInvoices.count > 0) {
        Invoices *invoice = arrInvoices[0];
        return invoice;
    }
    
    return nil;
}

-(NSArray*) getInvoices:(NSString*) sortType
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    NSString *sortValue = @"";
    
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == NO"];
    if ([sortType isEqual:@"primary"]) {
        predicate = [NSPredicate predicateWithFormat:@"deleted == NO AND approval1 == NO AND noBill == NO AND export == NO"];
        sortValue = @"Primary Approval";
    } else if ([sortType isEqual:@"secondary"]) {
        predicate = [NSPredicate predicateWithFormat:@"deleted == NO AND approval1 == YES AND approval2 == NO AND noBill == NO AND export == NO"];
        sortValue = @"Secondary Approval";
    } else if ([sortType isEqual:@"export"]) {
        predicate = [NSPredicate predicateWithFormat:@"deleted == NO AND approval1 == YES AND approval2 == YES AND noBill == NO AND export == NO"];
        sortValue = @"Awaiting Export";
    }
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"invoiceDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrInvoices = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrInvoices.count == 0) {
        return [[NSArray alloc] init];
    }
    
    NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrInvoices};
    [arrResult addObject:dic];
    
    return arrResult;
}

-(NSArray*) getInvoicesByDate
{
    NSDate *curDate = [NSDate date];
    
    NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
    NSTimeInterval totalSecondsInWeek = [daysToSync intValue] * 24 * 60 * 60;
    NSDate *entryDate = [NSDate dateWithTimeIntervalSinceNow:-totalSecondsInWeek];
    NSMutableArray *arrInvoices = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(invoiceDate >= %@) AND (invoiceDate < %@) AND deleted == NO", entryDate, curDate];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"invoiceDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrInvoicesData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrInvoicesData.count == 0) {
        return arrInvoices;
    }
    
    Invoices *firstModel = arrInvoicesData[0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *sortValue = [df stringFromDate:firstModel.invoiceDate];
    NSMutableArray *arrSubInvoices = [[NSMutableArray alloc] init];
    
    for (Invoices *invoice in arrInvoicesData) {
        
        [df setDateFormat:@"MM/dd/yyyy"];
        NSString *invoiceDate = [df stringFromDate:invoice.invoiceDate];
        if (![sortValue isEqual:invoiceDate]) {
            
            NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSubInvoices};
            [arrInvoices addObject:dic];
            
            sortValue = invoiceDate;
            arrSubInvoices = [[NSMutableArray alloc] init];
        }
        [arrSubInvoices addObject:invoice];
    }
    
    // add last sub array to result.
    NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSubInvoices};
    [arrInvoices addObject:dic];
    
    return arrInvoices;
}

-(NSArray*) getInvoicesByLease
{
    
    NSMutableArray *arrInvoices = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    
    NSDate *curDate = [NSDate date];
    NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
    NSTimeInterval totalSecondsInWeek = [daysToSync intValue] * 24 * 60 * 60;
    NSDate *entryDate = [NSDate dateWithTimeIntervalSinceNow:-totalSecondsInWeek];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(invoiceDate >= %@) AND (invoiceDate < %@) AND deleted == NO", entryDate, curDate];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lease" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrInvoicesData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrInvoicesData.count == 0) {
        return arrInvoices;
    }
    
    Invoices *firstModel = arrInvoicesData[0];
    NSString *sortValue = firstModel.lease;
    NSMutableArray *arrSubInvoices = [[NSMutableArray alloc] init];
    
    for (Invoices *invoice in arrInvoicesData) {
        
        if (![sortValue isEqual:invoice.lease]) {
            
            NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSubInvoices};
            [arrInvoices addObject:dic];
            
            sortValue = invoice.lease;
            arrSubInvoices = [[NSMutableArray alloc] init];
        }
        [arrSubInvoices addObject:invoice];
    }
    
    // add last sub array to result.
    NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSubInvoices};
    [arrInvoices addObject:dic];
    
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sortvalue" ascending:YES];
    NSArray *result = [arrInvoices sortedArrayUsingDescriptors:@[descriptor]];
    
    return result;
    
}

-(NSArray*) getInvoicesByAcccount
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
    
    NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
    NSTimeInterval totalSecondsInWeek = [daysToSync intValue] * 24 * 60 * 60;
    NSDate *entryDate = [NSDate dateWithTimeIntervalSinceNow:-totalSecondsInWeek];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == NO"];
    
    [fetchRequest setPredicate:predicate];
   
    NSError *error;
    NSArray *arrInvoicesDetail = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrInvoicesDetail.count == 0) {
        return arrResult;
    }
    
    for (InvoicesDetail *invoiceDetail in arrInvoicesDetail) {
        
        NSString *accountDescription = [self getAccountDescription:invoiceDetail.account withSubAccount:invoiceDetail.accountSub];
        if (!accountDescription)
            continue;
        
        Invoices *invoice = [self getInvoice:invoiceDetail.invoiceID withAppID:invoiceDetail.invoiceAppID];
        if (!invoice) {
            continue;
        }
        NSDate *invoiceDate = invoice.invoiceDate;
        if ([invoiceDate compare:entryDate] == NSOrderedAscending) {
            continue;
        }
        
        if (arrResult.count == 0) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject:invoice];
            NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
            [dicData setValue:accountDescription forKey:@"sortvalue"];
            [dicData setObject:arr forKey:@"data"];

            [arrResult addObject:dicData];
        } else {
            for (int i = 0; i < arrResult.count; i++) {
                NSMutableDictionary *dic = arrResult[i];
                
                if ([accountDescription isEqual:[dic valueForKey:@"sortvalue"]]) {
                    NSMutableArray *arrSubInvoices = [dic valueForKey:@"data"];
                    [arrSubInvoices addObject:invoice];
                    [dic setObject:arrSubInvoices forKey:@"data"];
                    [arrResult replaceObjectAtIndex:i withObject:dic];
                    break;
                } else if (i == arrResult.count - 1) {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [arr addObject:invoice];
                    
                    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
                    [dicData setValue:accountDescription forKey:@"sortvalue"];
                    [dicData setObject:arr forKey:@"data"];
                    
                    [arrResult addObject:dicData];
                    break;
                }
            }
        }
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sortvalue" ascending:YES];
    NSArray *result = [arrResult sortedArrayUsingDescriptors:@[descriptor]];
    
    return result;
}

-(NSArray*) getInvoicesByPeople
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [InvoicesPersonnel fetchRequest];

    NSDate *curDate = [NSDate date];
    NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
    NSTimeInterval totalSecondsInWeek = [daysToSync intValue] * 24 * 60 * 60;
    NSDate *entryDate = [NSDate dateWithTimeIntervalSinceNow:-totalSecondsInWeek];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == NO"];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrInvoicesData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrInvoicesData.count == 0) {
        return arrResult;
    }
    
    for (InvoicesPersonnel *invoicePersonnel in arrInvoicesData) {
        
        NSString *personnel = [self getUserName:invoicePersonnel.userID];
        
        Invoices *invoice = [self getInvoice:invoicePersonnel.invoiceID withAppID:invoicePersonnel.invoiceAppID];
        if (!invoice) {
            continue;
        }
        NSDate *invoiceDate = invoice.invoiceDate;
        if ([invoiceDate compare:entryDate] == NSOrderedAscending) {
            continue;
        }
        
        if (arrResult.count == 0) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject:invoice];
            
            NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
            [dicData setValue:personnel forKey:@"sortvalue"];
            [dicData setObject:arr forKey:@"data"];
            
            [arrResult addObject:dicData];
        } else {
            for (int i = 0; i < arrResult.count; i++) {
                NSMutableDictionary *dic = arrResult[i];
                
                if ([personnel isEqual:[dic valueForKey:@"sortvalue"]]) {
                    NSMutableArray *arrSubInvoices = [dic valueForKey:@"data"];
                    [arrSubInvoices addObject:invoice];
                    [dic setObject:arrSubInvoices forKey:@"data"];
                    [arrResult replaceObjectAtIndex:i withObject:dic];
                    break;
                } else if (i == arrResult.count - 1) {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [arr addObject:invoice];
                    
                    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
                    [dicData setValue:personnel forKey:@"sortvalue"];
                    [dicData setObject:arr forKey:@"data"];
                    
                    [arrResult addObject:dicData];
                    break;
                }
            }
        }
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sortvalue" ascending:YES];
    NSArray *result = [arrResult sortedArrayUsingDescriptors:@[descriptor]];
    
    return result;
}

-(NSArray*) getInvoiceDetail:(int)invoiceID appID:(NSString*)invoiceAppID
{
    NSArray *arrResult = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == NO AND invoiceID == %d", invoiceID];
    if (invoiceID == 0) {
        predicate = [NSPredicate predicateWithFormat:@"deleted == NO AND invoiceAppID == %@", invoiceAppID];
    }
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrInvoicesDetail = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrInvoicesDetail.count > 0) {
        return arrInvoicesDetail;
    }
    
    return arrResult;
}

-(NSArray*) getInvoicePersonnel:(int)invoiceID appID:(NSString*)invoiceAppID
{
    NSArray *arrResult = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [InvoicesPersonnel fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == NO AND invoiceID == %d", invoiceID];
    if (invoiceID == 0) {
        predicate = [NSPredicate predicateWithFormat:@"deleted == NO AND invoiceAppID == %@", invoiceAppID];
    }
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrInvoicesPersonnel = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrInvoicesPersonnel.count > 0) {
        return arrInvoicesPersonnel;
    }
    
    return arrResult;
}

#pragma mark - 
-(NSArray*) getAllAccounts
{
    NSArray *arrAccounts = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequestRoute = [InvoiceAccounts fetchRequest];
    
    NSError *error;
    arrAccounts = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrAccounts;
}



-(NSString*) getAccountDescription:(int)acctID withSubAccount:(int)subAcctID
{
    NSFetchRequest *fetchRequest = [InvoiceAccounts fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"acctID == %d AND subAcctID == %d", acctID, subAcctID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrAccounts = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrAccounts.count > 0) {
        InvoiceAccounts *accounts = arrAccounts[0];
        NSString *strAccount = accounts.account;
        if (accounts.subAccount) {
            strAccount = [NSString stringWithFormat:@"%@ - %@", strAccount, accounts.subAccount];
        }
        return strAccount;
    }
    
    return nil;
}

-(InvoiceAccounts*) getAccount:(int)acctID withSub:(int)subAcctID
{
    NSFetchRequest *fetchRequest = [InvoiceAccounts fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"acctID == %d AND subAcctID == %d", acctID, subAcctID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrAccounts = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrAccounts.count > 0) {
        InvoiceAccounts *account = arrAccounts[0];
        
        return account;
    }
    
    return nil;
}

-(NSArray*) getPersonnels
{
    NSArray *arrPersonnels = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequestRoute = [Personnel fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active == YES AND invPersonnel == YES"];
    [fetchRequestRoute setPredicate:predicate];
    
    NSError *error;
    arrPersonnels = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrPersonnels;
}


#pragma mark - Get Schedules 
-(NSArray*) getSchedulesByLease
{
    NSMutableArray *arrSchedules = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [Schedules fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lease" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrSchedulesData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrSchedulesData.count == 0) {
        return arrSchedules;
    }
    
    Schedules *firstModel = arrSchedulesData[0];
    NSString *sortValue = firstModel.lease;
    NSMutableArray *arrSubSchedules = [[NSMutableArray alloc] init];
    
    for (Schedules *schedule in arrSchedulesData) {
        
        if (![sortValue isEqual:schedule.lease]) {
            
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
            NSArray *arrSorteddSubSchedules = [arrSubSchedules sortedArrayUsingDescriptors:@[descriptor]];
            
            NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSorteddSubSchedules};
            [arrSchedules addObject:dic];
            
            sortValue = schedule.lease;
            arrSubSchedules = [[NSMutableArray alloc] init];
        }
        [arrSubSchedules addObject:schedule];
        
        
    }
    
    // add last sub array to result.
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *arrSorteddSubSchedules = [arrSubSchedules sortedArrayUsingDescriptors:@[descriptor]];
    NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSorteddSubSchedules};
    [arrSchedules addObject:dic];
    
    return arrSchedules;
}

-(NSArray*) getSchedulesByType
{
    NSMutableArray *arrSchedules = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [Schedules fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scheduleType" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrSchedulesData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrSchedulesData.count == 0) {
        return arrSchedules;
    }
    
    Schedules *firstModel = arrSchedulesData[0];
    NSString *sortValue = firstModel.scheduleType;
    NSMutableArray *arrSubSchedules = [[NSMutableArray alloc] init];
    
    for (Schedules *schedule in arrSchedulesData) {
        
        if (![sortValue isEqual:schedule.scheduleType]) {
            
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"lease" ascending:YES];
            NSArray *arrSorteddSubSchedules = [arrSubSchedules sortedArrayUsingDescriptors:@[descriptor]];
            
            NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSorteddSubSchedules};
            [arrSchedules addObject:dic];
            
            sortValue = schedule.scheduleType;
            arrSubSchedules = [[NSMutableArray alloc] init];
        }
        [arrSubSchedules addObject:schedule];
        
        
    }
    
    // add last sub array to result.
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"lease" ascending:YES];
    NSArray *arrSorteddSubSchedules = [arrSubSchedules sortedArrayUsingDescriptors:@[descriptor]];
    NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSorteddSubSchedules};
    [arrSchedules addObject:dic];
    
    return arrSchedules;
}

-(NSArray*) getSchedulesByDate
{
    NSMutableArray *arrSchedules = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [Schedules fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrSchedulesData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrSchedulesData.count == 0) {
        return arrSchedules;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    Schedules *firstModel = arrSchedulesData[0];
    NSString *sortValue = [df stringFromDate:firstModel.date];
    NSMutableArray *arrSubSchedules = [[NSMutableArray alloc] init];
    
    for (Schedules *schedule in arrSchedulesData) {
        
        NSString *strDate = [df stringFromDate:schedule.date];
        if (![sortValue isEqual:strDate]) {
            
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"lease" ascending:YES];
            NSArray *arrSorteddSubSchedules = [arrSubSchedules sortedArrayUsingDescriptors:@[descriptor]];
            
            NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSorteddSubSchedules};
            [arrSchedules addObject:dic];
            
            sortValue = strDate;
            arrSubSchedules = [[NSMutableArray alloc] init];
        }
        [arrSubSchedules addObject:schedule];
        
        
    }
    
    // add last sub array to result.
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"lease" ascending:YES];
    NSArray *arrSorteddSubSchedules = [arrSubSchedules sortedArrayUsingDescriptors:@[descriptor]];
    NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSorteddSubSchedules};
    [arrSchedules addObject:dic];
    
    return arrSchedules;
}


-(NSArray*) getSchedulesByStatus
{
    NSMutableArray *arrSchedules = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [Schedules fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"status" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrSchedulesData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrSchedulesData.count == 0) {
        return arrSchedules;
    }
    
    Schedules *firstModel = arrSchedulesData[0];
    NSString *sortValue = firstModel.status;
    NSMutableArray *arrSubSchedules = [[NSMutableArray alloc] init];
    
    for (Schedules *schedule in arrSchedulesData) {
        
        if (![sortValue isEqual:schedule.status]) {
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
            if ([sortValue isEqual:@"Scheduled"]) {
                descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
            }
            NSArray *arrSorteddSubSchedules = [arrSubSchedules sortedArrayUsingDescriptors:@[descriptor]];
            NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSorteddSubSchedules};
            [arrSchedules addObject:dic];
            
            sortValue = schedule.status;
            arrSubSchedules = [[NSMutableArray alloc] init];
        }
        [arrSubSchedules addObject:schedule];
        
        
    }
    
    // add last sub array to result.
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    if ([sortValue isEqual:@"Scheduled"]) {
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    }
    NSArray *arrSorteddSubSchedules = [arrSubSchedules sortedArrayUsingDescriptors:@[descriptor]];
    NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSorteddSubSchedules};
    [arrSchedules addObject:dic];
    
    return arrSchedules;
}



-(NSArray*) getScheduleTypesByCategory:(NSString *)category
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ScheduleType fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", category];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrScheduleTypes = [context executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        for (ScheduleType *scheduleType in arrScheduleTypes) {
            [result addObject:scheduleType.type];
        }
    }
    
    return result;
}

-(NSArray*) getLeases
{
    NSArray *result = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ListAssetLocations fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propType == 'Production'"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrListAssetsLocations = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return result;
    }
    
    return arrListAssetsLocations;
}

-(NSArray*) getLeasesForInvoice
{
    NSArray *result = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [ListAssetLocations fetchRequest];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propType == 'Production' OR propType == 'Invoice' OR propType == 'Yard'"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propType == 'Production' OR (propType != 'Commingle' AND propType != 'Non-Commingle')"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrListAssetsLocations = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return result;
    }
    
    return arrListAssetsLocations;
}

-(NSString*) getLeaseNameFromLease:(NSString *)lease
{
    NSString *result = nil;
    
    NSFetchRequest *fetchRequest = [ListAssetLocations fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"grandparentPropNum == %@ AND propType == 'Production'", lease];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrListAssetsLocation = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return result;
    }
    if (arrListAssetsLocation.count > 0) {
        ListAssetLocations *list = arrListAssetsLocation[0];
        result = list.codeProperty;
    }
    
    return result;
}

-(NSString*) getLeaseNameFromPropNum:(NSString *)propNum
{
    NSString *result = nil;
    
    NSFetchRequest *fetchRequest = [ListAssetLocations fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propNum == %@", propNum];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrListAssetsLocation = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return result;
    }
    if (arrListAssetsLocation.count > 0) {
        ListAssetLocations *list = arrListAssetsLocation[0];
        result = list.codeProperty;
    }
    
    return result;
}


#pragma mark - Get RigReports Data
-(NSArray*) getRigReportsByDate
{
    NSDate *curDate = [NSDate date];
    
    NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
    NSTimeInterval totalSecondsInWeek = [daysToSync intValue] * 24 * 60 * 60;
    NSDate *entryDate = [NSDate dateWithTimeIntervalSinceNow:-totalSecondsInWeek];
    
    NSMutableArray *arrRigReports = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [RigReports fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(reportDate >= %@) AND (reportDate < %@)", entryDate, curDate];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reportDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrReportsData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrReportsData.count == 0) {
        return arrRigReports;
    }
    
    RigReports *firstModel = arrReportsData[0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *sortValue = [df stringFromDate:firstModel.reportDate];
    NSMutableArray *arrSubRigReports = [[NSMutableArray alloc] init];
    
    for (RigReports *rigReport in arrReportsData) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        
        NSString *reportDate = [df stringFromDate:rigReport.reportDate];
        if (![sortValue isEqual:reportDate]) {
            
            NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSubRigReports};
            [arrRigReports addObject:dic];
            
            sortValue = reportDate;
            arrSubRigReports = [[NSMutableArray alloc] init];
            
        }
        
        [arrSubRigReports addObject:rigReport];
    }
    
    // add last sub array to result.
    NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSubRigReports};
    [arrRigReports addObject:dic];
    
    return arrRigReports;
}


-(NSArray*) getRigReportsByLease
{
    NSDate *curDate = [NSDate date];
    
    NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
    NSTimeInterval totalSecondsInWeek = [daysToSync intValue] * 24 * 60 * 60;
    NSDate *entryDate = [NSDate dateWithTimeIntervalSinceNow:-totalSecondsInWeek];
    
    NSMutableArray *arrRigReports = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [RigReports fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(reportDate >= %@) AND (reportDate < %@)", entryDate, curDate];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lease" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *arrReportsData = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrReportsData.count == 0) {
        return arrRigReports;
    }
    
    RigReports *firstModel = arrReportsData[0];
    NSString *sortValue = firstModel.lease;
    NSMutableArray *arrSubRigReports = [[NSMutableArray alloc] init];
    
    for (RigReports *rigReport in arrReportsData) {
        
        if (![sortValue isEqual:rigReport.lease]) {
            
            NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSubRigReports};
            [arrRigReports addObject:dic];
            
            sortValue = rigReport.lease;
            arrSubRigReports = [[NSMutableArray alloc] init];
        }
        
        [arrSubRigReports addObject:rigReport];
    }
    
    // add last sub array to result.
    NSDictionary *dic = @{@"sortvalue":sortValue, @"data":arrSubRigReports};
    [arrRigReports addObject:dic];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sortvalue" ascending:YES];
    NSArray *result = [arrRigReports sortedArrayUsingDescriptors:@[descriptor]];
    return result;
}


-(NSArray*) getRigReportsByWellNum:(NSString*)wellNum withLease:(NSString*)lease
{
    NSArray *arrRigReports = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [RigReports fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wellNum == %@ AND lease == %@", wellNum, lease];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reportDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrRigReports = [context executeFetchRequest:fetchRequest error:&error];
    return arrRigReports;
}

-(NSMutableDictionary*) getCommentsForRigReportsByWellNum:(NSString*)wellNum withLease:(NSString*)lease
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    NSArray *arrRigReports = [[NSArray alloc] init];
//    @property (nullable, nonatomic, copy) NSString *rods;
//    @property (nullable, nonatomic, copy) NSString *tubing;
    //for comments
    NSFetchRequest *fetchRequest = [RigReports fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wellNum == %@ AND lease == %@ AND comments != NULL AND comments != %@", wellNum, lease, @""]; //for Comments
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reportDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrRigReports = [context executeFetchRequest:fetchRequest error:&error];
    [retDic setObject:[arrRigReports copy] forKey:@"comments"];
    
    // for rods
    predicate = [NSPredicate predicateWithFormat:@"wellNum == %@ AND lease == %@ AND rods != NULL AND rods != %@", wellNum, lease, @""]; //for rods
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrRigReports = [context executeFetchRequest:fetchRequest error:&error];
    [retDic setObject:[arrRigReports copy] forKey:@"rods"];
    
    // for tubing
    predicate = [NSPredicate predicateWithFormat:@"wellNum == %@ AND lease == %@ AND tubing != NULL AND tubing != %@", wellNum, lease, @""]; //for tubing
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    arrRigReports = [context executeFetchRequest:fetchRequest error:&error];
    [retDic setObject:[arrRigReports copy] forKey:@"tubing"];
    
    return retDic;
}


#pragma mark - rod data
-(NSMutableArray*) getRigReportsRods:(int)reportID inOut:(BOOL)isIn withAppID:(NSString*)reportAppID
{
    NSArray *arrResult = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [RigReportsRods fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reportAppID == %@ AND inOut == NO", reportAppID];
    if (isIn) {
        predicate = [NSPredicate predicateWithFormat:@"reportAppID == %@ AND inOut == YES", reportAppID];
    }
    
    if (reportAppID == nil)
    {
        if (isIn) {
            predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND inOut == YES", reportID];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND inOut == NO", reportID];
        }
    }
    
    [fetchRequest setPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rodOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableArray alloc] init];
    }
    
    return [arrResult mutableCopy];
}

-(NSArray*) getRodSize
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequestRoute = [RodSize fetchRequest];
    
    NSError *error;
    NSArray *arrRodSize = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (error || arrRodSize.count == 0) {
        return [[NSArray alloc] init];
    } else
    {
        for (RodSize *rodSize in arrRodSize) {
            [arrResult addObject:rodSize.rodSize];
        }
    }
    
    return arrResult;
}

-(NSArray*) getRodTypes
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequestRoute = [RodType fetchRequest];
    
    NSError *error;
    NSArray *arrRodType = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (!error && arrRodType.count > 0) {
        
        for (RodType *rodType in arrRodType) {
            [arrResult addObject:rodType.rodType];
        }
    }
    
    return arrResult;
}

-(NSArray*) getRodLength
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequestRoute = [RodLength fetchRequest];
    
    NSError *error;
    NSArray *arrRodLength = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (error || arrRodLength.count == 0) {
        return [[NSArray alloc] init];
    } else
    {
        for (RodLength *rodLength in arrRodLength) {
            [arrResult addObject:rodLength.rodSize];
        }
    }
    
    return arrResult;
}


-(NSMutableArray*) getRigReportsPump:(int)reportID inOut:(BOOL)isIn withAppID:(NSString *)reportAppID
{
    NSArray *arrResult = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [RigReportsPump fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reportAppID == %@ AND inOut == NO", reportAppID];
    if (isIn) {
        predicate = [NSPredicate predicateWithFormat:@"reportAppID == %@ AND inOut == YES", reportAppID];
    }
    
    if (reportAppID == nil)
    {
        if (isIn) {
            predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND inOut == YES", reportID];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND inOut == NO", reportID];
        }
    }
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pumpOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableArray alloc] init];
    }
    
    return [arrResult mutableCopy];
}

-(NSArray*) getPumpSize
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequestRoute = [PumpSize fetchRequest];
    
    NSError *error;
    NSArray *arrPumpSize = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (error || arrPumpSize.count == 0) {
        return [[NSArray alloc] init];
    } else
    {
        for (PumpSize *pumpSize in arrPumpSize) {
            [arrResult addObject:pumpSize.size];
        }
    }
    
    return arrResult;
}

-(NSArray*) getPumpType
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequestRoute = [PumpType fetchRequest];
    
    NSError *error;
    NSArray *arrPumpType = [context executeFetchRequest:fetchRequestRoute error:&error];
    if (error || arrPumpType.count == 0) {
        return [[NSArray alloc] init];
    } else
    {
        for (PumpType *pumpType in arrPumpType) {
            [arrResult addObject:pumpType.pumpType];
        }
    }
    
    return arrResult;
}


-(NSMutableArray*) getRigReportsTubing:(int)reportID inOut:(BOOL)isIn withAppID:(NSString *)reportAppID
{
    NSArray *arrResult = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [RigReportsTubing fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reportAppID == %@ AND inOut == NO", reportAppID];
    if (isIn) {
        predicate = [NSPredicate predicateWithFormat:@"reportAppID == %@ AND inOut == YES", reportAppID];
    }
    
    if (reportAppID == nil)
    {
        if (isIn) {
            predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND inOut == YES", reportID];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND inOut == NO", reportID];
        }
    }
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tubingOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSMutableArray alloc] init];
    }
    
    return [arrResult mutableCopy];
}

-(NSArray*) getTubingSize
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [TubingSize fetchRequest];
    
    NSError *error;
    NSArray *arrTubingSize = [context executeFetchRequest:fetchRequest error:&error];
    if (error || arrTubingSize.count == 0) {
        return [[NSArray alloc] init];
    } else
    {
        for (TubingSize *tubingSize in arrTubingSize) {
            [arrResult addObject:tubingSize.tbgSize];
        }
    }
    
    return arrResult;
}

-(NSArray*) getTubingType
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [TubingType fetchRequest];
    
    NSError *error;
    NSArray *arrTubingType = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error || arrTubingType.count == 0) {
        return [[NSArray alloc] init];
    } else {
        for (TubingType *tubingType in arrTubingType) {
            [arrResult addObject:tubingType.tbgType];
        }
    }
    
    return arrResult;
}

-(NSArray*) getTubingLength
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *model = [NSEntityDescription entityForName:@"TubingLength" inManagedObjectContext:context];
    [fetchRequest setEntity:model];
    
    NSError *error;
    NSArray *arrTubingLength = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error || arrTubingLength.count == 0) {
        return [[NSArray alloc] init];
    } else {
        for (TubingLength *tubingLength in arrTubingLength) {
            [arrResult addObject:tubingLength.tbgLength];
        }
    }
    
    return arrResult;
}

#pragma mark - Toolbox

-(NSArray*) getAllPumpInfo
{
    NSArray *arrPumpInfo = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [WaterPumpInfo fetchRequest];
    
    NSError *error;
    arrPumpInfo = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return [[NSArray alloc] init];
    }
    
    return arrPumpInfo;
}

#pragma mark - add data

-(BOOL) addTankGaugeEntry:(NSDictionary *)dicData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    NSString *strGaugeTime = [dicData valueForKey:@"gaugeTime"];
    NSDate *gaugeTime = [dateFormatter dateFromString:strGaugeTime];
    NSString *lease = [dicData valueForKey:@"lease"];
    int tankGaugeId = [[dicData valueForKey:@"tankGaugeId"] intValue];
    
    NSFetchRequest *fetchRequest = [TankGaugeEntry fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tankGaugeID == %d AND lease == %@", tankGaugeId, lease];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    TankGaugeEntry *tankGaugeEntry = nil;
    int userid = [[[NSUserDefaults standardUserDefaults] valueForKey:S_UserID] intValue];
    
    if (!error && arrResult.count > 0) {
        tankGaugeEntry = arrResult[0];
        tankGaugeEntry.userid = userid;
    } else {
        tankGaugeEntry = [NSEntityDescription insertNewObjectForEntityForName:@"TankGaugeEntry" inManagedObjectContext:context];
        
        tankGaugeEntry.tankGaugeID = 0;
        tankGaugeEntry.gaugeTime = gaugeTime;
        tankGaugeEntry.entryTime = [NSDate date];
        tankGaugeEntry.lease = lease;
        
        tankGaugeEntry.userid = userid;
        tankGaugeEntry.deviceID = [NSString stringWithFormat:@"%05d", userid];
    }
    
    tankGaugeEntry.tankGaugeID = tankGaugeId;
    tankGaugeEntry.comments = [dicData valueForKey:@"comment"];
    tankGaugeEntry.downloaded = NO;
    tankGaugeEntry.gaugeTime = gaugeTime;
    NSArray *arrTankData = [dicData objectForKey:@"tankheights"];
    
    for (int i = 0; i < arrTankData.count; i++) {
        NSDictionary *dic = arrTankData[i];
        int tankID = [[dic valueForKey:@"tankID"] intValue];
        int oilFeet = [[dic valueForKey:@"oilFeet"] intValue];
        
        switch (i) {
            case 0:
                tankGaugeEntry.tankID1 = tankID;
                tankGaugeEntry.oilFeet1 = oilFeet;
                break;
            case 1:
                tankGaugeEntry.tankID2 = tankID;
                tankGaugeEntry.oilFeet2 = oilFeet;
                break;
            case 2:
                tankGaugeEntry.tankID3 = tankID;
                tankGaugeEntry.oilFeet3 = oilFeet;
                break;
            case 3:
                tankGaugeEntry.tankID4 = tankID;
                tankGaugeEntry.oilFeet4 = oilFeet;
                break;
            case 4:
                tankGaugeEntry.tankID5 = tankID;
                tankGaugeEntry.oilFeet5 = oilFeet;
                break;
            case 5:
                tankGaugeEntry.tankID6 = tankID;
                tankGaugeEntry.oilFeet6 = oilFeet;
                break;
            case 6:
                tankGaugeEntry.tankID7 = tankID;
                tankGaugeEntry.oilFeet7 = oilFeet;
                break;
            case 7:
                tankGaugeEntry.tankID8 = tankID;
                tankGaugeEntry.oilFeet8 = oilFeet;
                break;
            case 8:
                tankGaugeEntry.tankID9 = tankID;
                tankGaugeEntry.oilFeet9 = oilFeet;
                break;
            case 9:
                tankGaugeEntry.tankID10 = tankID;
                tankGaugeEntry.oilFeet10 = oilFeet;
                break;
                
            default:
                break;
        }
        
    }
    
    if (![context save:&error]) {
        NSLog(@"Error saving database");
        return NO;
    }
    
    [[AppData sharedInstance] uploadTankGaugeEntries:@[tankGaugeEntry] isAll:NO];

    return YES;
}


-(BOOL) addRunTicket:(NSDictionary *)dicData
{
    NSString *lease = [dicData valueForKey:@"lease"];
    int tankNumber = [[dicData valueForKey:@"tankID"] intValue];
    NSString *ticketNumber = [dicData valueForKey:@"ticketNumber"];
    int ticketId = [[dicData valueForKey:@"internalTicketID"] intValue];
    
    NSFetchRequest *fetchRequest = [RunTickets fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND tankNumber == %d AND ticketNumber == %@ AND internalTicketID == %d", lease, tankNumber, ticketNumber, ticketId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    RunTickets *ticket = nil;
    if (!error && arrResult.count > 0) {
        ticket = arrResult[0];
    } else {
        ticket = [NSEntityDescription insertNewObjectForEntityForName:@"RunTickets" inManagedObjectContext:context];
        ticket.lease = lease;
        ticket.tankNumber = tankNumber;
        ticket.ticketNumber = ticketNumber;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    ticket.entryTime = [NSDate date];
    NSString *strTicketTime = [dicData valueForKey:@"ticketTime"];
    ticket.ticketTime = [dateFormatter dateFromString:strTicketTime];
    
    ticket.deviceID = [dicData valueForKey:@"deviceID"];
    
    ticket.temp1 = [[dicData valueForKey:@"temp1"] intValue];
    
    int gauge1 = [[dicData valueForKey:@"gauge1"] intValue];
    
    int feet = gauge1 / 4 / 12;
    int inches = floorf(gauge1 / 4.0f) - feet * 12;
    int quarter_inches = (gauge1 / 4.0f - feet * 12 - inches) / 0.25f;
    
    ticket.oilFeet1 = feet;
    ticket.oilInch1 = inches;
    ticket.oilFraction1 = quarter_inches;
    
    int bottom1 = [[dicData valueForKey:@"bottom1"] intValue];
    feet = bottom1 / 4 / 12;
    inches = floorf(bottom1 / 4.0f) - feet * 12;
    
    ticket.bottomsFeet1 = feet;
    ticket.bottomsInch1 = inches;
    
    ticket.temp2 = [[dicData valueForKey:@"temp2"] intValue];
    int gauge2 = [[dicData valueForKey:@"gauge2"] intValue];
    
    feet = gauge2 / 4 / 12;
    inches = floorf(gauge2 / 4.0f) - feet * 12;
    quarter_inches = (gauge2 / 4.0f - feet * 12 - inches) / 0.25f;
    
    ticket.oilFeet2 = feet;
    ticket.oilInch2 = inches;
    ticket.oilFraction2 = quarter_inches;
    
    int bottom2 = [[dicData valueForKey:@"bottom2"] intValue];
    feet = bottom2 / 4 / 12;
    inches = floorf(bottom2 / 4.0f) - feet * 12;
    ticket.bottomsFeet2 = feet;
    ticket.bottomsInch2 = inches;
    
    ticket.obsGrav = [dicData valueForKey:@"obsGrav"];
    ticket.obsTemp = [[dicData valueForKey:@"obsTemp"] intValue];
    ticket.bsw = [dicData valueForKey:@"bsw"];
    ticket.grossVol = [dicData valueForKey:@"grossVol"];
    ticket.netVol = [dicData valueForKey:@"netVol"];
    ticket.timeOn = [dateFormatter dateFromString:[dicData valueForKey:@"timeOn"]];
    ticket.timeOff = [dateFormatter dateFromString:[dicData valueForKey:@"timeOff"]];
    ticket.carrier = [dicData valueForKey:@"carrier"];
    ticket.driver = [dicData valueForKey:@"driver"];
    ticket.comments = [[dicData valueForKey:@"comments"] isEqual:@""] ? nil : [dicData valueForKey:@"comments"];
    //    ticket.glMonth = [[dicData valueForKey:@"glMonth"] intValue];
    //    ticket.glYear = [[dicData valueForKey:@"glYear"] intValue];
    
    ticket.ticketOption = [[dicData valueForKey:@"ticketOption"] intValue];
    ticket.ticketImage = [dicData valueForKey:@"ticketImage"];
    
    ticket.userid = [[dicData valueForKey:@"userid"] intValue];
    ticket.deleted = NO;
    ticket.downloaded = NO;
    
    if (![context save:&error]) {
        NSLog(@"Error saving database");
        return NO;
    }
    
    [[AppData sharedInstance] uploadRunTickets:@[ticket] isAll:NO];
    
    return YES;
}

-(BOOL) deleteRunTicket:(int)ticketId ticketNumber:(NSString*)ticketNumber
{
    NSFetchRequest *fetchRequest = [RunTickets fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"internalTicketID == %d AND ticketNumber == %@", ticketId, ticketNumber];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrResult.count > 0) {
        
        for (RunTickets *runTicket in arrResult) {
            runTicket.deleted = YES;
            runTicket.downloaded = NO;
            
            if (![context save:&error]) {
                return NO;
            }
        }
        [[AppData sharedInstance] uploadRunTickets:arrResult isAll:NO];
    }

    return YES;
}


-(BOOL) addMeterData:(NSDictionary *)dicData
{
    int dataId = [[dicData valueForKey:@"dataId"] intValue];
    NSString *meterType = [dicData valueForKey:@"metertype"];
    NSString *lease = [dicData valueForKey:@"lease"];
    int meterID = [[dicData valueForKey:@"meterid"] intValue];
    
    int userid = [[dicData valueForKey:@"userid"] intValue];
    NSString *deviceid = [dicData valueForKey:@"deviceID"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    NSDate *checkTime = [dateFormatter dateFromString:[dicData valueForKey:@"checkTime"]];
    NSString *meterProblem = [dicData valueForKey:@"meterProblem"];
    
    NSString *currentFlow = [dicData valueForKey:@"currentFlow"];
    NSString *yesterdayFlow = [dicData valueForKey:@"yesterdayFlow"];
    NSString *comments = [dicData valueForKey:@"comments"];
    
    if ([meterType isEqual:@"Gas"]) {
        
        NSFetchRequest *fetchRequest = [GasMeterData fetchRequest];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dataID == %d AND lease == %@ AND idGasMeter == %d", dataId, lease, meterID];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
        
        GasMeterData *gasMeterData = nil;
        
        if (!error && arrResult.count > 0) {
            gasMeterData = arrResult[0];
        } else {
            gasMeterData = [NSEntityDescription insertNewObjectForEntityForName:@"GasMeterData" inManagedObjectContext:context];
            gasMeterData.entryTime = [NSDate date];
            gasMeterData.checkTime = checkTime;
            gasMeterData.lease = lease;
            
            gasMeterData.idGasMeter = meterID;
        }
        
        gasMeterData.dataID = dataId;
        gasMeterData.deviceID = deviceid;
        
        gasMeterData.meterProblem = meterProblem;
        gasMeterData.currentFlow = currentFlow;
        gasMeterData.yesterdayFlow = yesterdayFlow;
        
        gasMeterData.meterCumVol = [dicData valueForKey:@"meterCumVol"];
        gasMeterData.linePressure = [dicData valueForKey:@"linePressure"];
        gasMeterData.diffPressure = [dicData valueForKey:@"diffPressure"];
        gasMeterData.comments = comments;
        
        gasMeterData.userid = userid;
        gasMeterData.downloaded = NO;
        
        if (![context save:&error]) {
            NSLog(@"Error saving database");
            return NO;
        }
        
        [[AppData sharedInstance] uploadGasMeterData:@[gasMeterData] isAll:NO];
        
    } else {
        
        NSFetchRequest *fetchRequest = [WaterMeterData fetchRequest];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wmdID == %d AND lease == %@ AND meterNum == %d", dataId, lease, meterID];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
        
        WaterMeterData *waterMeterData = nil;
        
        if (!error && arrResult.count > 0) {
            waterMeterData = arrResult[0];
        } else {
            waterMeterData = [NSEntityDescription insertNewObjectForEntityForName:@"WaterMeterData" inManagedObjectContext:context];
            waterMeterData.entryTime = [NSDate date];
            waterMeterData.checkTime = checkTime;
            waterMeterData.lease = lease;
            waterMeterData.meterNum = meterID;
        }
        
        waterMeterData.wmdID = dataId;
        waterMeterData.deviceID = deviceid;
        
        waterMeterData.meterProblem = meterProblem;
        waterMeterData.currentFlow = currentFlow;
        waterMeterData.yesterdayFlow = yesterdayFlow;
        
        waterMeterData.totalVolume = [dicData valueForKey:@"totalVolume"];
        waterMeterData.resetVolume = [dicData valueForKey:@"resetVolume"];
        waterMeterData.comments = comments;
        
        waterMeterData.userid = userid;
        waterMeterData.downloaded = NO;
        
        if (![context save:&error]) {
            NSLog(@"Error saving database");
            return NO;
        }
        
        [[AppData sharedInstance] uploadWaterMeterData:@[waterMeterData] isAll:NO];
    }
    
    return YES;
}


-(BOOL) addWellheadData:(NSDictionary *)dicData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    NSString *lease = [dicData valueForKey:@"lease"];
    NSString *wellNumber = [dicData valueForKey:@"wellNumber"];
    int dataID = [[dicData valueForKey:@"dataID"] intValue];
    
    NSFetchRequest *fetchRequest = [WellheadData fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dataID == %d AND lease == %@ AND wellNumber == %@", dataID, lease, wellNumber];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    WellheadData *wellheadData = nil;
    
    if (!error && arrResult.count > 0) {
        wellheadData = arrResult[0];
    } else {
        wellheadData = [NSEntityDescription insertNewObjectForEntityForName:@"WellheadData" inManagedObjectContext:context];
        wellheadData.lease = lease;
        wellheadData.wellNumber = wellNumber;
    }
    
    wellheadData.dataID = dataID;
    NSDate *checkTime = [dateFormatter dateFromString:[dicData valueForKey:@"checkTime"]];
    wellheadData.checkTime = checkTime;
    wellheadData.entryTime = [NSDate date];
    wellheadData.deviceID = [dicData valueForKey:@"deviceID"];
    
    wellheadData.wellProblem = [dicData valueForKey:@"wellProblem"];
    wellheadData.prodType = [dicData valueForKey:@"prodType"];
    wellheadData.choke = [dicData valueForKey:@"choke"];
    
    wellheadData.pumpSize = [dicData valueForKey:@"pumpSize"];
    wellheadData.spm = [dicData valueForKey:@"spm"];
    wellheadData.strokeSize = [dicData valueForKey:@"strokeSize"];
    wellheadData.timeOn = [dicData valueForKey:@"timeOn"];
    wellheadData.timeOff = [dicData valueForKey:@"timeOff"];
    
    wellheadData.casingPressure = [dicData valueForKey:@"casingPressure"];
    wellheadData.tubingPressure = [dicData valueForKey:@"tubingPressure"];
    wellheadData.bradenheadPressure = [dicData valueForKey:@"bradenheadPressure"];
    
    wellheadData.waterCut = [dicData valueForKey:@"waterCut"];
    wellheadData.emulsionCut = [dicData valueForKey:@"emulsionCut"];
    wellheadData.oilCut = [dicData valueForKey:@"oilCut"];
    
    wellheadData.pound = [dicData valueForKey:@"pound"];
    wellheadData.statusArrival = [[dicData valueForKey:@"statusArrival"] isEqual:@"On"] ? YES : NO;
    wellheadData.statusDepart = [[dicData valueForKey:@"statusDepart"] isEqual:@"On"] ? YES : NO;
    wellheadData.espHz = [dicData valueForKey:@"espHz"];
    wellheadData.espAmp = [dicData valueForKey:@"espAmp"];
    
    wellheadData.comments = [dicData valueForKey:@"comments"];
    
    int userid = [[dicData valueForKey:@"userid"] intValue];
    wellheadData.userid = userid;
    wellheadData.downloaded = NO;
    
    if (![context save:&error]) {
        NSLog(@"Error saving database");
        return NO;
    }
    
    [[AppData sharedInstance] uploadWellheadData:@[wellheadData] isAll:NO];
    
    return YES;
}


#pragma mark - New Invoice
-(BOOL) createInvoices:(NSDictionary *)dicData
{
    NSArray *arrAccounts = [dicData objectForKey:@"accountdata"];
    NSArray *arrPeoples = [dicData objectForKey:@"peopledata"];
    
    NSString *lease = [dicData valueForKey:@"lease"];
    NSString *strDate = [dicData valueForKey:@"date"];
    int userid = [[dicData valueForKey:@"userid"] intValue];
    NSString *deviceid = [dicData valueForKey:@"deviceid"];
    NSString *wellNumber = [dicData valueForKey:@"wellNumber"];
    NSString *company = [dicData valueForKey:@"company"];
    NSString *comments = [dicData valueForKey:@"comments"];
    NSString *tubingComments = [dicData valueForKey:@"tubingComments"];
    NSString *rodComments = [dicData valueForKey:@"rodComments"];
    NSString *dailyCost = [dicData valueForKey:@"dailyCost"];
    NSString *totalCost = [dicData valueForKey:@"totalCost"];
    NSArray *invoiceImageString = [[dicData valueForKey:@"invoiceImages"] copy];
    NSMutableArray *aryInvoiceImages = [[NSMutableArray alloc] init];
    for (NSString *imageString in invoiceImageString) {
        [aryInvoiceImages addObject:[NSDictionary dictionaryWithObjectsAndKeys:imageString, @"Image", @"0", @"ImageID", nil]];
    }
    
    Invoices *invoice = [NSEntityDescription insertNewObjectForEntityForName:@"Invoices" inManagedObjectContext:context];
    
    invoice.invoiceID = 0;
    invoice.downloaded = NO;
    invoice.deleted = NO;
    invoice.lease = lease;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:strDate];
    invoice.invoiceDate = date;
    
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *invoiceAppID = [NSString stringWithFormat:@"%@%05d", [dateFormatter stringFromDate:date], userid];
    invoice.invoiceAppID = invoiceAppID;
    
    invoice.wellNumber = wellNumber;
    invoice.deviceID = deviceid;
    invoice.company = company;
    invoice.dailyCost = dailyCost;
    invoice.totalCost = totalCost;
    invoice.comments = comments;
    invoice.tubingComments = tubingComments;
    invoice.rodComments = rodComments;
    invoice.invoiceImages = aryInvoiceImages;
    invoice.userid = userid;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving database");
        return NO;
    } else {
        
        for (NSDictionary *dicAccount in arrAccounts)
        {
            InvoicesDetail *invoiceDetail = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicesDetail" inManagedObjectContext:context];
            
            invoiceDetail.invoiceAppID = invoiceAppID;
            invoiceDetail.account = [[dicAccount valueForKey:@"account"] intValue];
            invoiceDetail.accountSub = [[dicAccount valueForKey:@"accountSub"] intValue];
            invoiceDetail.accountTime = [dicAccount valueForKey:@"accountTime"];
            invoiceDetail.accountUnit = [dicAccount valueForKey:@"accountUnit"];
            
            invoiceDetail.downloaded = NO;
            invoiceDetail.deleted = NO;
            
            if (![context save:&error]) {
                return NO;
            }
        }
        
        for (Personnel *personnel in arrPeoples)
        {
            InvoicesPersonnel *invoicePersonnel = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicesPersonnel" inManagedObjectContext:context];
            
            invoicePersonnel.invoiceAppID = invoiceAppID;
            invoicePersonnel.userID = personnel.userid;
            
            invoicePersonnel.downloaded = NO;
            invoicePersonnel.deleted = NO;
            
            if (![context save:&error]) {
                return NO;
            }
        }
    }
    
    [[AppData sharedInstance] uploadInvoiceData:@[invoice] isAll:NO];

    return YES;
}

#pragma mark - Edit Invoice
-(BOOL) editInvoices:(NSDictionary *)dicData
{
    NSArray *arrAccounts = [dicData objectForKey:@"accountdata"];
    NSArray *arrPeoples = [dicData objectForKey:@"peopledata"];
    
    NSString *lease = [dicData valueForKey:@"lease"];
    NSString *strDate = [dicData valueForKey:@"date"];
    int userid = [[dicData valueForKey:@"userid"] intValue];
    NSString *deviceid = [dicData valueForKey:@"deviceid"];
    NSString *wellNumber = [dicData valueForKey:@"wellNumber"];
    NSString *company = [dicData valueForKey:@"company"];
    NSString *comments = [dicData valueForKey:@"comments"];
    NSString *tubingComments = [dicData valueForKey:@"tubingComments"];
    NSString *rodComments = [dicData valueForKey:@"rodComments"];
    NSArray *invoiceImageString = [[dicData valueForKey:@"invoiceImages"] copy];
    int invoiceID = [[dicData valueForKey:@"invoiceID"] intValue];
    NSString *invoiceAppID = [dicData valueForKey:@"invoiceAppID"];
    NSString *dailyCost = [dicData valueForKey:@"dailyCost"];
    NSString *totalCost = [dicData valueForKey:@"totalCost"];
    
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d", invoiceID];
    if (invoiceID == 0) {
        predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@", invoiceAppID];
    }
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrResult.count > 0) {
        
        Invoices *invoice = arrResult[0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:strDate];
        invoice.invoiceDate = date;
        
        dateFormatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *invoiceAppID = [NSString stringWithFormat:@"%@%05d", [dateFormatter stringFromDate:date], userid];
        invoice.invoiceAppID = invoiceAppID;
        invoice.lease = lease;
        invoice.wellNumber = wellNumber;
        invoice.deviceID = deviceid;
        invoice.company = company;
        invoice.comments = comments;
        invoice.dailyCost = dailyCost;
        invoice.totalCost = totalCost;
        
        invoice.tubingComments = tubingComments;
        invoice.rodComments = rodComments;
        invoice.invoiceImages = invoiceImageString;
        invoice.userid = userid;
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Error saving database");
            return NO;
        } else {
            
            //delete original accounts
            if (![self deleteInvoiceDetailsForSpecificInvoice:invoiceID app_id:invoiceAppID]) {
                return NO;
            }
            
            for (NSDictionary *dicAccount in arrAccounts)
            {
                
                InvoicesDetail *invoiceDetail = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicesDetail" inManagedObjectContext:context];
                invoiceDetail.invoiceID = invoiceID;
                invoiceDetail.invoiceAppID = invoiceAppID;
                invoiceDetail.account = [[dicAccount valueForKey:@"account"] intValue];
                invoiceDetail.accountSub = [[dicAccount valueForKey:@"accountSub"] intValue];
                invoiceDetail.accountTime = [dicAccount valueForKey:@"accountTime"];
                invoiceDetail.accountUnit = [dicAccount valueForKey:@"accountUnit"];
                
                invoiceDetail.downloaded = NO;
                invoiceDetail.deleted = NO;
                if (![context save:&error]) {
                    return NO;
                }
            }
            
            //remove original peoples
            if (![self removePersonnelsForSpecificInvoice:invoiceID withAppID:invoiceAppID]) {
                return NO;
            }
            
            for (Personnel *personnel in arrPeoples)
            {
                InvoicesPersonnel *invoicePersonnel = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicesPersonnel" inManagedObjectContext:context];
                invoicePersonnel.invoiceID = invoiceID;
                invoicePersonnel.invoiceAppID = invoiceAppID;
                invoicePersonnel.userID = personnel.userid;
                
                invoicePersonnel.downloaded = NO;
                invoicePersonnel.deleted = NO;
                
                if (![context save:&error]) {
                    return NO;
                }
            }
        }
        [[AppData sharedInstance] uploadInvoiceData:@[invoice] isAll:NO];
    }
    
    return YES;
}

-(BOOL)deleteInvoiceDetailsForSpecificInvoice:(int32_t)invoice_id app_id:(NSString*)app_id {
    
    NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
    if (invoice_id == 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@ AND deleted == NO", app_id];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d AND deleted == NO", invoice_id];
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *error;
    NSArray *arrAccountDetails = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrAccountDetails.count > 0) {
        
        for (InvoicesDetail *tmpAccount in arrAccountDetails) {
            tmpAccount.downloaded = NO;
            tmpAccount.deleted = YES;
            if (![context save:&error]) {
                NSLog(@"Error saving database");
                return NO;
            }
        }
    }
    return YES;
}

-(BOOL) removePersonnelsForSpecificInvoice:(int)invoiceID withAppID:(NSString*)invoiceAppID
{
    NSFetchRequest *fetchRequest = [InvoicesPersonnel fetchRequest];
    
    if (invoiceID == 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@", invoiceAppID];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d", invoiceID];
        [fetchRequest setPredicate:predicate];
    }
    
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrResult.count > 0) {
        
        for (InvoicesPersonnel *invoicePersonnel in arrResult) {
            invoicePersonnel.deleted = YES;
            invoicePersonnel.downloaded = NO;
            
            if (![context save:&error]) {
                return NO;
            }
        }
//        [[AppData sharedInstance] uploadInvoicePersonnelData:arrResult isAll:NO];
    }
    
    return YES;
}


-(BOOL)changeInvoice:(NSDictionary*)dicData
{
    int invoiceID = [[dicData valueForKey:@"invoiceID"] intValue];
    NSString *invoiceAppID = [dicData valueForKey:@"invoiceAppID"];
    
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d", invoiceID];
    if (invoiceID == 0) {
        predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@", invoiceAppID];
    }
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrResult.count > 0) {
        Invoices *invoice = arrResult[0];
        
        invoice.approval0 = [[dicData valueForKey:@"approval0"] boolValue];
        invoice.approvalDt0 = [dicData valueForKey:@"approvalDt0"];
        invoice.app0Emp = [dicData valueForKey:@"app0Emp"];
        
        invoice.approval1 = [[dicData valueForKey:@"approval1"] boolValue];
        invoice.approvalDt1 = [dicData valueForKey:@"approvalDt1"];
        invoice.app1Emp = [dicData valueForKey:@"app1Emp"];
        
        invoice.approval2 = [[dicData valueForKey:@"approval2"] boolValue];
        invoice.approvalDt2 = [dicData valueForKey:@"approvalDt2"];
        invoice.app2Emp = [dicData valueForKey:@"app2Emp"];
        
        invoice.outsideBill = [[dicData valueForKey:@"outsideBill"] boolValue];
        invoice.outsideBillDt = [dicData valueForKey:@"outsideBillDt"];
        invoice.outsideBillEmp = [dicData valueForKey:@"outsideBillEmp"];
        
        invoice.noBill = [[dicData valueForKey:@"noBill"] boolValue];
        invoice.noBillDt = [dicData valueForKey:@"noBillDt"];
        invoice.noBillEmp = [dicData valueForKey:@"noBillEmp"];
        
        invoice.downloaded = NO;
        
        if ([context save:&error]) {
            [[AppData sharedInstance] changedSyncStatus:UploadFailed];
        }
        
    }
    [[AppData sharedInstance] uploadInvoiceData:arrResult isAll:NO];

    return YES;
}

-(BOOL) addInvoiceAccount:(NSDictionary*)dicData
{
    int invoiceID = [dicData valueForKey:@"invoiceID"] == nil ? 0 : [[dicData valueForKey:@"invoiceID"] intValue];
    NSString *invoiceAppID = [dicData valueForKey:@"invoiceAppID"];
    
    int acctID = [[dicData valueForKey:@"acctID"] intValue];
    int subAcctID = [[dicData valueForKey:@"subAcctID"] intValue];
    NSString *acctTime = [dicData valueForKey:@"acctTime"];
    NSString *acctTimeUnit = [dicData valueForKey:@"acctUnit"];
    
    NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
    
    if (invoiceID == 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@ AND account == %d And accountSub == %d", invoiceAppID, acctID, subAcctID];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d AND account == %d And accountSub == %d", invoiceID, acctID, subAcctID];
        [fetchRequest setPredicate:predicate];
    }
    
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrResult.count > 0) {
        
        InvoicesDetail *invoiceDetail = arrResult[0];
        
        invoiceDetail.invoiceID = invoiceID;
        invoiceDetail.invoiceAppID = invoiceAppID;
        invoiceDetail.accountTime = acctTime;
        invoiceDetail.accountUnit = acctTimeUnit;
        
        invoiceDetail.downloaded = NO;
        invoiceDetail.deleted = NO;
        
        if ([context save:&error]) {
            NSLog(@"Error saving database");
            return NO;
        }
        
        [[AppData sharedInstance] uploadInvoiceDetailData:@[invoiceDetail] isAll:NO];
        
    } else {
        InvoicesDetail *invoiceDetail = [NSEntityDescription insertNewObjectForEntityForName:@"InvoicesDetail" inManagedObjectContext:context];
        
        invoiceDetail.invoiceID = invoiceID;
        invoiceDetail.invoiceAppID = invoiceAppID;
        invoiceDetail.account = acctID;
        invoiceDetail.accountSub = subAcctID;
        invoiceDetail.accountTime = acctTime;
        invoiceDetail.accountUnit = acctTimeUnit;
        
        invoiceDetail.downloaded = NO;
        invoiceDetail.deleted = NO;
        
        if (![context save:&error]) {
            NSLog(@"Error saving database");
            return NO;
        }
        [[AppData sharedInstance] uploadInvoiceDetailData:@[invoiceDetail] isAll:NO];
    }
    
    return YES;

}


-(BOOL) changeAccountTime:(NSDictionary*)dicData
{
    int invoiceID = [dicData valueForKey:@"invoiceID"] == nil ? 0 : [[dicData valueForKey:@"invoiceID"] intValue];
    NSString *invoiceAppID = [dicData valueForKey:@"invoiceAppID"];
    
    int acctID = [[dicData valueForKey:@"acctID"] intValue];
    int subAcctID = [[dicData valueForKey:@"subAcctID"] intValue];
    NSString *acctTime = [dicData valueForKey:@"acctTime"];
    
    NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
    
    if (invoiceID == 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@ AND account == %d And accountSub == %d", invoiceAppID, acctID, subAcctID];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d AND account == %d And accountSub == %d", invoiceID, acctID, subAcctID];
        [fetchRequest setPredicate:predicate];
    }
    
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrResult.count > 0) {
        
        InvoicesDetail *invoiceDetail = arrResult[0];
        
        invoiceDetail.accountTime = acctTime;
        invoiceDetail.downloaded = NO;
        
        if ([context save:&error]) {
            return NO;
        }
        
        [[AppData sharedInstance] uploadInvoiceDetailData:@[invoiceDetail] isAll:NO];
    }
    
    return YES;
}

-(BOOL) removeAccountFromInvoice:(NSDictionary*)dicData
{
    int invoiceID = [dicData valueForKey:@"invoiceID"] == nil ? 0 : [[dicData valueForKey:@"invoiceID"] intValue];
    NSString *invoiceAppID = [dicData valueForKey:@"invoiceAppID"];
    
    int acctID = [[dicData valueForKey:@"acctID"] intValue];
    int subAcctID = [[dicData valueForKey:@"subAcctID"] intValue];
    
    NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
    
    if (invoiceID == 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@ AND account == %d And accountSub == %d", invoiceAppID, acctID, subAcctID];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d AND account == %d And accountSub == %d", invoiceID, acctID, subAcctID];
        [fetchRequest setPredicate:predicate];
    }
    
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrResult.count > 0) {
        
        InvoicesDetail *invoiceDetail = arrResult[0];
        
        invoiceDetail.deleted = YES;
        invoiceDetail.downloaded = NO;
        
        if ([context save:&error]) {
            [[AppData sharedInstance] changedSyncStatus:UploadFailed];
            
            NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@ AND deleted == NO", invoiceAppID];
            [fetchRequest setPredicate:predicate];
            
            NSArray *arrInvoicesDetail = [context executeFetchRequest:fetchRequest error:&error];
            if (!error && arrInvoicesDetail.count == 0) {
                if ([self removeInvoice:invoiceID withAppID:invoiceAppID])
                    [self removePersonnels:invoiceID withAppID:invoiceAppID];
            }
        }
        
        [[AppData sharedInstance] uploadInvoiceDetailData:@[invoiceDetail] isAll:NO];
    }
    
    return YES;
}

-(BOOL) removeInvoice:(int)invoiceID withAppID:(NSString*)invoiceAppID
{
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    
    if (invoiceID == 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@", invoiceAppID];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d", invoiceID];
        [fetchRequest setPredicate:predicate];
    }
    
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrResult.count > 0) {
        
        for (Invoices *invoice in arrResult) {
            invoice.deleted = YES;
            invoice.downloaded = NO;
            
            if (![context save:&error]) {
                return NO;
            }
        }
        
        [[AppData sharedInstance] uploadInvoiceData:arrResult isAll:NO];
    }

    return YES;
}
                
-(BOOL) removePersonnels:(int)invoiceID withAppID:(NSString*)invoiceAppID
{
    NSFetchRequest *fetchRequest = [InvoicesPersonnel fetchRequest];
    
    if (invoiceID == 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceAppID == %@", invoiceAppID];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoiceID == %d", invoiceID];
        [fetchRequest setPredicate:predicate];
    }
    
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && arrResult.count > 0) {
        
        for (InvoicesPersonnel *invoicePersonnel in arrResult) {
            invoicePersonnel.deleted = YES;
            invoicePersonnel.downloaded = NO;
            
            if (![context save:&error]) {
                return NO;
            }
        }
        [[AppData sharedInstance] uploadInvoicePersonnelData:arrResult isAll:NO];
    }
    
    return YES;
}


#pragma mark - New Schedule
-(BOOL) createSchedule:(NSDictionary *)dicData
{
    int userID = [[dicData valueForKey:@"userid"] intValue];
    NSArray *arrDates = [dicData objectForKey:@"dates"];
    NSArray *arrComments = [dicData objectForKey:@"comments"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSFetchRequest *fetchRequest = [Schedules fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lease == %@ AND wellNumber == %@ AND scheduleType == %@", [dicData valueForKey:@"lease"], [dicData valueForKey:@"wellnumber"], [dicData valueForKey:@"scheduletype"]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrSchedulesData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error || arrSchedulesData.count == 0) {
        
        Schedules *newSchedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedules" inManagedObjectContext:context];
        
        newSchedule.downloaded = NO;
        newSchedule.lease = [dicData valueForKey:@"lease"];
        newSchedule.wellNumber = [dicData valueForKey:@"wellnumber"];
        newSchedule.scheduleType = [dicData valueForKey:@"scheduletype"];
        newSchedule.entryUserID = userID;
        
        for (NSDictionary *dicDate in arrDates) {
            NSString *key = [dicDate valueForKey:@"key"];
            NSString *strDate = [dicDate valueForKey:@"date"];
            NSDate *date = [dateFormatter dateFromString:strDate];
            
            if ([key isEqual:@"InitPlanStartDt"]) {
                newSchedule.initialPlanStartDt = date;
                newSchedule.entryUserID = userID;
            } else if ([key isEqual:@"UpdatedPlanStartDt"]) {
                newSchedule.updatedPlanStartDt = date;
                newSchedule.updatedPlanUserID = userID;
            } else if ([key isEqual:@"ActualStartDt"]) {
                newSchedule.actualStartDt = date;
                newSchedule.actStartUserID = userID;
            } else if ([key isEqual:@"ActualEndDt"]) {
                newSchedule.actualEndDt = date;
                newSchedule.actEndUserID = userID;
            }
        }
        
        if (newSchedule.updatedPlanStartDt == nil) {
            newSchedule.planStartDt = newSchedule.initialPlanStartDt;
        } else {
            newSchedule.planStartDt = newSchedule.updatedPlanStartDt;
        }
        
        for (NSDictionary *dicComment in arrComments) {
            NSString *key = [dicComment valueForKey:@"key"];
            NSString *comment = [dicComment valueForKey:@"comment"];
            
            if ([key isEqual:@"FieldComments"]) {
                newSchedule.fieldComments = comment;
            } else if ([key isEqual:@"AcctComments"]) {
                newSchedule.acctComments = comment;
            } else if ([key isEqual:@"EngrComments"]) {
                newSchedule.engrComments = comment;
            }
        }
        
        if (newSchedule.actualEndDt != nil) {
            newSchedule.status = @"Completed";
            newSchedule.date = newSchedule.actualEndDt;
        }
        if (newSchedule.actualEndDt == nil && newSchedule.actualStartDt != nil) {
            newSchedule.status = @"Started";
            newSchedule.date = newSchedule.actualStartDt;
        }
        if (newSchedule.actualStartDt == nil && newSchedule.actualEndDt == nil && (newSchedule.initialPlanStartDt != nil || newSchedule.updatedPlanStartDt != nil)) {
            newSchedule.status = @"Scheduled";
            newSchedule.date = newSchedule.planStartDt;
        }
        
        if (![context save:&error]) {
            NSLog(@"Error saving database");
            return NO;
        }
        
        [[AppData sharedInstance] uploadScheduleData:@[newSchedule] isAll:NO];
        
    } else {
        Schedules *schedule = arrSchedulesData[0];
        
        schedule.downloaded = NO;
        schedule.lease = [dicData valueForKey:@"lease"];
        schedule.wellNumber = [dicData valueForKey:@"wellnumber"];
        schedule.scheduleType = [dicData valueForKey:@"scheduletype"];
        schedule.entryUserID = userID;
        
        for (NSDictionary *dicDate in arrDates) {
            NSString *key = [dicDate valueForKey:@"key"];
            NSString *strDate = [dicDate valueForKey:@"date"];
            NSDate *date = [dateFormatter dateFromString:strDate];
            
            if ([key isEqual:@"InitPlanStartDt"]) {
                schedule.initialPlanStartDt = date;
                schedule.entryUserID = userID;
            } else if ([key isEqual:@"UpdatedPlanStartDt"]) {
                schedule.updatedPlanStartDt = date;
                schedule.updatedPlanUserID = userID;
            } else if ([key isEqual:@"ActualStartDt"]) {
                schedule.actualStartDt = date;
                schedule.actStartUserID = userID;
            } else if ([key isEqual:@"ActualEndDt"]) {
                schedule.actualEndDt = date;
                schedule.actEndUserID = userID;
            }
        }
        
        if (schedule.updatedPlanStartDt == nil) {
            schedule.planStartDt = schedule.initialPlanStartDt;
        } else {
            schedule.planStartDt = schedule.updatedPlanStartDt;
        }
        
        for (NSDictionary *dicComment in arrComments) {
            NSString *key = [dicComment valueForKey:@"key"];
            NSString *comment = [dicComment valueForKey:@"comment"];
            
            if ([key isEqual:@"FieldComments"]) {
                schedule.fieldComments = comment;
            } else if ([key isEqual:@"AcctComments"]) {
                schedule.acctComments = comment;
            } else if ([key isEqual:@"EngrComments"]) {
                schedule.engrComments = comment;
            }
        }
        
        if (schedule.actualEndDt != nil) {
            schedule.status = @"Completed";
            schedule.date = schedule.actualEndDt;
        }
        if (schedule.actualEndDt == nil && schedule.actualStartDt != nil) {
            schedule.status = @"Started";
            schedule.date = schedule.actualStartDt;
        }
        if (schedule.actualStartDt == nil && schedule.actualEndDt == nil && (schedule.initialPlanStartDt != nil || schedule.updatedPlanStartDt != nil)) {
            schedule.status = @"Scheduled";
            schedule.date = schedule.planStartDt;
        }
        
        if (![context save:&error]) {
            NSLog(@"Error saving database");
            return NO;
        }
        
        [[AppData sharedInstance] uploadScheduleData:@[schedule] isAll:NO];
    }
    
    return YES;
}


-(BOOL) addRigReports:(NSDictionary *)dicData
{
    NSString *lease = [dicData valueForKey:@"lease"];
    NSString *wellNum = [dicData valueForKey:@"wellNum"];
    int userid = [[dicData valueForKey:@"userid"] intValue];
    NSString *company = [dicData valueForKey:@"company"];
    NSString *strDate = [dicData valueForKey:@"date"];
    NSString *comment = [dicData valueForKey:@"comment"];
    NSString *tubing = [dicData valueForKey:@"tubing"];
    NSString *rods = [dicData valueForKey:@"rods"];
    NSString *dailyCost = [dicData valueForKey:@"dailyCost"];
    NSString *totalCost = [dicData valueForKey:@"totalCost"];
    NSArray *rigImageData = [[dicData valueForKey:@"rigImage"] copy];
    RigReports *rigReports = [NSEntityDescription insertNewObjectForEntityForName:@"RigReports" inManagedObjectContext:context];
    
    rigReports.downloaded = NO;
    rigReports.reportID = 0;
    rigReports.lease = lease;
    rigReports.wellNum = wellNum;
    rigReports.company = company;
    rigReports.dailyCost = dailyCost;
    rigReports.totalCost = totalCost;
    rigReports.rigImages = rigImageData;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    
    NSDate *date = [dateFormatter dateFromString:strDate];
    rigReports.reportDate = date;
    
    rigReports.entryUser = userid;
    rigReports.entryDate = [NSDate date];
    
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    rigReports.reportAppID = [NSString stringWithFormat:@"%@%05d", [dateFormatter stringFromDate:rigReports.entryDate], userid];
    rigReports.comments = comment;
    rigReports.tubing = [tubing isEqual:@""] ? nil : tubing;
    rigReports.rods = [rods isEqual:@""] ? nil : rods;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving database");
        return NO;
    }
    
    [[AppData sharedInstance] uploadRigReports:@[rigReports] isAll:NO];
    
    return YES;
}

-(BOOL) addRigReportsRods:(NSDictionary *)dicData inOut:(BOOL)inOut
{
    NSString *rodSize = [dicData valueForKey:@"rodSize"];
    NSString *rodType = [dicData valueForKey:@"rodType"];
    NSString *rodLength = [dicData valueForKey:@"rodLength"];
    int rodCount = [[dicData valueForKey:@"rodCount"] intValue];
    NSString *rodFootage = [dicData valueForKey:@"rodFootage"];
    NSString *reportAppID = [dicData valueForKey:@"reportAppID"];
    
    NSArray *arrExistingRods = [self getRigReportsRods:0 inOut:inOut withAppID:reportAppID];
    NSInteger rodOrder = arrExistingRods.count + 1;
    
    RigReportsRods *rod = [NSEntityDescription insertNewObjectForEntityForName:@"RigReportsRods" inManagedObjectContext:context];
    
    rod.downloaded = NO;
    rod.rodSize = rodSize;
    rod.rodType = rodType;
    rod.rodLength = rodLength;
    rod.rodCount = rodCount;
    rod.rodFootage = rodFootage;
    rod.rodOrder = rodOrder;
    rod.reportAppID = reportAppID;
    rod.inOut = inOut;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving database");
        return NO;
    }
    
    [[AppData sharedInstance] uploadRigReportsRods:@[rod] isAll:NO];
    
    return YES;
}

-(BOOL) addRigReportsPump:(NSDictionary *)dicData inOut:(BOOL)inOut
{
    NSString *pumpSize = [dicData valueForKey:@"pumpSize"];
    NSString *pumpType = [dicData valueForKey:@"pumpType"];
    NSString *pumpLength = [dicData valueForKey:@"pumpLength"];
    NSString *reportAppID = [dicData valueForKey:@"reportAppID"];
    
    NSArray *arrExistingPump = [self getRigReportsPump:0 inOut:inOut withAppID:reportAppID];
    NSInteger pumpOrder = arrExistingPump.count + 1;
    
    RigReportsPump *pump = [NSEntityDescription insertNewObjectForEntityForName:@"RigReportsPump" inManagedObjectContext:context];
    
    pump.downloaded = NO;
    pump.pumpSize = pumpSize;
    pump.pumpType = pumpType;
    pump.pumpLength = pumpLength;
    pump.pumpOrder = pumpOrder;
    pump.reportAppID = reportAppID;
    pump.inOut = inOut;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving database");
        return NO;
    }
    
    [[AppData sharedInstance] uploadRigReportsPump:@[pump] isAll:NO];
    
    return YES;
}

-(BOOL) addRigReportsTubing:(NSDictionary *)dicData inOut:(BOOL)inOut
{
    NSString *tubingSize = [dicData valueForKey:@"tubingSize"];
    NSString *tubingType = [dicData valueForKey:@"tubingType"];
    NSString *tubingLength = [dicData valueForKey:@"tubingLength"];
    int tubingCount = [[dicData valueForKey:@"tubingCount"] intValue];
    NSString *tubingFootage = [dicData valueForKey:@"tubingFootage"];
    NSString *reportAppID = [dicData valueForKey:@"reportAppID"];
    
    NSArray *arrExistingTubing = [self getRigReportsTubing:0 inOut:inOut withAppID:reportAppID];
    NSInteger tubingOrder = arrExistingTubing.count + 1;
    
    RigReportsTubing *tubing = [NSEntityDescription insertNewObjectForEntityForName:@"RigReportsTubing" inManagedObjectContext:context];
    
    tubing.downloaded = NO;
    tubing.tubingSize = tubingSize;
    tubing.tubingType = tubingType;
    tubing.tubingLength = tubingLength;
    tubing.tubingCount = tubingCount;
    tubing.tubingFootage = tubingFootage;
    tubing.tubingOrder = tubingOrder;
    
    tubing.reportAppID = reportAppID;
    tubing.inOut = inOut;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving database");
        return NO;
    }
    
    [[AppData sharedInstance] uploadRigReportsTubing:@[tubing] isAll:NO];
    
    return YES;
}

-(void) changeRodOrders:(NSMutableArray *)arrChangedRods
{
    for (int order = 0; order < arrChangedRods.count; order++) {
        RigReportsRods *changedRods = arrChangedRods[order];
        
        NSFetchRequest *fetchRequest = [RigReportsRods fetchRequest];
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND reportAppID == %@ AND inOut == NO AND rodSize == %@ AND rodType == %@ AND rodLength == %@ AND rodCount == %d",changedRods.reportID , changedRods.reportAppID, changedRods.rodSize, changedRods.rodType, changedRods.rodLength, changedRods.rodCount];
        if (changedRods.inOut) {
            predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND reportAppID == %@ AND inOut == YES AND rodSize == %@ AND rodType == %@ AND rodLength == %@ AND rodCount == %d", changedRods.reportID, changedRods.reportAppID, changedRods.rodSize, changedRods.rodType, changedRods.rodLength, changedRods.rodCount];
        }
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrResult.count > 0) {
            RigReportsRods *rods = arrResult[0];
            
            if (rods.rodOrder != order+1)
            {
                rods.rodOrder = order+1;
                rods.downloaded = NO;
                
                if ([context save:&error]) {
                    [[AppData sharedInstance] changedSyncStatus:UploadFailed];
                }
            }
            [[AppData sharedInstance] uploadRigReportsRods:@[rods] isAll:NO];
        }
    }
    
}

-(void) changeTubingOrders:(NSMutableArray *)arrChangedTubing
{
    for (int order = 0; order < arrChangedTubing.count; order++) {
        RigReportsTubing *changedTubing = arrChangedTubing[order];
        
        NSFetchRequest *fetchRequest = [RigReportsTubing fetchRequest];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND reportAppID == %@ AND inOut == NO AND tubingSize == %@ AND tubingType == %@ AND tubingLength == %@ AND tubingCount == %d",changedTubing.reportID, changedTubing.reportAppID, changedTubing.tubingSize, changedTubing.tubingType, changedTubing.tubingLength, changedTubing.tubingCount];
        
        if (changedTubing.inOut) {
            predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND reportAppID == %@ AND inOut == YES AND tubingSize == %@ AND tubingType == %@ AND tubingLength == %@ AND tubingCount == %d", changedTubing.reportID, changedTubing.reportAppID, changedTubing.tubingSize, changedTubing.tubingType, changedTubing.tubingLength, changedTubing.tubingCount];
        }
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrResult.count > 0) {
            RigReportsTubing *tubing = arrResult[0];
            
            if (tubing.tubingOrder != (order + 1))
            {
                tubing.tubingOrder = order + 1;
                tubing.downloaded = NO;
                
                if ([context save:&error]) {
                    [[AppData sharedInstance] changedSyncStatus:UploadFailed];
                }
            }
            
            [[AppData sharedInstance] uploadRigReportsTubing:@[tubing] isAll:NO];
        }
    }
    
}

-(void) changePumpOrders:(NSMutableArray *)arrChangedPump
{
    for (int order = 0; order < arrChangedPump.count; order++) {
        RigReportsPump *changedPump = arrChangedPump[order];
        
        NSFetchRequest *fetchRequest = [RigReportsPump fetchRequest];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND reportAppID == %@ AND inOut == NO AND pumpSize == %@ AND pumpType == %@ AND pumpLength == %@", changedPump.reportID, changedPump.reportAppID, changedPump.pumpSize, changedPump.pumpType, changedPump.pumpLength];
        
        if (changedPump.inOut) {
            predicate = [NSPredicate predicateWithFormat:@"reportID == %d AND reportAppID == %@ AND inOut == YES AND pumpSize == %@ AND pumpType == %@ AND pumpLength == %@", changedPump.reportID, changedPump.reportAppID, changedPump.pumpSize, changedPump.pumpType, changedPump.pumpLength];
        }
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
        if (!error && arrResult.count > 0) {
            RigReportsPump *pump = arrResult[0];
            
            if (pump.pumpOrder != (order + 1))
            {
                pump.pumpOrder = order + 1;
                pump.downloaded = NO;
                
                if ([context save:&error]) {
                    [[AppData sharedInstance] changedSyncStatus:UploadFailed];
                }
            }
            
            [[AppData sharedInstance] uploadRigReportsPump:@[pump] isAll:NO];
        }
    }
}

#pragma mark - sync
-(void) syncData
{
    NSLog(@"Sync Start");
    [AppData sharedInstance].successCount = 0;
    [AppData sharedInstance].failedCount = 0;
    
    if ([WebServiceManager connectedToNetwork]) {
        [self syncRunTicketsData];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Failed" message:@"Please check your connectivity." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

-(void) syncRunTicketsData
{
    NSFetchRequest *fetchRequest = [RunTickets fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrTickets = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrTickets.count > 0) {
        [[AppData sharedInstance] uploadRunTickets:arrTickets];
    } else {
        [self syncTankGaugeEntryData];
    }
}

-(void) syncTankGaugeEntryData
{
    NSFetchRequest *fetchRequest = [TankGaugeEntry fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrTankGaugeEntries = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrTankGaugeEntries.count > 0) {
        [[AppData sharedInstance] uploadTankGaugeEntries:arrTankGaugeEntries];
    } else {
        [self syncGasMeterData];
    }
}

-(void) syncGasMeterData
{
    NSFetchRequest *fetchRequest = [GasMeterData fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrGasMeterData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrGasMeterData.count > 0) {
        [[AppData sharedInstance] uploadGasMeterData:arrGasMeterData];
    } else {
        [self syncWaterMeterData];
    }
}

-(void) syncWaterMeterData
{
    NSFetchRequest *fetchRequest = [WaterMeterData fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrWaterMeterData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrWaterMeterData.count > 0) {
        [[AppData sharedInstance] uploadWaterMeterData:arrWaterMeterData];
    } else {
        [self syncWellheadData];
    }
}

-(void) syncWellheadData
{
    NSFetchRequest *fetchRequest = [WellheadData fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrWellheadData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrWellheadData.count > 0) {
        [[AppData sharedInstance] uploadWellheadData:arrWellheadData];
    } else {
        [self syncInvoicesData];
    }
}

-(void) syncInvoicesData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityModel = [NSEntityDescription entityForName:@"Invoices" inManagedObjectContext:context];
    [fetchRequest setEntity:entityModel];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrInvoicesData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrInvoicesData.count > 0) {
        [[AppData sharedInstance] uploadInvoiceData:arrInvoicesData];
    } else {
        [self syncInvoicesDetailData];
    }
}

-(void) syncInvoicesDetailData
{
    NSArray *arrData = [self getUpdatedInvoicesDetails];
    if (arrData && arrData.count > 0) {
        [[AppData sharedInstance] uploadInvoiceDetailData:arrData];
    } else {
        [self syncInvoicesPersonnel];
    }
}

-(void) syncInvoicesPersonnel
{
    NSArray *arrData = [self getUpdatedInvoicesPersonnel];
    
    if (arrData && arrData.count > 0) {
        [[AppData sharedInstance] uploadInvoicePersonnelData:arrData];
    } else {
        [self syncSchedulesData];
    }
}

-(void) syncSchedulesData
{
    NSFetchRequest *fetchRequest = [Schedules fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrSchedulesData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrSchedulesData.count > 0) {
        [[AppData sharedInstance] uploadScheduleData:arrSchedulesData];
    } else {
        [self syncRigReports];
    }
}

-(void) syncRigReports
{
    NSFetchRequest *fetchRequest = [RigReports fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrRigReports = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrRigReports.count > 0) {
        [[AppData sharedInstance] uploadRigReports:arrRigReports];
    } else {
        [self syncRigReportsRods];
    }
}

-(void) syncRigReportsRods
{
    NSFetchRequest *fetchRequest = [RigReportsRods fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrRigReportsRods = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrRigReportsRods.count > 0) {
        [[AppData sharedInstance] uploadRigReportsRods:arrRigReportsRods];
    } else {
        [self syncRigReportsPump];
    }
}

-(void) syncRigReportsPump
{
    NSFetchRequest *fetchRequest = [RigReportsPump fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrRigReportsPump = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrRigReportsPump.count > 0) {
        [[AppData sharedInstance] uploadRigReportsPump:arrRigReportsPump];
    } else {
        [self syncRigReportsTubing];
    }
}

-(void) syncRigReportsTubing
{
    NSFetchRequest *fetchRequest = [RigReportsTubing fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrRigReportsTubing = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error && arrRigReportsTubing.count > 0) {
        [[AppData sharedInstance] uploadRigReportsTubing:arrRigReportsTubing];
    } else {
        [AppData sharedInstance].isSyncing = NO;
        [[AppData sharedInstance] downloadData:NO];
    }
}

#pragma mark - get updated data
-(NSArray*) getUpdatedInvoicesDetails
{
    NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrData = [context executeFetchRequest:fetchRequest error:&error];
    
    return arrData;
}
-(NSArray*) getUpdatedInvoicesPersonnel
{
    NSFetchRequest *fetchRequest = [InvoicesPersonnel fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrData = [context executeFetchRequest:fetchRequest error:&error];
    
    return arrData;
}

#pragma mark -
-(void) uploadedRunTickets:(NSArray*)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [RunTickets fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (RunTickets *runTickets in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                runTickets.downloaded = YES;
                [context save:&error];
            } else {
                for (RunTickets *uploadedRunTicket in arrData) {
                    if ([runTickets isEqual:uploadedRunTicket]) {
                        runTickets.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
        }
    }
}

-(void) uploadedTankGaugeEntries:(NSArray*)arrData
{
    NSFetchRequest *fetchRequest = [TankGaugeEntry fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (TankGaugeEntry *tankGaugeEntry in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                tankGaugeEntry.downloaded = YES;
                [context save:&error];
            } else {
                for (TankGaugeEntry *uploadedTankGaugeEntry in arrData) {
                    if ([tankGaugeEntry isEqual:uploadedTankGaugeEntry]) {
                        tankGaugeEntry.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
        }
    }
}

-(void) uploadedGasMeterData:(NSArray*)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [GasMeterData fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (GasMeterData *gasMeterData in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                gasMeterData.downloaded = YES;
                [context save:&error];
            } else {
                for (GasMeterData *uploadedGasMeterData in arrData) {
                    if ([uploadedGasMeterData isEqual:gasMeterData]) {
                        gasMeterData.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
            
        }
    }
}

-(void) uploadedWaterMeterData:(NSArray*)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [WaterMeterData fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (WaterMeterData *waterMeterData in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                waterMeterData.downloaded = YES;
                [context save:&error];
            } else {
                for (WaterMeterData *uploadedData in arrData) {
                    if ([waterMeterData isEqual:uploadedData]) {
                        waterMeterData.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
            
        }
    }
}

-(void) uploadedWellheadData:(NSArray*)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [WellheadData fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (WellheadData *wellheadData in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                wellheadData.downloaded = YES;
                [context save:&error];
            } else {
                for (WellheadData *uploadedData in arrData) {
                    if ([wellheadData isEqual:uploadedData]) {
                        wellheadData.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
        }
    }
}


-(void) uploadedInvoicesFromLocal:(NSArray*)arrData
{
    // remove deleted invoices from local
    for (Invoices *deletedInvoice in arrData) {
        if (deletedInvoice.deleted) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == YES AND invoiceID == %d AND invoiceDate == %@", deletedInvoice.invoiceID, deletedInvoice.invoiceDate];
            NSFetchRequest *fetchRequest = [Invoices fetchRequest];
            [fetchRequest setPredicate:predicate];
            NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
            deleteReq.resultType = NSBatchDeleteResultTypeCount;
            
            NSError *error = nil;
            NSBatchDeleteResult *deleteResult = [context executeRequest:deleteReq error:&error];
            
            if (error) {
                NSLog(@"Unable to delete the Invoices data");
            } else {
                NSLog(@"%@ deleted", deleteResult.result);
            }
        }
    }
    
    // change uploaded invoices' status
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [Invoices fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (Invoices *invoice in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                invoice.downloaded = YES;
                [context save:&error];
            } else {
                for (Invoices *uploadedInvoice in arrData) {
                    if ([invoice isEqual:uploadedInvoice]) {
                        invoice.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
            
        }
    }
    
}

-(void) uploadedInvoicesDetailFromLocal:(NSArray*)arrData
{
    for (InvoicesDetail *uploadedInvoicesDetail in arrData) {
        if (uploadedInvoicesDetail.deleted) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == YES AND invoiceDetailID == %d AND invoiceID == %d", uploadedInvoicesDetail.invoiceDetailID, uploadedInvoicesDetail.invoiceID];
            NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
            [fetchRequest setPredicate:predicate];
            NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
            deleteReq.resultType = NSBatchDeleteResultTypeCount;
            
            NSError *error = nil;
            NSBatchDeleteResult *deleteResult = [context executeRequest:deleteReq error:&error];
            
            if (error) {
                NSLog(@"Unable to delete the InvoicesDetail data");
            } else {
                NSLog(@"%@ deleted", deleteResult.result);
            }
        }
    }
    
    
    // change uploaded InvoiceDetails' status
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [InvoicesDetail fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (InvoicesDetail *invoiceDetail in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                invoiceDetail.downloaded = YES;
                [context save:&error];
            } else {
                for (InvoicesDetail *uploadedInvoicesDetail in arrData) {
                    if ([invoiceDetail isEqual:uploadedInvoicesDetail]) {
                        invoiceDetail.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
            
        }
    }
}

-(void) uploadedInvoicesPersonnelFromLocal:(NSArray*)arrData
{
    for (InvoicesPersonnel *uploadedData in arrData) {
        if (uploadedData.deleted) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == YES AND invoicePersonnelID == %d AND invoiceID == %d", uploadedData.invoicePersonnelID, uploadedData.invoiceID];
            NSFetchRequest *fetchRequest = [InvoicesPersonnel fetchRequest];
            [fetchRequest setPredicate:predicate];
            NSBatchDeleteRequest *deleteReq = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
            deleteReq.resultType = NSBatchDeleteResultTypeCount;
            
            NSError *error = nil;
            NSBatchDeleteResult *deleteResult = [context executeRequest:deleteReq error:&error];
            
            if (error) {
                NSLog(@"Unable to delete the InvoicesPersonnel data");
            } else {
                NSLog(@"%@ deleted", deleteResult.result);
            }
        }
    }
    
    
    // change uploaded InvoicePersonnels' status
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [InvoicesPersonnel fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (InvoicesPersonnel *invoicePersonnel in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                invoicePersonnel.downloaded = YES;
                [context save:&error];
            } else {
                for (InvoicesPersonnel *uploadedData in arrData) {
                    if ([invoicePersonnel isEqual:uploadedData]) {
                        invoicePersonnel.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
            
        }
    }
}


-(void) uploadedScheduleData:(NSArray*)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [Schedules fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (Schedules *schedules in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                schedules.downloaded = YES;
                [context save:&error];
            } else {
                for (Schedules *uploadedSchedule in arrData) {
                    if ([schedules isEqual:uploadedSchedule]) {
                        schedules.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
        }
    }
}

-(void) uploadedRigReports:(NSArray*)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [RigReports fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (RigReports *rigReports in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                rigReports.downloaded = YES;
                [context save:&error];
            } else {
                for (RigReports *uploadedRigReports in arrData) {
                    if ([rigReports isEqual:uploadedRigReports]) {
                        rigReports.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
        }
    }
}

-(void) uploadedRigReportRods:(NSArray*)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [RigReportsRods fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (RigReportsRods *rigReportsRods in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                rigReportsRods.downloaded = YES;
                [context save:&error];
            } else {
                for (RigReportsRods *uploadedData in arrData) {
                    if ([rigReportsRods isEqual:uploadedData]) {
                        rigReportsRods.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
            
        }
    }
}

-(void) uploadedRigReportPump:(NSArray*)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [RigReportsPump fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (RigReportsPump *rigReportsPump in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                rigReportsPump.downloaded = YES;
                [context save:&error];
            } else {
                for (RigReportsPump *uploadedData in arrData) {
                    if ([rigReportsPump isEqual:uploadedData]) {
                        rigReportsPump.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
        }
    }
}

-(void) uploadedRigReportTubing:(NSArray*)arrData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloaded == NO"];
    NSFetchRequest *fetchRequest = [RigReportsTubing fetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (RigReportsTubing *rigReportsTubing in arrResult) {
            if (arrData == nil || arrData.count == 0) {
                rigReportsTubing.downloaded = YES;
                [context save:&error];
            } else {
                for (RigReportsTubing *uploadedData in arrData) {
                    if ([rigReportsTubing isEqual:uploadedData]) {
                        rigReportsTubing.downloaded = YES;
                        [context save:&error];
                        break;
                    }
                }
            }
        }
    }
}

@end
