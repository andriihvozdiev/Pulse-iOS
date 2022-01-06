//
//  TankGaugeEntry+CoreDataProperties.m
//  Pulse
//
//  Created by Luca on 5/30/18.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "TankGaugeEntry+CoreDataProperties.h"

@implementation TankGaugeEntry (CoreDataProperties)

+ (NSFetchRequest<TankGaugeEntry *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TankGaugeEntry"];
}

@dynamic bswVol;
@dynamic bswVol24;
@dynamic calc24Bbls;
@dynamic calcBbls;
@dynamic comments;
@dynamic deviceID;
@dynamic downloaded;
@dynamic entryTime;
@dynamic gaugeTime;
@dynamic hr24GgDt;
@dynamic lastGgDt;
@dynamic lease;
@dynamic negProdQC;
@dynamic oilFeet1;
@dynamic oilFeet2;
@dynamic oilFeet3;
@dynamic oilFeet4;
@dynamic oilFeet5;
@dynamic oilFeet6;
@dynamic oilFeet7;
@dynamic oilFeet8;
@dynamic oilFeet9;
@dynamic oilFeet10;
@dynamic onHandOil;
@dynamic runTicketVol;
@dynamic runTicketVol24;
@dynamic tankGaugeID;
@dynamic tankID1;
@dynamic tankID2;
@dynamic tankID3;
@dynamic tankID4;
@dynamic tankID5;
@dynamic tankID6;
@dynamic tankID7;
@dynamic tankID8;
@dynamic tankID9;
@dynamic tankID10;
@dynamic userid;

@end
