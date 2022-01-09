
#import "WebServiceManager.h"
#include <netinet/in.h>

@implementation WebServiceManager

+(instancetype)sharedInstance
{
    static WebServiceManager *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        NSString *strForURL = [NSString stringWithFormat:@"%@/api/", BASE_URL];
        singleton = [[WebServiceManager alloc] initWithBaseURL:[NSURL URLWithString:strForURL]];
        singleton.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [singleton.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"application/x-www-form-urlencoded", @"text/json", @"text/javascript",@"text/html", nil]];
        singleton.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [singleton.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [singleton.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:S_AccessToken];
        [singleton.requestSerializer setValue:accessToken forHTTPHeaderField:@"accessToken"];
        NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
        [singleton.requestSerializer setValue:daysToSync forHTTPHeaderField:S_DaysToSync];
        
//        singleton.securityPolicy.allowInvalidCertificates = YES;
//        singleton.securityPolicy.validatesDomainName = NO;
    });
    return singleton;
}

-(id)initWithBaseURL:(NSURL *)url
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.oil.pulse"];
    
    self = [super initWithBaseURL:url sessionConfiguration:sessionConfig];
    
    if (self) {
        
    }
    return self;
}



#pragma mark Internet Connection
+ (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    BOOL isconnected = (isReachable && !needsConnection) ? YES : NO;
    
    if (!isconnected) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please check your internet connectivity." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
    
    return isconnected;
}

-(void)sendPostRequest:(NSString *)url param:(NSDictionary *)params completionHandler:(CompletionBlock)completionBlock errorHandler:(ErrorBlock)errorBlock
{
    [self POST:url parameters:params headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completionBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorBlock(task, error);
        }];
}

#pragma mark -

-(void)loginWithData:(NSDictionary *)signInData completionHandler:(CompletionBlock)completionBlock errorHandler:(ErrorBlock)errorBlock
{
    [self POST:Login parameters:signInData headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", signInData);
        NSLog(@"%@", responseObject);
        NSHTTPURLResponse *response = ((NSHTTPURLResponse *)[task response]);
        NSDictionary *headers = [response allHeaderFields];
        
        NSString *accessToken = [headers valueForKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:S_AccessToken];
        [self.requestSerializer setValue:accessToken forHTTPHeaderField:@"accessToken"];
        
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error : %@", error);
        errorBlock(task, error);
    }];
}

-(void) loginWithUserID:(NSDictionary *)signInData completionHandler:(CompletionBlock)completionBlock errorHandler:(ErrorBlock)errorBlock
{
    NSDictionary *headers = @{@"Content-Type": @"application/json"};
    [self POST:LoginWithUserID parameters:signInData headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSHTTPURLResponse *response = ((NSHTTPURLResponse *)[task response]);
        NSDictionary *headers = [response allHeaderFields];
        
        NSString *accessToken = [headers valueForKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:S_AccessToken];
        [self.requestSerializer setValue:accessToken forHTTPHeaderField:@"accessToken"];
        
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error : %@", error);
        errorBlock(task, error);
    }];
    
}


-(void) setDaysToSync {
    NSString *daysToSync = [[NSUserDefaults standardUserDefaults] valueForKey:S_DaysToSync];
    [self.requestSerializer setValue:daysToSync forHTTPHeaderField:S_DaysToSync];
}
@end
