//
//  JpakeRound3Payload.m
//  Jpake
//
//  Created by Renu Srijith on 08/07/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import "JpakeRound3Payload.h"

@implementation JpakeRound3Payload
- (id)initWithParticipantId:(NSString *)ParticipantId  macTag:(BigInteger*)macTag;

{
    if( self = [super init] )
    {
        //check for object not null //
        self.participantId=ParticipantId;
        self.macTag =macTag;
        }

    return self;

}

-(NSString*)getParticipantID
{
    return  [self participantId];
}
-(BigInteger*)getMactag
{
    return [self macTag];
}


@end
