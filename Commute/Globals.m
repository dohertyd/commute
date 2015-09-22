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
static NSString* const DestStationKey = @"DestStationKey";

@interface Globals()
// Private interface here


@end




@implementation Globals

+(Globals *)sharedInstance
{
    static Globals * sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init ];
        // Register default values for our settings
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{StartStationKey: @"", DestStationKey: @""}];
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
    NSString * ss = [[NSUserDefaults standardUserDefaults] objectForKey:DestStationKey];
    destStation = ss;
    return destStation;
}
+(NSString *)getDestStation
{
    return [[Globals sharedInstance] getDestStation];
}


@end
