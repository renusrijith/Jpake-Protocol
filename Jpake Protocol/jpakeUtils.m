//
//  jpakeUtils.m
//  coolhash
//
//  Created by Renu Srijith on 23/06/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import "jpakeUtils.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+SHA256.h"


static BigInteger* Zero;
static BigInteger* One;

@implementation jpakeUtils

+ (void)initialize {
     Zero=[[BigInteger alloc]initWithInt32:0];
    One=[[BigInteger alloc]initWithInt32:1];

}

//Return a value that can be used as X1 or X3 during round 1
//between the range [0,q-1]
+(BigInteger*)generateX1:(BigInteger*)q
{
    BigInteger *q1=[[BigInteger alloc]initWithInt32:0];
    q1=[q sub:One];
   
    return [self returnRandomInRange:Zero max:q1];
    
}
//Return a value that can be used as X2 or X4 during round 1
//between the range [1,q-1]

+(BigInteger*)generateX2:(BigInteger *)q
{
    BigInteger *q1=[[BigInteger alloc]initWithInt32:0];
    q1=[q sub:One];

    return [self returnRandomInRange:One max:q1];

}


+(BigInteger*)returnRandomInRange:(BigInteger*)min max:(BigInteger*)max
{
   
       BigInteger *rvalue=[[BigInteger alloc]initWithInt32:0];
       while(true)
       {
          
           BigInteger *i=[[BigInteger alloc]initWithRandomNumberOfSize:192 exact:YES];
       
       // if i < maximum && i>min return i
           if([i compare:max]==NSOrderedAscending && [i compare:min] == NSOrderedDescending)
           {rvalue =i;
               i=nil;
               break;}
          }
        return rvalue;
  
}

+(NSString*)convertStringtoHex:(NSString*)string
{
    NSUInteger len = [string length];
    unichar *chars = malloc(len * sizeof(unichar));
    [string getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    return hexString;


}
+(BigInteger*)calculateS:(NSString*)password
{
   
    BigInteger *ret =[[BigInteger alloc]initWithString:[jpakeUtils convertStringtoHex:password] radix:16];
    return  ret;
}

+(BigInteger*)calculateGx:(BigInteger*)p g:(BigInteger*)g x:(BigInteger*)x

{
    return [g exp:x modulo:p];


}


+(BigInteger*)calculateGA:(BigInteger*)p gx1:(BigInteger*)gx1 gx3:(BigInteger*)gx3 gx4:(BigInteger*)gx4
{
   BigInteger *newGx1= [gx1 multiply:gx3];
    return  [newGx1 multiply:gx4 modulo:p];

}

+(BigInteger*)calculateX2s:(BigInteger*)q x2:(BigInteger*)x2  s:(BigInteger*)s
{
    return [x2 multiply:s modulo:q];
}

+(BigInteger*)calculateA:(BigInteger *)p q:(BigInteger *)q gA:(BigInteger *)gA x2s:(BigInteger *)x2s
{

    return [gA exp:x2s modulo:p];

}

+(NSArray*) calculateZeroKnowledgeProof :(BigInteger*)p Q:(BigInteger*)q G:(BigInteger*)g Gx:(BigInteger*)gx
                                       X:(BigInteger*)x ParticipantID:(NSString*)participantID

{
    BigInteger *max =[[BigInteger alloc]initWithInt32:0];
    max=[q sub:One];
    BigInteger *v=[self returnRandomInRange:Zero max:max];
   // v=[q sub:One];
    BigInteger *gv=[[BigInteger alloc]initWithInt32:0];
    gv=[g exp:v modulo:p];
    BigInteger *h = [[BigInteger alloc]initWithInt32:0];
    h=[jpakeUtils calculateHashForZeroKnowledgeProof:g gr:gv gx:gx ParticipantId:participantID];
    
  
    BigInteger *ha=[[BigInteger alloc]initWithInt32:0];
    
    ha=[[v sub:[x multiply:h]]multiply:One modulo:q];//r=v-xh
    
    return [[NSArray alloc] initWithObjects:gv, ha, nil];


}

+(BigInteger*)calculateHashForZeroKnowledgeProof:(BigInteger*)g gr:(BigInteger*)gr gx:(BigInteger*)gx ParticipantId:(NSString*)participantID

{

    NSString *stringG= [g toRadix:16];
    NSString *stringGr=[ gr toRadix:16];
    NSString *stringGx=[ gx toRadix:16];
    NSMutableString *string = [NSMutableString stringWithString:stringG];
    [string appendString:stringGr];
    [string appendString:stringGx];
    [string appendString:participantID];
    NSString *sh256Hash =[string SHA256];
    NSString *hexString=[jpakeUtils convertStringtoHex:sh256Hash];
    
       return [[BigInteger alloc]initWithString:hexString radix:16];
   
}

+(void)validateGx4:(BigInteger*)gx4
{
    NSAssert(![gx4 isEqualToBigInteger:One], @"G^x validation failed. It should not be 1");

}

+(void)validateGa:(BigInteger*)ga;

{
    NSAssert(![ga isEqualToBigInteger:One], @"ga is equal to 1.It should not be.The chances of it happening is of the order of 2^160 for a 160 bit q.Try again!!");
    
}

+(void)validateZeroKnowledgeProof:(BigInteger*)p  Q:(BigInteger*)q G:(BigInteger*)g Gx:(BigInteger*)gx
                          Nsarray:(NSArray*)zeroKnowledgeProof participantID:(NSString*)participantID
{
    BigInteger *gv=[[BigInteger alloc]initWithBigInteger:zeroKnowledgeProof[0]];
    BigInteger *r=[[BigInteger alloc]initWithBigInteger:zeroKnowledgeProof[1]];
    
    
    BigInteger *h=[jpakeUtils calculateHashForZeroKnowledgeProof:g gr:gv gx:gx ParticipantId:participantID];
   
  
    
    
    NSAssert([gx compare:Zero]==NSOrderedDescending, @"Zero knowledge proof validation failed");
   // if!(gx<p) throw exception
    NSAssert([gx compare:p]==NSOrderedAscending, @"Zero knowledge proof validation failed");
    
//    //! gx^qmodp==1 throw exception
    NSAssert([[gx exp:q modulo:p] compare:One]==NSOrderedSame, @"Zero knowledge proof validation failed");
//    // ! g^v= g^r * gx^h throw exception
    NSAssert([[[g exp:r modulo:p] multiply:[gx exp:h modulo:p] modulo:p] compare:gv]==NSOrderedSame, @"zkp failed");
 
   }




+(BigInteger*)calculateKeyingMaterial :(BigInteger*)p Q:(BigInteger*)q GX4:(BigInteger*)gx4 X2:(BigInteger*)x2 S:(BigInteger*)s B:(BigInteger*)b
{
    //return gx4.modPow(x2.multiply(s).negate().mod(q), p).multiply(B).modPow(x2, p);
    return [[[gx4 exp:[x2 multiply:[s negate] modulo:q] modulo:p] multiply:b ]exp:x2 modulo:p];
}



+(void)validateParticipantIdsDiffer :(NSString*)participantId1 ParticipantID2:(NSString*)participantId2
{

    NSAssert(!([participantId1 compare:participantId2] ==NSOrderedSame), @"Both participant uses same ID.not allowed");

}


//last part


+(BigInteger*)calculateMacTag:(NSString*)participantID partnerParticipantID:(NSString*)partnerParticipantID
                          gx1:(BigInteger*)gx1 gx2:(BigInteger*)gx2 gx3:(BigInteger*)gx3
                         gx4 :(BigInteger*)gx4 keyingMaterial:(BigInteger*)keyingMaterial
{
    
    NSString *initDataString=@"KC_1_U";
    NSString *initKeyString=@"JPAKE_KC";
    
    NSString *stringGx1= [gx1 toRadix:16];
    NSString *stringGx2=[ gx2 toRadix:16];
    NSString *stringGx3=[ gx3 toRadix:16];
    NSString *stringGx4=[ gx4 toRadix:16];
   
    
    NSMutableString *string = [NSMutableString stringWithString:initDataString];
    [string appendString:participantID];
    [string appendString:partnerParticipantID];
    [string appendString:stringGx1];
    [string appendString:stringGx2];
    [string appendString:stringGx3];
    [string appendString:stringGx4];
    
    
    NSString *keyString=[keyingMaterial toRadix:16];
    NSMutableString *macKey=[NSMutableString stringWithString:keyString];
    [macKey appendString:initKeyString];
    
    
    NSString *Hmac =[jpakeUtils hmac:string withKey:macKey];
   
    NSString *hexString=[jpakeUtils convertStringtoHex:Hmac];
    
    return [[BigInteger alloc]initWithString:hexString radix:16];
    
    
}


+(void)validateMacTag:(NSString*)participantId  partnerParticipantId:(NSString*)partnerParticipantId
                  gx1:(BigInteger*)gx1 gx2:(BigInteger*)gx2 gx3:(BigInteger*)gx3 gx4:(BigInteger*)gx4
       keyingMaterial:(BigInteger*)keyingMaterial partnerMacTag:(BigInteger*)partnerMacTag
{
    
    BigInteger *expectedMacTag=[jpakeUtils calculateMacTag:partnerParticipantId partnerParticipantID:participantId gx1:gx3 gx2:gx4 gx3:gx1 gx4:gx2 keyingMaterial:keyingMaterial];
    
    NSLog(@"expected mactag %@",expectedMacTag);
    NSAssert([expectedMacTag compare:partnerMacTag]==NSOrderedSame, @"mac tag validation failed");
}


+(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    return HMAC;
}










@end
