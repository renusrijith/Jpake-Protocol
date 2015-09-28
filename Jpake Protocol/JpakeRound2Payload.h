//
//  JpakeRound2Payload.h
//  coolhash
//
//  Created by Renu Srijith on 01/07/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigInteger.h"
@interface JpakeRound2Payload : NSObject
{
}

@property(nonatomic,strong)NSString* participantId;

@property(nonatomic,strong)BigInteger* a;
@property(nonatomic,strong) NSArray* ZkpArrayX2s;

- (id)initWithParticipantId:(NSString *)ParticipantId  a:(BigInteger*)a
                     Zkpx2s:(NSArray*)zkpx2s;

-(NSString*)getParticipantID;

-(BigInteger*)geta;

-(NSArray*)getZkpX2s;

@end
