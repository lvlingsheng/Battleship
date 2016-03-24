//
//  playgroud.h
//  
//
//  Created by 吕凌晟 on 15/11/1.
//
//

#import <UIKit/UIKit.h>

@interface playground : UIView {
    NSMutableArray* buttons;
    NSMutableArray* gridLines;
    
    UIColor* shipColor;
    UIColor* bgColor;
    UIColor* borderColor;
    
    float spacing;
    int spacingsPerButton;
    
    BOOL aiFoundShip;
    int foundX;
    int foundY;
    
    BOOL knowdirection;
    BOOL checktop;
    BOOL checkleft;
    BOOL checkdown;
    BOOL checkright;
    
    BOOL playershiphead;
    BOOL playershiptail;
    int shiphead;
    int shiptail;
}

@property int player;
@property NSMutableArray* ships;
@property BOOL acceptingMoves;

- (void)placeship;

- (void)aiplaceship;

- (void)aiplaceship:(int)len;

- (void)confirmShipLocations;

- (void)hideShips;

- (void)showShips;

- (void)aiturn;

- (void)checkDirection:(int)d fromX:(int)x fromY:(int)y;

- (void)shipfirstloc;

- (void)shiplastloc;

@end

