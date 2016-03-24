//
//  battleship.h
//  
//
//  Created by 吕凌晟 on 15/11/1.
//
//

#import <UIKit/UIKit.h>



@interface battleship : UIView {
    BOOL havemoved;
    int attacttime;
    CGPoint originalPosition;
    CGPoint touchStartPosition;
    CFTimeInterval touchStartTime;
}
typedef NS_ENUM(NSInteger, Orientation) { Horizontal, Vertical };
@property BOOL movable;
@property Orientation orientation;
@property int life;
@property BOOL die;
@property int firstrow;
@property int firstcol;

- (id)initWithFrame:(CGRect)frame Length:(int)l Orientation:(Orientation)o;

- (void)beattacted;

@end
