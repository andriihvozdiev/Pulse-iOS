
#import "GasMeterData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GasMeterData (CoreDataProperties)

+ (NSFetchRequest<GasMeterData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *checkTime;
@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSString *currentFlow;
@property (nonatomic) int32_t dataID;
@property (nullable, nonatomic, copy) NSString *deviceID;
@property (nullable, nonatomic, copy) NSString *diffPressure;
@property (nonatomic) BOOL downloaded;
@property (nullable, nonatomic, copy) NSDate *entryTime;
@property (nonatomic) int32_t idGasMeter;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nullable, nonatomic, copy) NSString *linePressure;
@property (nullable, nonatomic, copy) NSString *meterCumVol;
@property (nullable, nonatomic, copy) NSString *meterProblem;
@property (nonatomic) int32_t userid;
@property (nullable, nonatomic, copy) NSString *wellNumber;
@property (nullable, nonatomic, copy) NSString *yesterdayFlow;

@end

NS_ASSUME_NONNULL_END
