//
//  playgroundbutton.m
//  
//
//  Created by 吕凌晟 on 15/11/1.
//
//

#import <AVFoundation/AVFoundation.h>
#import "playgroundbutton.h"
#import "myviewcontroller.h"

@implementation playgroundbutton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@synthesize hasBeenAttacked;
@synthesize ship;

- (id)initWithFrame:(CGRect)frame Parent:(playground*)p {
    self = [super initWithFrame:frame];
    
    parent = p;
    hasBeenAttacked = NO;
    ship = nil;
    
    [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self setTitle:@"" forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:40]];
    
    return self;
}



- (void)beAttacked {
    hasBeenAttacked = YES;
    
    UIResponder* resp = self;
    while(![resp isKindOfClass:[myviewcontroller class]]){
        resp = [resp nextResponder];
    }
    myviewcontroller* myvc = (myviewcontroller*)resp;
    
    if(!ship){

        [self setTitle:@"O" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [myvc misssound];
    }
    else{
        [self setTitle:@"X" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [ship beattacted];
        
        [myvc hitsound];
    }
    
    float pause = 0.5;
    if(!myvc.gamemode2) {
        pause = 0;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:pause target:myvc selector:@selector(endturn) userInfo:nil repeats:NO];
}

- (void)buttonPressed {
    if(hasBeenAttacked==NO)
        if(parent.acceptingMoves){
            [self beAttacked];
    }
}

@end
