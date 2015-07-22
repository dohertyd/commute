//
//  IrishRailHTTPClient.h
//  Commute
//
//  Created by Derek Doherty on 26/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import "AFHTTPSessionManager.h"

// Forward Reference The Protocol
@protocol IrisRailHTTPClientDelegate;


@interface IrishRailHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<IrisRailHTTPClientDelegate>delegate;

// Singleton Pattern here !!
+(IrishRailHTTPClient *)sharedIrishRailHTTPClient;

-(instancetype)initWithBaseURL:(NSURL *)url;

-(void)updateTrainDataAtStation:(NSString *)station forNumberOfMinutes:(NSUInteger)number;


@end


@protocol IrisRailHTTPClientDelegate <NSObject>
@optional
-(void)IrishRailHTTPClient:(IrishRailHTTPClient *)client didUpdateWithTrains:(id)trainData withStationCode:(NSString *)stationCode;
  -(void)IrishRailHTTPClient:(IrishRailHTTPClient *)client didFailWithError:(NSError *)error;
@end
