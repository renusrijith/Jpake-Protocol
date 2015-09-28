//
//  jpakeUtils.h
//  coolhash
//
//  Created by Renu Srijith on 23/06/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigInteger.h"
#import "NSData+conversion.h"



@interface jpakeUtils : NSObject
{

}

+(NSString*)convertStringtoHex:(NSString*)string;

+(BigInteger*)generateX1:(BigInteger*)q;
+(BigInteger*)generateX2:(BigInteger *)q;
+(BigInteger*)calculateS:(NSString*)password;


+(BigInteger*)returnRandomInRange:(BigInteger*)min max:(BigInteger*)max;
+(BigInteger*)calculateGx:(BigInteger*)p g:(BigInteger*)g x:(BigInteger*)x;
+(BigInteger*)calculateGA:(BigInteger*)p gx1:(BigInteger*)gx1 gx3:(BigInteger*)gx3 gx4:(BigInteger*)gx4;
+(BigInteger*)calculateX2s:(BigInteger*)q x2:(BigInteger*)x2  s:(BigInteger*)s;
+(BigInteger*)calculateA:(BigInteger *)p q:(BigInteger *)q gA:(BigInteger *)gA x2s:(BigInteger *)x2s;
+(NSArray*) calculateZeroKnowledgeProof :(BigInteger*)p Q:(BigInteger*)q G:(BigInteger*)g Gx:(BigInteger*)gx
                                       X:(BigInteger*)x ParticipantID:(NSString*)participantID;
+(BigInteger*)calculateHashForZeroKnowledgeProof:(BigInteger*)g gr:(BigInteger*)gr gx:(BigInteger*)gx ParticipantId:(NSString*)participantID ;

+(void)validateGx4:(BigInteger*)gx4;
+(void)validateGa:(BigInteger*)ga;
+(void)validateZeroKnowledgeProof:(BigInteger*)p  Q:(BigInteger*)q G:(BigInteger*)g Gx:(BigInteger*)gx
                          Nsarray:(NSArray*)zeroKnowledgeProof participantID:(NSString*)participantID;
+(BigInteger*)calculateKeyingMaterial :(BigInteger*)p Q:(BigInteger*)q GX4:(BigInteger*)gx4 X2:(BigInteger*)x2 S:(BigInteger*)s B:(BigInteger*)b;

+(void)validateParticipantIdsDiffer :(NSString*)participantId1 ParticipantID2:(NSString*)participantId2;


//last part
+(BigInteger*)calculateMacTag:(NSString*)participantID partnerParticipantID:(NSString*)partnerParticipantID
                          gx1:(BigInteger*)gx1 gx2:(BigInteger*)gx2 gx3:(BigInteger*)gx3
                         gx4 :(BigInteger*)gx4 keyingMaterial:(BigInteger*)keyingMaterial ;

+(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;

+(void)validateMacTag:(NSString*)participantId  partnerParticipantId:(NSString*)partnerParticipantId
                  gx1:(BigInteger*)gx1 gx2:(BigInteger*)gx2 gx3:(BigInteger*)gx3 gx4:(BigInteger*)gx4
       keyingMaterial:(BigInteger*)keyingMaterial partnerMacTag:(BigInteger*)partnerMacTag;



@end
