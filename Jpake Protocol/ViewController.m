//
//  ViewController.m
//  Jpake Protocol
//
//  Created by Renu Srijith on 28/09/2015.
//  Copyright © 2015 newcastle university. All rights reserved.
//

#import "ViewController.h"
#import "jpakeparticipant.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    jpakeparticipant *alice=[[jpakeparticipant alloc]initWithParticipantId:@"alice" password:@"helloworld"];
    jpakeparticipant *bob=[[jpakeparticipant alloc]initWithParticipantId:@"bob" password:@"helloworld"];
    
    JpakeRound1Payload *r1alice=[alice createRound1toSend];
    JpakeRound1Payload *r1bob=[bob createRound1toSend];
    [alice validadateRound1PayloadReceived:r1bob];
    [bob validadateRound1PayloadReceived:r1alice];
    
    JpakeRound2Payload *r2alice=[alice createRound2toSend];
    JpakeRound2Payload *r2bob=[bob createRound2toSend];
    [alice validadateRound2PayloadReceived:r2bob];
    [bob validadateRound2PayloadReceived:r2alice];
    
    BigInteger *kalice=[alice calculateKeyingMaterial];
    BigInteger *kbob=[bob calculateKeyingMaterial];
    
    if([kalice compare:kbob]==NSOrderedSame) NSLog(@"good same key generated!");
    else NSLog(@"bad same key not generated");
    JpakeRound3Payload *r3alice=[alice createRound3toSend:kalice];
    
    JpakeRound3Payload *r3bob=[bob createRound3toSend:kbob];
    
    [alice validateRound3Payloadreceived:r3bob keyingmaterial:kalice];
    [bob validateRound3Payloadreceived:r3alice keyingmaterial:kbob];
    
    NSLog(@"wowowowowow");
    

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
