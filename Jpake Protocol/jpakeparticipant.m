//
//  jpakeparticipant.m
//  coolhash
//
//  Created by Renu Srijith on 24/06/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import "jpakeparticipant.h"

#import "jpakeParms.h"
static int const State_init =0;
static int const State_round1_create =10;
static int const State_round1_validate =20;
static int const State_round2_create =30;
static int const State_round2_validate =40;
static int const State_key_Create=50;
static int const State_round3_create =60;
static int const State_round3_validate=70;




@implementation jpakeparticipant


+ (void)initialize {
 
}
- (id)initWithParticipantId:(NSString *)ParticipantId
                  password :(NSString *)Password
{
    if( self = [super init] )
    {
        NSAssert([Password length]!=0, @"password should not be empty");
        self.participantId = ParticipantId;
        self.password=Password;
        
        self.p=[jpakeParms getP];
        self.q=[jpakeParms getQ];
        self.g=[jpakeParms getG];
        
        [self setState:State_init];
        
    }
    
    return self;


}

-(JpakeRound1Payload*)createRound1toSend
{
   
    NSAssert([self getState]== State_init, @"round 1 created already");
    self.x1 =[jpakeUtils generateX1:[self p]];
    self.x2 =[jpakeUtils generateX2:[self q]];
    
    self.gx1=[jpakeUtils calculateGx:[self p] g:[self g] x:[self x1]];
    self.gx2=[jpakeUtils calculateGx:[self p] g:[self g] x:[self x2]];

    NSLog(@"x1 :%@  x2 :%@ gx1: %@ gx2: %@", self.x1,self.x2 ,self.gx1 ,self.gx2);
    NSArray *zkpX1=[jpakeUtils calculateZeroKnowledgeProof:[self p] Q:[self q] G:[self g] Gx:[self gx1] X:[self x1] ParticipantID:[self participantId]];
    
    NSArray *zkpX2=[jpakeUtils calculateZeroKnowledgeProof:[self p] Q:[self q] G:[self g] Gx:[self gx2] X:[self x2] ParticipantID:[self participantId]];
    [self setState:State_round1_create];
  
    JpakeRound1Payload *jround1=[[JpakeRound1Payload alloc]initWithParticipantId:[self participantId] gX1:[self gx1] gX2:[self gx2] ZkpX1:zkpX1 ZkpX2:zkpX2];
    return jround1;

}

-(void)validadateRound1PayloadReceived:(JpakeRound1Payload*)payload1
{
NSAssert([self getState] < State_round1_validate   , @"Validation already attempted for Round1 payload");
    self.partnerParticipantId =[payload1 getParticipantID];
    self.gx3=[payload1 getGx1];
    self.gx4=[payload1 getGx2];
    NSArray * zkpx3=[payload1 getZkpArrayX1];
    NSArray *zkpX4 =[payload1 getZkpArrayX2];
    [jpakeUtils validateParticipantIdsDiffer:[self participantId] ParticipantID2:[payload1 getParticipantID]];
    [jpakeUtils validateGx4:[self gx4]];
    [jpakeUtils validateZeroKnowledgeProof:[self p] Q:[self q ] G:[self g] Gx:[self gx3] Nsarray:zkpx3 participantID:[payload1 getParticipantID]];
    

    [jpakeUtils validateZeroKnowledgeProof:[self p] Q:[self q ] G:[self g] Gx:[self gx4] Nsarray:zkpX4 participantID:[payload1 getParticipantID]];
    
    [self setState:State_round1_validate];
}

-(JpakeRound2Payload*)createRound2toSend
{
    
    NSAssert([self getState]<State_round2_create, @"round 2 created already");
    BigInteger *gA =[jpakeUtils calculateGA:[self p] gx1:[self gx1] gx3:[self gx3] gx4:[self gx4]];
    BigInteger *s=[jpakeUtils calculateS:[self password]];
    BigInteger *x2S=[jpakeUtils calculateX2s:[self q] x2:[self x2] s:s];
    BigInteger *A=[jpakeUtils calculateA:[self p] q:[self q] gA:gA x2s:x2S];
    NSArray *ZKPX2s=[jpakeUtils calculateZeroKnowledgeProof:[self p] Q:[self q] G:gA Gx:A X:x2S ParticipantID:[self participantId]];
    
    [self setState:State_round2_create];
    JpakeRound2Payload *jround2= [[JpakeRound2Payload alloc]initWithParticipantId:[self participantId] a:A Zkpx2s:ZKPX2s];
    return jround2;


}

-(void)validadateRound2PayloadReceived:(JpakeRound2Payload *)payload2
{
NSAssert([self getState] < State_round2_validate   , @"Validation already attempted for Round2 payload");
    BigInteger *gB=[jpakeUtils calculateGA:[self p] gx1:[self gx3] gx3:[self gx1] gx4:[self gx2]];
    self.b =[payload2 geta];
    NSArray *zkpX4s= [payload2 getZkpX2s];
    [jpakeUtils validateParticipantIdsDiffer:[self participantId] ParticipantID2:[payload2 getParticipantID]];
    [jpakeUtils validateGx4:gB];
    [jpakeUtils validateZeroKnowledgeProof:[self p] Q:[self q] G:gB Gx:[self b] Nsarray:zkpX4s participantID:[payload2 getParticipantID]];
    
     [self setState:State_round2_validate];

}


-(BigInteger*)calculateKeyingMaterial
{
    NSAssert([self getState]<State_key_Create, @"key created already");
    BigInteger *s=[jpakeUtils calculateS:[self password]];
    BigInteger *key=[jpakeUtils calculateKeyingMaterial:[self p] Q:[self q] GX4:[self gx4] X2:[self x2] S:s B:[self b]];
    //extra work needs to be done here
    [self setState:State_key_Create];
    
    return key;
    
}

-(JpakeRound3Payload*)createRound3toSend:(BigInteger*)keyingMaterial
{
    NSAssert([self getState]<State_round3_create, @"round3 creation already done");
   // NSAssert([self getState]<State_key_Create, @"round3  should be done after key generation");
    NSLog(@"inside ");
    BigInteger *tag=[jpakeUtils calculateMacTag:[self participantId] partnerParticipantID:[self partnerParticipantId] gx1:[self gx1] gx2:[self gx2] gx3:[self gx3] gx4:[self gx4] keyingMaterial:keyingMaterial];
    [self setState:State_round3_create];
    JpakeRound3Payload *r3Payload=[[JpakeRound3Payload alloc]initWithParticipantId:[self participantId] macTag:tag];
    return r3Payload;
}

-(void)validateRound3Payloadreceived:(JpakeRound3Payload*)jpakeRound3  keyingmaterial:(BigInteger*)keyingMaterial

{

NSAssert([self getState]<State_round3_validate, @"round3 validation already done");
    
    //one step missing here
    
    [jpakeUtils validateParticipantIdsDiffer:[self participantId] ParticipantID2:[jpakeRound3 getParticipantID]];
  //one step missing here @
    [jpakeUtils validateMacTag:[self participantId] partnerParticipantId:[self partnerParticipantId] gx1:[self gx1] gx2:[self gx2] gx3:[self gx3] gx4:[self gx4] keyingMaterial:keyingMaterial partnerMacTag:[jpakeRound3 getMactag]];
    
    
    //steps missing

}

-(void)setState:(int)stateStatus
{
  state=stateStatus;
}

-(int)getState
{

    return state;
}

@end
