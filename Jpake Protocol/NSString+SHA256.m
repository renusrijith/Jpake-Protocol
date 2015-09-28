//
//  NSString+SHA256.m
//  coolhash
//
//  Created by Renu Srijith on 29/06/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import "NSString+SHA256.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (SHA256)

//- (NSString*) MD5 {
//    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
//    unsigned char output[outputLength];
//    
//    CC_MD5(self.UTF8String, [self UTF8Length], output);
//    return [self toHexString:output length:outputLength];;
//}
//
//- (NSString*) SHA1 {
//    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
//    unsigned char output[outputLength];
//    
//    CC_SHA1(self.UTF8String, [self UTF8Length], output);
//    return [self toHexString:output length:outputLength];;
//}

- (NSString*) SHA256 {
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];;
}

- (unsigned int) UTF8Length {
    return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
    NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return hash;
}

@end
