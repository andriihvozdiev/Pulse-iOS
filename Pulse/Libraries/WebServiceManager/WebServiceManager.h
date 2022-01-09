
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"


typedef void (^CompletionBlock)(id obj);
typedef void (^ErrorBlock)(NSURLSessionDataTask *task, NSError *error);

@interface WebServiceManager : AFHTTPSessionManager

+(instancetype)sharedInstance;

// detect network status
+ (BOOL)connectedToNetwork;

-(void)sendPostRequest:(NSString*)url param:(NSDictionary*)params completionHandler:(CompletionBlock)completgygyionBlock errorHandler:(ErrorBlock)errorBlock;

-(void)loginWithData:(NSDictionary*)signInData completionHandler:(CompletionBlock)completgygyionBlock errorHandler:(ErrorBlock)errorBlock;
-(void)loginWithUserID:(NSDictionary*)signInData completionHandler:(CompletionBlock)completgygyionBlock errorHandler:(ErrorBlock)errorBlock;

-(void) setDaysToSync;

@end
