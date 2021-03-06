//
//  ViewController.m
//  Commute
//
//  Created by Derek Doherty on 25/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import "ViewController.h"
#import "SaxParser.h"
#import "ObjStationData.h"


static NSString * const destinationDalkeyString = @"... to Dalkey via Greystones";
static NSString * const destinationRathdrumString = @"... to Rathdrum via Greystones";

static NSString * const dalkeyStationString = @"Dalkey";
static NSString * const rathdrumStationString = @"Rathdrum";

static NSString * const rathdrumStationCode = @"rdrum";
static NSString * const dalkeyStationCode = @"dlkey";
static NSString * const greystonesStationCode = @"gstns";


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (strong , nonatomic) NSMutableDictionary * stationsOfInterest;
@property (strong , nonatomic) NSMutableDictionary * stationsOfInterestNorthbound;
@property (strong , nonatomic) NSMutableDictionary * stationsOfInterestSouthbound;


@property (strong, nonatomic) IrishRailHTTPClient *client;

@property (weak, nonatomic) IBOutlet UILabel *startingStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *destStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSString * startingStation;
@property (strong, nonatomic) NSString * destinationStation;

@end




@implementation ViewController

/*
 * Toggles Starting and Destination Station labels
*/
- (IBAction)toggleDestButton:(UIButton *)sender
{
    if ([self.startingStation isEqualToString:rathdrumStationString])
    {
        self.startingStation = dalkeyStationString;
        self.startingStationLabel.text = self.startingStation;
        
        self.destinationStation = destinationRathdrumString;
        self.destStationLabel.text = self.destinationStation;
    }
    else
    {
        self.startingStation = rathdrumStationString;
        self.startingStationLabel.text = self.startingStation;
        
        self.destinationStation = destinationDalkeyString;
        self.destStationLabel.text = self.destinationStation;
    }
    [self.myTableView reloadData];
    [self refreshArrays];
    
}

-(NSString *)getUpdateTimeString
{
    NSDate * nd = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *startTimeString = [formatter stringFromDate:nd];
    NSString * updateString = [NSString stringWithFormat:@"Updated %@", startTimeString];
    
    return updateString;
}


- (IBAction)refreshButtonPressed:(UIButton *)sender
{
    [self refreshArrays];
}

-(void)refreshArrays
{
    // Refresh the Arrays
    
    if ([self.startingStation isEqualToString:rathdrumStationString] ) // Northbound
    {
        //[self.client updateTrainDataAtStation:dalkeyStationCode forNumberOfMinutes:90];
        [self.client updateTrainDataAtStation:greystonesStationCode forNumberOfMinutes:90];
        [self.client updateTrainDataAtStation:rathdrumStationCode forNumberOfMinutes:90];
    }
    else // Southbound
    {
        [self.client updateTrainDataAtStation:dalkeyStationCode forNumberOfMinutes:90];
        [self.client updateTrainDataAtStation:greystonesStationCode forNumberOfMinutes:90];
        //[self.client updateTrainDataAtStation:rathdrumStationCode forNumberOfMinutes:90];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshArrays];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.client.reachabilityManager stopMonitoring];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshArrays)
                                   name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.myTableView.allowsSelection = NO; // Disable selection Highlighting
    
//    // Keep an eye on network connectivity
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
//    {
//        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
//    }];
    
    // Initialize UI and Properties
    self.startingStation = dalkeyStationString;
    self.startingStationLabel.text = self.startingStation;
    self.destinationStation = destinationRathdrumString;
    self.destStationLabel.text = self.destinationStation;
    
    self.updateTimeLabel.text = @"Not Updated";
    

    self.stationsOfInterestNorthbound = [[NSMutableDictionary alloc] init ];
    self.stationsOfInterestSouthbound = [[NSMutableDictionary alloc] init ];
    
    // Make this ViewCopntroller a Delegate of the Networking HTTP CLient
    self.client = [IrishRailHTTPClient sharedIrishRailHTTPClient];
    self.client.delegate = self;
    
    
    NSOperationQueue *operationQueue = self.client.operationQueue;
    [self.client.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [self.client.reachabilityManager  startMonitoring];
    
   // [self refreshArrays];
}




#pragma - mark IrishRailHttpClient delgate functions

-(void)IrishRailHTTPClient:(IrishRailHTTPClient *)client didUpdateWithTrains:(id)trainData  withStationCode:stationCode
{
    NSXMLParser * XMLParser = (NSXMLParser *)trainData;
    __block NSArray * ar;
    
    self.updateTimeLabel.text = [self getUpdateTimeString];
    
    
    if ([self.startingStation isEqualToString:rathdrumStationString] )
    {
        SaxParser * sp = [ [SaxParser alloc ] init ];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
        ^{
            ar = [sp parseTrainData:XMLParser direction:@"Northbound"];
            self.stationsOfInterestNorthbound[stationCode] = ar;
            NSLog(@"%@", self.stationsOfInterestNorthbound);
                           
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [self.myTableView reloadData];
            });
        });
    }
    else if ([self.startingStation isEqualToString:dalkeyStationString])
    {
        SaxParser * sp = [ [SaxParser alloc ] init ];
        
//        CFTimeInterval start2 = CACurrentMediaTime();
//        NSArray * ar = [sp parseTrainData:XMLParser direction:@"Southbound"];
//        
//        CFTimeInterval end2 = CACurrentMediaTime();
//        NSLog(@"Time To Parse SB Data: %f", end2 - start2);
//        
//        // Update Dictionary
//        self.stationsOfInterestSouthbound[stationCode] = ar;
//        //NSLog(@"%@", self.stationsOfInterestSouthbound);
//        [self.myTableView reloadData];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
        ^{
            ar = [sp parseTrainData:XMLParser direction:@"Southbound"];
            self.stationsOfInterestSouthbound[stationCode] = ar;
            NSLog(@"%@", self.stationsOfInterestSouthbound);
                           
            dispatch_async(dispatch_get_main_queue(),
            ^{
                        [self.myTableView reloadData];
            });
        });
    }
}

-(void)IrishRailHTTPClient:(IrishRailHTTPClient *)client didFailWithError:(NSError *)error
{
    [self.myTableView reloadData];
    NSLog(@"Problem Loading Train Information");
}


#pragma mark - Table view

// Make custom section header text
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(10, 0, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:12];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
    [headerView addSubview:myLabel];
    
    return headerView;
}

// 2 Sections , one for each leg of the journey
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * leg1String;
    NSString * leg2String;
    
    if ( [self.startingStation isEqualToString:rathdrumStationString] ) // Northbound
    {
        leg1String = @"Rathdrum to Greystones Departures ...";
        leg2String = @"Greystones to Dalkey Departures ...";
    }
    else
    {
        leg1String = @"Dalkey to Greystones Departures ...";
        leg2String = @"Greystones to Rathdrum Departures ...";
    }
    
    switch (section)
    {
        case 0:
            return leg1String; // 1st Leg
        case 1:
            return leg2String; // 2nd Leg of trip
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr1, *arr2;
    
    if ( [self.startingStation isEqualToString:rathdrumStationString] ) // Northbound
    {
        arr1 = self.stationsOfInterestNorthbound[rathdrumStationCode];
        arr2 = self.stationsOfInterestNorthbound[greystonesStationCode];
    }
    else // Southbound
    {
        arr1 = self.stationsOfInterestSouthbound[dalkeyStationCode];
        arr2 = self.stationsOfInterestSouthbound[greystonesStationCode];
    }
    
    switch (section)
    {
        case 0: // 1st Leg of Journey
        {
            if (arr1.count == 0)
                return 1;
            else
                return arr1.count;
        }
        case 1: // 2nd leg of Journey
        {
            if (arr2.count == 0)
                return 1;
            else
                return arr2.count;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nextTrainCell" forIndexPath:indexPath];
    
    NSArray * arr1, *arr2;
    
    if ( [self.startingStation isEqualToString:rathdrumStationString] )
    {
        arr1 = self.stationsOfInterestNorthbound[rathdrumStationCode];
        arr2 = self.stationsOfInterestNorthbound[greystonesStationCode];
    }
    else
    {
        arr1 = self.stationsOfInterestSouthbound[dalkeyStationCode];
        arr2 = self.stationsOfInterestSouthbound[greystonesStationCode];
    }
    
    ObjStationData * obsd;
    switch (indexPath.section) {
        case 0:
        {
            if (arr1.count == 0) // Special Case to Display No Train Info
            {
                cell.detailTextLabel.text = @"No Trains Listed";
                cell.textLabel.text = @"";
                return cell;
            }
            else
               obsd = arr1[indexPath.row]; // 1st leg times
            break;
        }
        case 1:
        {
            if (arr2.count == 0) // Special Case to Display No Train Info
            {
                cell.detailTextLabel.text = @"No Trains Listed";
                cell.textLabel.text = @"";
                return cell;
            }
            else
               obsd = arr2[indexPath.row]; // 2nd leg times
            break;
        }
        default:
            break;
    }
    
    NSString * stu = [NSString stringWithFormat:@"%@ Mins", [obsd.Duein stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ];
    
    NSString * delayText;
    if ([obsd.Late isEqualToString:@"0"]) // No Delay!!
    {
        delayText = [NSString stringWithFormat:@"On Time"];
    }
    else
        delayText = [NSString stringWithFormat:@"Delayed %@ Mins", obsd.Late];
        
    
    
    cell.textLabel.text = stu;
    cell.detailTextLabel.text = delayText;
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
