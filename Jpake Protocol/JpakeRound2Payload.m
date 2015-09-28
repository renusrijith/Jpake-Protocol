//
//  JpakeRound2Payload.m
//  coolhash
//
//  Created by Renu Srijith on 01/07/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import "JpakeRound2Payload.h"

@implementation JpakeRound2Payload

- (id)initWithParticipantId:(NSString *)ParticipantId
                        a:(BigInteger*)a
                        Zkpx2s:(NSArray*)zkpx2s
    {
    if( self = [super init] )
    {
        //check for object not null //
        self.participantId=ParticipantId;
        self.a=a;
        self.ZkpArrayX2s =zkpx2s;
        
    }
    
    return self;
   
}

-(NSString*)getParticipantID
{
    return  [self participantId];
}
-(BigInteger*)geta
{
    return [self a];
}

-(NSArray*)getZkpX2s
{
    return [self ZkpArrayX2s];
}



@end
