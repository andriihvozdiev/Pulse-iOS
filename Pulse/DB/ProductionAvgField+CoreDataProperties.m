#import "ProductionAvgField+CoreDataProperties.h"

@implementation ProductionAvgField (CoreDataProperties)

+ (NSFetchRequest<ProductionAvgField *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ProductionAvgField"];
}

@dynamic allocatedVolume;
@dynamic gas7;
@dynamic gas30;
@dynamic gas365;
@dynamic gasP30;
@dynamic lease;
@dynamic leaseName;
@dynamic oil7;
@dynamic oil30;
@dynamic oil365;
@dynamic oilP30;
@dynamic prodID;
@dynamic productionDate;
@dynamic water7;
@dynamic water30;
@dynamic water365;
@dynamic waterP30;
@dynamic leaseField;

@end
