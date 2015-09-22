//
//  Globals.m
//  AceChat
//
//  Created by Derek Doherty on 18/09/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "Globals.h"

// We store our settings in the NSUserDefaults dictionary using these keys
static NSString* const StartStationKey = @"StartStationKey";
static NSString* const InterStationKey = @"InterStationKey";
static NSString* const DestStationKey = @"DestStationKey";

@interface Globals()
// Private interface here


@end




@implementation Globals

+(instancetype)sharedInstance
{
    static Globals * sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init ];
        // Register default values for our settings
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{StartStationKey: @"", DestStationKey: @"", InterStationKey: @""}];
    });
    
    return sharedInstance;
}


-(void)setStartStation:(NSString *)_startStation
{
    startStation = _startStation;
    [[NSUserDefaults standardUserDefaults]  setObject:_startStation forKey:StartStationKey];
}
+(void)setStartStation:(NSString *)startStation
{
    [[Globals sharedInstance] setStartStation:startStation];
}

-(NSString *)getStartStation
{
    NSString * ss = [[NSUserDefaults standardUserDefaults] objectForKey:StartStationKey];
    startStation = ss;
    return startStation;
}
+(NSString *)getStartStation
{
    return [[Globals sharedInstance] getStartStation];
}


-(void)setInterStation:(NSString *)_interStation
{
    interStation = _interStation;
    [[NSUserDefaults standardUserDefaults]  setObject:_interStation forKey:InterStationKey];
}
+(void)setInterStation:(NSString *)interStation
{
    [[Globals sharedInstance] setInterStation:interStation];
}

-(NSString *)getInterStation
{
    NSString * is = [[NSUserDefaults standardUserDefaults] objectForKey:InterStationKey];
    interStation = is;
    return interStation;
}
+(NSString *)getInterStation
{
    return [[Globals sharedInstance] getInterStation];
}




-(void)setDestStation:(NSString *)_destStation
{
    destStation = _destStation;
    [[NSUserDefaults standardUserDefaults]  setObject:_destStation forKey:DestStationKey];
}
+(void)setDestStation:(NSString *)destStation
{
    [[Globals sharedInstance] setDestStation:destStation];
}

-(NSString *)getDestStation
{
    NSString * ds = [[NSUserDefaults standardUserDefaults] objectForKey:DestStationKey];
    destStation = ds;
    return destStation;
}
+(NSString *)getDestStation
{
    return [[Globals sharedInstance] getDestStation];
}


@end
