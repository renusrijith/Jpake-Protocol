//
//  JpakeRound3Payload.h
//  Jpake
//
//  Created by Renu Srijith on 08/07/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigInteger.h"
@interface JpakeRound3Payload : NSObject
{


}

@property(nonatomic,strong)NSString* participantId;

@property(nonatomic,strong)BigInteger* macTag;

- (id)initWithParticipantId:(NSString *)ParticipantId  macTag:(BigInteger*)macTag;

-(NSString*)getParticipantID;

-(BigInteger*)getMactag;
@end
