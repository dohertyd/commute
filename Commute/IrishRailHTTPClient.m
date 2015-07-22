//
//  IrishRailHTTPClient.m
//  Commute
//
//  Created by Derek Doherty on 26/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import "IrishRailHTTPClient.h"

static NSString * const IrishRailURLString = @"http://api.irishrail.ie/realtime/realtime.asmx/";





@implementation IrishRailHTTPClient

// Singelton Pattern
+(IrishRailHTTPClient *)sharedIrishRailHTTPClient
{
    static IrishRailHTTPClient *_sharedIrishRailHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedIrishRailHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:IrishRailURLString]];
    });
    
    return _sharedIrishRailHTTPClient;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    return self;
}

-(void)updateTrainDataAtStation:(NSString *)station forNumberOfMinutes:(NSUInteger)number
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"StationCode"] = station;
    parameters[@"NumMins"] = [@(number) stringValue];
    
    //parameters[@"NumMins"] = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    //parameters[@"format"] = @"json";

    
    
    [self GET:@"getStationDataByCodeXML_WithNumMins" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([self.delegate respondsToSelector:@selector(IrishRailHTTPClient:didUpdateWithTrains: withStationCode:)])
         {
             [self.delegate IrishRailHTTPClient:self didUpdateWithTrains:responseObject  withStationCode:station];
         }
     }
      failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         if ([self.delegate respondsToSelector:@selector(IrishRailHTTPClient:didFailWithError:)])
         {
             [self.delegate IrishRailHTTPClient:self didFailWithError:error];
         }
     }];
    
}



@end
