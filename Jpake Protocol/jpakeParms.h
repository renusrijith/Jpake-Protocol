//
//  jpakeParms.h
//  coolhash
//
//  Created by Renu Srijith on 25/06/2015.
//  Copyright (c) 2015 newcastle university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigInteger.h"
@interface jpakeParms : NSObject
+(BigInteger*)getP;
+(BigInteger*)getQ;
+(BigInteger*)getG;
@end
