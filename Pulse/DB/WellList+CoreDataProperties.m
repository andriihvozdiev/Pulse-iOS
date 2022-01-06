
#import "WellList+CoreDataProperties.h"

@implementation WellList (CoreDataProperties)

+ (NSFetchRequest<WellList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WellList"];
}

@dynamic grandparentPropNum;
@dynamic lease;
@dynamic prodCat;
@dynamic rrcLease;
@dynamic wellID;
@dynamic wellNumber;

@end
