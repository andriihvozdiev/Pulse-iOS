
#import "TubingLength+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TubingLength (CoreDataProperties)

+ (NSFetchRequest<TubingLength *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *nominalSize;
@property (nullable, nonatomic, copy) NSString *tbgLength;
@property (nonatomic) int32_t tbgLengthID;

@end

NS_ASSUME_NONNULL_END
