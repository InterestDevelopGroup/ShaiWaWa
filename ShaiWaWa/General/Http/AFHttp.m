//
//  AFHttp.m
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "AFHttp.h"
@implementation AFHttp

#pragma mark - Life Cycle
- (id)init
{
    if((self = [super init]))
    {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    }
    return self;
}

- (void)dealloc
{
    _manager = nil;
}


#pragma mark  Class Methods
+ (AFHttp *)shareInstanced
{
    static AFHttp * this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc] init];
    });
    
    return this;
}


+ (NSString *)urlEncode:(NSString *)url
{
    NSAssert(url != nil, @"The url is nil.");
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(id))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager GET:[[self class] urlEncode:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,%@",error,operation.responseString);
        if(failure)
            failure(error,operation.responseString);
    }];
}


+ (void)post:(NSString *)url withParam:(NSDictionary *)params completionBlock:(void (^)(id))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:[[self class] urlEncode:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if(success)
            success(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,%@",error,operation.responseString);
        if(failure)
            failure(error,operation.responseString);
    }];
}


#pragma mark Instance Methods
- (void)get:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [_manager GET:[[self class] urlEncode:url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@,%@",responseObject,operation.request.URL);
        if(success)
            success(responseObject);
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,%@",error,operation.responseString);
        if(failure)
            failure(error,operation.responseString);


    }];
}

- (void)post:(NSString *)url withParams:(NSDictionary *)params completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [_manager POST:[[self class] urlEncode:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,%@",error,operation.responseString);
        if(failure)
            failure(error,operation.responseString);

    }];
}

- (void)postJSON:(NSString *)url withParams:(NSDictionary *)params withJSON:(NSData *)json completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
    /*
    [_manager POST:[[self class] urlEncode:url] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (json) {
            NSString * tmp = [NSString stringWithUTF8String:[json bytes]];
            NSLog(@"JSON Data : %@",tmp);
            //[formData appendPartWithHeaders:@{@"Content-Type":@"application/json"} body:json];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@，%@",responseObject,operation.request.allHTTPHeaderFields);
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,%@",error,operation.responseString);
        if(failure)
            failure(error,operation.responseString);
    }];
    */
    
    /*
    NSString * tmp = [[NSString alloc] initWithBytes:[json bytes] length:[json length] encoding:NSUTF8StringEncoding];
    NSLog(@"JSON Data : %@",tmp);
    tmp = nil;
    */
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[self class] urlEncode:url]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d",[json length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:json];

    NSOperation * operation = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if(success)
            success(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,%@",error,operation.responseString);
        if(failure)
            failure(error,operation.responseString);
    }];
    [_manager.operationQueue addOperation:operation];
}

- (void)postJSON:(NSString *)url withParams:(NSDictionary *)params completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    NSData * json = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[self class] urlEncode:url]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d",[json length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:json];
    
    NSOperation * operation = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if(success)
            success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,%@",error,operation.responseString);
        if(failure)
            failure(error,operation.responseString);
    }];
    [_manager.operationQueue addOperation:operation];
}

- (void)cancelAllOperations
{
    [_manager.operationQueue cancelAllOperations];
}

- (BOOL)isReachableViaWWAN
{
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi
{
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}

- (BOOL)isReachable
{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

@end
