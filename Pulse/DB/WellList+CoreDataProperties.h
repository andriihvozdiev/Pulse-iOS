
#import "WellList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WellList (CoreDataProperties)

+ (NSFetchRequest<WellList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *grandparentPropNum;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *prodCat;
@property (nullable, nonatomic, copy) NSString *rrcLease;
@property (nonatomic) int32_t wellID;
@property (nullable, nonatomic, copy) NSString *wellNumber;

@end

NS_ASSUME_NONNULL_END
