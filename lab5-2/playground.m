//
//  playgroud.m
//  
//
//  Created by 吕凌晟 on 15/11/1.
//
//

#import "playground.h"
#import "playgroundbutton.h"
#import "battleship.h"
#import "myviewcontroller.h"

@implementation playground{
    Orientation foundOrientation;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@synthesize player;
@synthesize ships;
@synthesize acceptingMoves;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    shipColor = [UIColor grayColor];
    borderColor = [UIColor whiteColor];
    
    [self setBackgroundColor:[UIColor blueColor]];
    buttons = [[NSMutableArray alloc] init];
    gridLines = [[NSMutableArray alloc] init];
    
    CGRect myRect = self.frame;
    float width = CGRectGetWidth(myRect);
    
    spacingsPerButton = 5;
    spacing = width / (spacingsPerButton*10 + 11);
    float button = spacing * spacingsPerButton;
    
    //spawn grid borders
    UIView* v;
    for(int i = 0; i < 11; ++i){
        v = [[UIView alloc] initWithFrame:CGRectMake(6*spacing*i, 0, spacing, width)];
        [v setBackgroundColor:borderColor];
        [self addSubview:v];
        [gridLines addObject:v];
        
        v = [[UIView alloc] initWithFrame:CGRectMake(0, 6*spacing*i, width, spacing)];
        [v setBackgroundColor:borderColor];
        [self addSubview:v];
        [gridLines addObject:v];
    }
    
    //spawn buttons
    float y = spacing;
    for(int i = 0; i < 10; ++i){
        NSMutableArray* row = [[NSMutableArray alloc] init];
        [buttons addObject:row];
        
        float x = spacing;
        for(int j = 0; j < 10; ++j){
            playgroundbutton* sq = [[playgroundbutton alloc] initWithFrame:CGRectMake(x, y, button, button) Parent:self];
            [sq setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [row addObject:sq];
            
            [self addSubview:sq];
            
            x += spacing+button;
        }
        
        y += spacing+button;
    }
    
    ships = [[NSMutableArray alloc] init];
    
    acceptingMoves = NO;
    
    aiFoundShip = NO;
    knowdirection = NO;
    playershiphead = NO;
    playershiptail = NO;
    
    return self;
}

- (void)placeship {
    int len = 5;
    battleship *ship = [[battleship alloc] initWithFrame:CGRectMake(spacing,
                                                        spacing,
                                                        spacing*spacingsPerButton,
                                                        len*spacing*spacingsPerButton + (len-1)*spacing)
                                      Length:len
                                 Orientation:Vertical];
    ship.backgroundColor = shipColor;
    
    [self addSubview:ship];
    [ships addObject:ship];
    
    len = 4;
    ship = [[battleship alloc] initWithFrame:CGRectMake(7*spacing,
                                                  spacing,
                                                  spacing*spacingsPerButton,
                                                  len*spacing*spacingsPerButton + (len-1)*spacing)
                                Length:len
                           Orientation:Vertical];
    ship.backgroundColor = shipColor;
    [self addSubview:ship];
    [ships addObject:ship];
    
    len = 3;
    ship = [[battleship alloc] initWithFrame:CGRectMake(13*spacing,
                                                  spacing,
                                                  spacing*spacingsPerButton,
                                                  len*spacing*spacingsPerButton + (len-1)*spacing)
                                Length:len
                           Orientation:Vertical];
    ship.backgroundColor = shipColor;
    [self addSubview:ship];
    [ships addObject:ship];
    
    len = 3;
    ship = [[battleship alloc] initWithFrame:CGRectMake(19*spacing,
                                                  spacing,
                                                  spacing*spacingsPerButton,
                                                  len*spacing*spacingsPerButton + (len-1)*spacing)
                                Length:len
                           Orientation:Vertical];
    ship.backgroundColor = shipColor;
    [self addSubview:ship];
    [ships addObject:ship];
    
    len = 2;
    ship = [[battleship alloc] initWithFrame:CGRectMake(25*spacing,
                                                  spacing,
                                                  spacing*spacingsPerButton,
                                                  len*spacing*spacingsPerButton + (len-1)*spacing)
                                Length:len
                           Orientation:Vertical];
    ship.backgroundColor = shipColor;
    [self addSubview:ship];
    [ships addObject:ship];
}

- (void)aiplaceship {
    [self aiplaceship:5];
    [self aiplaceship:4];
    [self aiplaceship:3];
    [self aiplaceship:3];
    [self aiplaceship:2];
    
    for(int i = 0; i < 5; ++i){
        battleship* ship = [ships objectAtIndex:i];
        
        ship.movable = NO;
        [self sendSubviewToBack:ship];
    }
    
    UIResponder* resp = self;
    while(![resp isKindOfClass:[myviewcontroller class]]){
        resp = [resp nextResponder];
    }
    
    myviewcontroller* gvc = (myviewcontroller*)resp;
    [gvc shipsPlaced];
}

- (void)aiplaceship:(int)len {
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
        
        BOOL usedspace = NO;
        for(int i = 0; i < len; ++i){
            playgroundbutton* bs;
            if(orientation == Horizontal){
                bs = [[buttons objectAtIndex:row] objectAtIndex:col+i];
            }
            else{
                bs = [[buttons objectAtIndex:row+i] objectAtIndex:col];
            }
            if(bs.ship){
                usedspace = YES;
            }
        }
        
        if(!usedspace) validPlacement = YES;
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
    [ships addObject:ship];
    
    for(int i = 0; i < len; ++i){
        playgroundbutton* bs;
        if(ship.orientation == Horizontal){
            bs = [[buttons objectAtIndex:row] objectAtIndex:col+i];
        }
        else{
            bs = [[buttons objectAtIndex:row+i] objectAtIndex:col];
        }
        bs.ship = ship;
    }
}

- (void)confirmShipLocations {
    //snap ships to grid
    BOOL offGrid = NO;
    for(int i = 0; i < 5; ++i){
        battleship* ship = [ships objectAtIndex:i];
        
        int row = (int)lroundf((ship.frame.origin.y - spacing)/((spacingsPerButton+1)*spacing));
        int tailRow = row;
        if(ship.orientation == Vertical) tailRow += (ship.life-1);
        if(row < 0){
            row = 0;
            offGrid = YES;
        }
        if(tailRow > 9){
            row += (9-tailRow);
            offGrid = YES;
        }
        
        int col = (int)lroundf((ship.frame.origin.x - spacing)/((spacingsPerButton+1)*spacing));
        int tailCol = col;
        if(ship.orientation == Horizontal) tailCol += (ship.life-1);
        if(col < 0){
            col = 0;
            offGrid = YES;
        }
        if(tailCol > 9){
            col += (9-tailCol);
            offGrid = YES;
        }
        
        CGRect shipFrame = ship.frame;
        shipFrame.origin.x = (col+1)*spacing + (col)*spacingsPerButton*spacing;
        shipFrame.origin.y = (row+1)*spacing + (row)*spacingsPerButton*spacing;
        
        ship.frame = shipFrame;
        
        ship.firstrow = row;
        ship.firstcol = col;
    }
    if(offGrid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Ships Not Placed Correctly"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    //check for overlaps
    for(int i = 0; i < 5; ++i){
        battleship* ship = [ships objectAtIndex:i];
        
        for(int j = 0; j < ship.life; ++j){
            playgroundbutton* bs;
            if(ship.orientation == Horizontal){
                bs = [[buttons objectAtIndex:ship.firstrow] objectAtIndex:ship.firstcol+j];
            }
            else{
                bs = [[buttons objectAtIndex:ship.firstrow+j] objectAtIndex:ship.firstcol];
            }
            if(!bs.ship){
                bs.ship = ship;
            }
            else{
                //found an overlap
                for(int a = 0; a < 10; ++a){
                    for(int b = 0; b < 10; ++b){
                        playgroundbutton* sq = [[buttons objectAtIndex:a] objectAtIndex:b];
                        sq.ship = nil;
                    }
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Ships Cannot Overlap"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                return;
            }
        }
    }
    
    //ship locations are all fine
    for(int i = 0; i < 5; ++i){
        battleship* ship = [ships objectAtIndex:i];
        
        ship.movable = NO;
        [self sendSubviewToBack:ship];
    }
    for(int i = 0; i < 22; ++i){
        UIView* v = [gridLines objectAtIndex:i];
        [self sendSubviewToBack:v];
    }
    
    UIResponder* resp = self;
    while(![resp isKindOfClass:[myviewcontroller class]]){
        resp = [resp nextResponder];
    }
    
    myviewcontroller* gvc = (myviewcontroller*)resp;
    [gvc shipsPlaced];
}

- (void)hideShips {
    for(int i = 0; i < 5; ++i){
        battleship* ship = [ships objectAtIndex:i];
        ship.hidden = YES;
    }
}

- (void)showShips {
    for(int i = 0; i < 5; ++i){
        battleship* ship = [ships objectAtIndex:i];
        ship.hidden = NO;
    }
}

- (void)aiturn {
    if(aiFoundShip){
        if(knowdirection){
            if(playershiphead){
                if(playershiptail){
                    aiFoundShip = NO;
                    
                    knowdirection = NO;
                    checktop = NO;
                    checkleft = NO;
                    checkdown = NO;
                    checkright = NO;
                    
                    playershiphead = NO;
                    playershiptail = NO;
                    
                    [self aiturn];
                }
                else{
                    [self shiplastloc];
                }
            }
            else{
                [self shipfirstloc];
            }
        }
        else{
            if(checktop) {
                if(checkleft){
                    if(checkdown){
                        if(checkright){
                            aiFoundShip = NO;
                            [self aiturn];
                        }
                        else{
                            [self checkDirection:3 fromX:foundX fromY:foundY];
                        }
                    }
                    else{
                        [self checkDirection:2 fromX:foundX fromY:foundY];
                    }
                }
                else{
                    [self checkDirection:1 fromX:foundX fromY:foundY];
                }
            }
            else{
                [self checkDirection:0 fromX:foundX fromY:foundY];
            }
        }
    }
    else{
        BOOL keepLooking = YES;
        while(keepLooking){
            int x = arc4random() % 10;
            int y = arc4random() % 10;
            
            playgroundbutton* sq = [[buttons objectAtIndex:y] objectAtIndex:x];
            if(!sq.hasBeenAttacked){
                keepLooking = NO;
                
                [sq beAttacked];
                
                if(sq.ship){
                    aiFoundShip = YES;
                    foundX = x;
                    foundY = y;
                }
            }
        }
    }
}

- (void)checkDirection:(int)d fromX:(int)x fromY:(int)y {
    int checkX = x;
    int checkY = y;
    
    switch (d) {
        case 0:
            checkY--;
            if(checkY < 0){
                checktop = YES;
                [self aiturn];
                return;
            }
            break;
        case 1:
            checkX--;
            if(checkX < 0){
                checkleft = YES;
                [self aiturn];
                return;
            }
            break;
        case 2:
            ++checkY;
            if(checkY > 9){
                checkdown = YES;
                [self aiturn];
                return;
            }
            break;
        case 3:
            ++checkX;
            if(checkX > 9){
                checkright = YES;
                [self aiturn];
                return;
            }
            break;
    }
    
    playgroundbutton* sq = [[buttons objectAtIndex:checkY] objectAtIndex:checkX];
    
    if(sq.hasBeenAttacked){
        if(sq.ship){
            [self checkDirection:d fromX:checkX fromY:checkY];
        }
        else{
            switch (d) {
                case 0:
                    checktop = YES;
                    [self aiturn];
                    break;
                case 1:
                    checkleft = YES;
                    [self aiturn];
                    break;
                case 2:
                    checkdown = YES;
                    [self aiturn];
                    break;
                case 3:
                    checkright = YES;
                    [self aiturn];
                    break;
            }
        }
    }
    else{
        if(sq.ship){
            switch (d) {
                case 0:
                case 2:
                    foundOrientation = Vertical;
                    shiphead = MAX(foundY, checkY);
                    shiptail = MIN(foundY, checkY);
                    break;
                case 1:
                case 3:
                    foundOrientation = Horizontal;
                    shiphead = MAX(foundX, checkX);
                    shiptail = MIN(foundX, checkX);
                    break;
            }
            
            knowdirection = YES;
        }
        else{
            switch (d) {
                case 0:
                    checktop = YES;
                    break;
                case 1:
                    checkleft = YES;
                    break;
                case 2:
                    checkdown = YES;
                    break;
                case 3:
                    checkright = YES;
                    break;
            }
        }
        
        [sq beAttacked];
    }
}

- (void)shipfirstloc {
    int check = shiphead+1;
    
    if(check > 9){
        playershiphead = YES;
        [self aiturn];
    }
    else{
        playgroundbutton* sq;
        
        if(foundOrientation == Vertical){
            sq = [[buttons objectAtIndex:check] objectAtIndex:foundX];
        }
        else{
            sq = [[buttons objectAtIndex:foundY] objectAtIndex:check];
        }
        
        if(sq.hasBeenAttacked){
            if(sq.ship){
                shiphead = check;
                [self shipfirstloc];
            }
            else{
                playershiphead = YES;
                [self aiturn];
            }
        }
        else{
            if(sq.ship){
                shiphead = check;
            }
            else{
                playershiphead = YES;
            }
            
            [sq beAttacked];
        }
    }
}

- (void)shiplastloc {
    int check = shiptail-1;
    
    if(check < 0){
        playershiptail = YES;
        [self aiturn];
    }
    else{
        playgroundbutton* sq;
        
        if(foundOrientation == Vertical){
            sq = [[buttons objectAtIndex:check] objectAtIndex:foundX];
        }
        else{
            sq = [[buttons objectAtIndex:foundY] objectAtIndex:check];
        }
        
        if(sq.hasBeenAttacked){
            if(sq.ship){
                shiptail = check;
                [self shiplastloc];
            }
            else{
                playershiptail = YES;
                [self aiturn];
            }
        }
        else{
            if(sq.ship){
                shiptail = check;
            }
            else{
                playershiptail = YES;
            }
            
            [sq beAttacked];
        }
    }
}

@end

