//
//  playgroundbutton.h
//  
//
//  Created by 吕凌晟 on 15/11/1.
//
//

#import <UIKit/UIKit.h>
#import "battleship.h"
#import "playground.h"

@interface playgroundbutton : UIButton {
    playground* parent;
}

@property BOOL hasBeenAttacked;
@property battleship* ship;

- (id)initWithFrame:(CGRect)frame Parent:(playground*)p;

- (void)buttonPressed;

- (void)beAttacked;

@end
