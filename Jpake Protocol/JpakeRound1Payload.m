//
//  JpakeRound1Payload.m
//  coolhash
//
//  Created by Renu Srijith on 01/07/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import "JpakeRound1Payload.h"

@implementation JpakeRound1Payload



- (id)initWithParticipantId:(NSString *)ParticipantId
                        gX1:(BigInteger*)gx1
                        gX2:(BigInteger*)gx2
                      ZkpX1:(NSArray*)zkpX1
                      ZkpX2:(NSArray*)zkpX2
{
    if( self = [super init] )
    {
//check for object not null //
        self.participantId=ParticipantId;
        self.gx1=gx1;
        self.gx2=gx2;
        self.ZkpArrayX1=zkpX1;
        self.ZkpArrayX2=zkpX2;
        
    }
    
    return self;



}

-(NSString*)getParticipantID
{
    return  [self participantId];
}
-(BigInteger*)getGx1
{
    return [self gx1];
}
-(BigInteger*)getGx2
{
    return [self gx2];
    
}
-(NSArray*)getZkpArrayX1
{
    return [self ZkpArrayX1];
}

-(NSArray*)getZkpArrayX2
{
    return [self ZkpArrayX2];
}
@end
