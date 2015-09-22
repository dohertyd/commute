//
//  Globals.h
//  AceChat
//
//  Created by Derek Doherty on 18/09/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#ifndef Globals_h
#define Globals_h

#import <Foundation/Foundation.h>

@interface Globals : NSObject

{
    NSString * startStation;
    NSString * destStation;
}

+(NSString *)getStartStation;
+(void)setStartStation:(NSString *)startStation;

+(NSString *)getDestStation;
+(void)setDestStation:(NSString *)destStation;


@end


#endif /* Globals_h */
