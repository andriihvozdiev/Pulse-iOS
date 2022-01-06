//
//  RunTickets+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "RunTickets+CoreDataProperties.h"

@implementation RunTickets (CoreDataProperties)

+ (NSFetchRequest<RunTickets *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RunTickets"];
}

@dynamic bottomsFeet1;
@dynamic bottomsFeet2;
@dynamic bottomsInch1;
@dynamic bottomsInch2;
@dynamic bsw;
@dynamic ticketOption;
@dynamic calcGrossVol;
@dynamic calcNetVol;
@dynamic carrier;
@dynamic comments;
@dynamic deviceID;
@dynamic deleted;
@dynamic downloaded;
@dynamic driver;
@dynamic entryTime;
@dynamic glMonth;
@dynamic glYear;
@dynamic grossVol;
@dynamic internalTicketID;
@dynamic lease;
@dynamic netVol;
@dynamic obsGrav;
@dynamic obsTemp;
@dynamic oilFeet1;
@dynamic oilFeet2;
@dynamic oilFraction1;
@dynamic oilFraction2;
@dynamic oilInch1;
@dynamic oilInch2;
@dynamic tankNumber;
@dynamic temp1;
@dynamic temp2;
@dynamic ticketImage;
@dynamic ticketNumber;
@dynamic ticketTime;
@dynamic timeOff;
@dynamic timeOn;
@dynamic userid;

@end
