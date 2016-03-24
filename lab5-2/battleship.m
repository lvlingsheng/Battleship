//
//  battleship.m
//  
//
//  Created by 吕凌晟 on 15/11/1.
//
//

#import "battleship.h"


@implementation battleship

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@synthesize movable;
@synthesize firstrow;
@synthesize firstcol;
@synthesize orientation;
@synthesize life;
@synthesize die;

- (id)initWithFrame:(CGRect)frame Length:(int)l Orientation:(Orientation)o {
    
    movable = YES;
    die = NO;
    havemoved = NO;
    life = l;
    orientation = o;
    attacttime = 0;
    self = [super initWithFrame:frame];
    return self;
}

- (void)beattacted {
    attacttime++;
    if(attacttime == life){
        die = YES;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(movable){
        touchStartTime = CACurrentMediaTime();
        
        havemoved = YES;
        
        originalPosition = self.center;
        UITouch *touch = [touches anyObject];
        touchStartPosition = [touch locationInView:self.superview];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(movable){
        UITouch *touch = [touches anyObject];
        CGPoint currentPosition = [touch locationInView: self.superview];
        
        
        [UIView animateWithDuration:.00001
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             self.center = CGPointMake(originalPosition.x+currentPosition.x-touchStartPosition.x,
                                                       originalPosition.y+currentPosition.y-touchStartPosition.y);
                         }
                         completion:^(BOOL finished) {}];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(movable){
        CFTimeInterval elapsedTime = CACurrentMediaTime() - touchStartTime;
        havemoved = NO;
        
        if(elapsedTime < 0.1){
            if(orientation == Horizontal){
                orientation = Vertical;
                self.transform = CGAffineTransformRotate(self.transform, M_PI/2);
            }
            else{
                orientation = Horizontal;
                self.transform = CGAffineTransformRotate(self.transform, -M_PI/2);
            }
        }
    }
}

@end

