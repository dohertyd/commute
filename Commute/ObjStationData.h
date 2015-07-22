//
//  objStationData
//  Commute
//
//  Created by Derek Doherty on 26/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ObjStationData : NSObject


@property (strong, nonatomic) NSString * Servertime;
@property (strong, nonatomic) NSString * Traincode;
@property (strong, nonatomic) NSString * Stationfullname;
@property (strong, nonatomic) NSString * Stationcode;
@property (strong, nonatomic) NSString * Querytime;
@property (strong, nonatomic) NSString * Traindate;
@property (strong, nonatomic) NSString * Origin;
@property (strong, nonatomic) NSString * Destination;
@property (strong, nonatomic) NSString * Origintime;
@property (strong, nonatomic) NSString * Destinationtime;
@property (strong, nonatomic) NSString * Status;
@property (strong, nonatomic) NSString * Lastlocation;
@property (strong, nonatomic) NSString * Duein;
@property (strong, nonatomic) NSString * Late;
@property (strong, nonatomic) NSString * Exparrival;
@property (strong, nonatomic) NSString * Expdepart;
@property (strong, nonatomic) NSString * Scharrival;
@property (strong, nonatomic) NSString * Schdepart;
@property (strong, nonatomic) NSString * Direction;
@property (strong, nonatomic) NSString * Traintype;
@property (strong, nonatomic) NSString * Locationtype;

@end
