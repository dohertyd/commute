//
//  SaxParser.h
//  Commute
//
//  Created by Derek Doherty on 26/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaxParser : NSObject <NSXMLParserDelegate>


@property (strong,nonatomic) NSMutableString * xmlText;

-(NSArray *)parseTrainData:(NSXMLParser *)stationData direction:(NSString *)direction;

@end
