//
//  AIcontroller.m
//  
//
//  Created by 吕凌晟 on 15/11/3.
//
//

#import "AIcontroller.h"
#import "battleship.h"
#import "myviewcontroller.h"
#import "playgroundboard.h"

@implementation AIcontroller



/*- (void)aiSpawnShip:(int)len {
    int row = 0;
    int tailRow;
    int col = 0;
    int tailCol;
    Orientation orientation = 0;
    
    BOOL validPlacement = NO;
    
    while(!validPlacement){
        orientation = arc4random() % 2;
        row = arc4random() % 10;
        col = arc4random() % 10;
        tailRow = row;
        if(orientation == Vertical){
            tailRow += (len-1);
        }
        if(tailRow > 9){
            row += (9-tailRow);
        }
        
        tailCol = col;
        if(orientation == Horizontal){
            tailCol += (len-1);
        }
        if(tailCol > 9){
            col += (9-tailCol);
        }
        
        BOOL spaceOccupied = NO;
        for(int i = 0; i < len; ++i){
            playgroundboard* bs;
            if(orientation == Horizontal){
                bs = [[buttons objectAtIndex:row] objectAtIndex:col+i];
            }
            else{
                bs = [[buttons objectAtIndex:row+i] objectAtIndex:col];
            }
            if(bs.ship){
                spaceOccupied = YES;
            }
        }
        
        if(!spaceOccupied) validPlacement = YES;
    }
    
    float width;
    float height;
    if(orientation == Horizontal){
        width = len*spacing*spacingsPerButton + (len-1)*spacing;
        height = spacingsPerButton*spacing;
    }
    else{
        width = spacingsPerButton*spacing;
        height = len*spacing*spacingsPerButton + (len-1)*spacing;
    }
    
    battleship* ship = [[battleship alloc] initWithFrame:CGRectMake((col+1)*spacing + col*spacing*spacingsPerButton,
                                                                    (row+1)*spacing + row*spacing*spacingsPerButton,
                                                                    width,
                                                                    height)
                                                  Length:len
                                             Orientation:orientation];
    ship.backgroundColor = shipColor;
    ship.firstrow = row;
    ship.firstcol = col;
    [self addSubview:ship];
    [parent.ships addObject:ship];
    
    for(int i = 0; i < len; ++i){
        playgroundboard* bs;
        if(ship.orientation == Horizontal){
            bs = [[buttons objectAtIndex:row] objectAtIndex:col+i];
        }
        else{
            bs = [[buttons objectAtIndex:row+i] objectAtIndex:col];
        }
        bs.ship = ship;
    }
}*/

@end
