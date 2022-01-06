#import "TubingLength+CoreDataProperties.h"

@implementation TubingLength (CoreDataProperties)

+ (NSFetchRequest<TubingLength *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TubingLength"];
}

@dynamic nominalSize;
@dynamic tbgLength;
@dynamic tbgLengthID;

@end
