//
//  jpakeparticipant.h
//  coolhash
//
//  Created by Renu Srijith on 24/06/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BigInteger.h"
#import "jpakeParms.h"
#import "JpakeRound1Payload.h"
#import "JpakeRound2Payload.h"
#import "JpakeRound3Payload.h"
#import "jpakeUtils.h"



@interface jpakeparticipant : NSObject
{

    int state;
    
    
}

@property(nonatomic,strong)NSString* participantId;
@property(nonatomic,strong)NSString* password;

@property(nonatomic,strong)NSString* partnerParticipantId;

@property(nonatomic,strong)BigInteger* p;
@property(nonatomic,strong)BigInteger* q;
@property(nonatomic,strong)BigInteger* g;

@property(nonatomic,strong)BigInteger* x1;
@property(nonatomic,strong)BigInteger* x2;

@property(nonatomic,strong)BigInteger* gx1;
@property(nonatomic,strong)BigInteger* gx2;
@property(nonatomic,strong)BigInteger* gx3;
@property(nonatomic,strong)BigInteger* gx4;


@property(nonatomic,strong)BigInteger* b;

//
//
//
- (id)initWithParticipantId:(NSString *)participantId
                  password :(NSString *)password;
-(void)setState:(int)stateStatus;
-(int)getState;
-(JpakeRound1Payload*)createRound1toSend;
-(void)validadateRound1PayloadReceived:(JpakeRound1Payload*)payload1;


-(JpakeRound2Payload*)createRound2toSend;
-(void)validadateRound2PayloadReceived:(JpakeRound2Payload *)payload2;

-(BigInteger*)calculateKeyingMaterial;
-(JpakeRound3Payload*)createRound3toSend:(BigInteger*)keyingMaterial;

-(void)validateRound3Payloadreceived:(JpakeRound3Payload*)jpakeRound3  keyingmaterial:(BigInteger*)keyingMaterial;



@end
