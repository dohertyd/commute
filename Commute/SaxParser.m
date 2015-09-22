//
//  SaxParser.m
//  Commute
//
//  Created by Derek Doherty on 26/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import "SaxParser.h"
#import "ObjStationData.h"

@interface SaxParser()
@property (strong, nonatomic) NSMutableArray * ObjStationDataArray;
@property (strong, nonatomic) ObjStationData * currentObjStationData;

@property (strong, nonatomic) NSString * direction;

@end

@implementation SaxParser



-(NSArray *)parseTrainData:(NSXMLParser *)stationData direction:(NSString *)direction
{
    self.ObjStationDataArray = [[NSMutableArray alloc] init];
    self.direction = direction;
    
    stationData.delegate = self;
    [stationData setShouldProcessNamespaces:YES];
    
    // Start the parsing and fill out the array
    [stationData parse];
    
    return self.ObjStationDataArray;
}



#pragma - mark NSXMLParser delgate functions


- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"XML Parse Finished");
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([qName isEqualToString:@"Servertime"]  )
    {
        self.currentObjStationData.Servertime =  [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Traincode"])
    {
        self.currentObjStationData.Traincode = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Stationfullname"])
    {
        self.currentObjStationData.Stationfullname = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Stationcode"] )
    {
        self.currentObjStationData.Stationcode = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([qName isEqualToString:@"Querytime"])
    {
        self.currentObjStationData.Querytime = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Traindate"] )
    {
        self.currentObjStationData.Traindate = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([qName isEqualToString:@"Origin"])
    {
        self.currentObjStationData.Origin = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Destination"] )
    {
        self.currentObjStationData.Destination = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([qName isEqualToString:@"Origintime"])
    {
        self.currentObjStationData.Origintime = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Destinationtime"] )
    {
        self.currentObjStationData.Destinationtime = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([qName isEqualToString:@"Status"])
    {
        self.currentObjStationData.Status = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Lastlocation"] )
    {
        self.currentObjStationData.Lastlocation = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([qName isEqualToString:@"Duein"])
    {
        self.currentObjStationData.Duein = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Late"] )
    {
        self.currentObjStationData.Late = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([qName isEqualToString:@"Exparrival"])
    {
        self.currentObjStationData.Exparrival = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Expdepart"] )
    {
        self.currentObjStationData.Expdepart = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    
    else if ([qName isEqualToString:@"Scharrival"])
    {
        self.currentObjStationData.Scharrival = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Schdepart"] )
    {
        self.currentObjStationData.Schdepart = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([qName isEqualToString:@"Direction"])
    {
        self.currentObjStationData.Direction = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Traintype"] )
    {
        self.currentObjStationData.Traintype = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([qName isEqualToString:@"Locationtype"] )
    {
        self.currentObjStationData.Locationtype = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    // This is the closing element can add above object to array now
    else if ([qName isEqualToString:@"objStationData"] )
    {
        // Need to filter for selected direction
        if ([self.currentObjStationData.Direction isEqualToString:self.direction])
        {
            // If this station Info for Dalkey Southbound then only want Trains
            // Going to GreyStones and not just to Bray!
            if ([ self.direction isEqualToString:@"Southbound"] && [self.currentObjStationData.Stationcode isEqualToString:@"DLKEY"])
            {
                if (![self.currentObjStationData.Destination isEqualToString:@"Greystones"])
                {
                    return;
                }
            }
            // If this station Info for Greystones Southbound then only want Trains
            // Going to Rathdrum and not just to Bray!
            if ([ self.direction isEqualToString:@"Southbound"] && [self.currentObjStationData.Stationcode isEqualToString:@"GSTNS"])
            {
                if (![self.currentObjStationData.Destination isEqualToString:@"Rosslare Europort"])
                {
                    return;
                }
            }
            [ self.ObjStationDataArray addObject:self.currentObjStationData];
        }
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
   // if (!self.elementName)
   //     return;
    
    [self.xmlText appendString:string];
}



-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.xmlText = [[NSMutableString alloc] init ];
    if ( [elementName isEqualToString:@"objStationData"])
    {
        self.currentObjStationData = [[ObjStationData alloc] init ];
    }
}


-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

@end
