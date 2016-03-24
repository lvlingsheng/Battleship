//
//  myviewcontroller.h
//  
//
//  Created by 吕凌晟 on 15/11/1.
//
//

#import <UIKit/UIKit.h>
#import "playground.h"
#import "battleship.h"

@interface myviewcontroller : UIViewController<UIActionSheetDelegate> {
    UIButton *lockbutton;
    UILabel *turnlabel;
    UILabel *turnlabel2;
    UIButton *restart;
    UIActionSheet *modechoose;
    UIActionSheet *switchplayer;
    UIActionSheet *loopchangeplayer;
    UITapGestureRecognizer *tapGestureRecognizer;
    
    playground *p1ground;
    playground *p2ground;
    
    UILabel *uplabel;
    UILabel *downlabel;
    playground *bottomBoard;
    playground *topBoard;
    CGRect topRect;
    CGRect bottomRect;
    
    BOOL setupComplete;
    int playernow;
    int firstPlayer;

    int winner;
    int64_t moves;
}
@property BOOL gamemode2;
@property (weak, nonatomic) IBOutlet UILabel *startlabel;

- (void)oneplayermode;

- (void)twoplayermode;

- (void)generateship1;

- (void)generateship2;

- (void)confirmloc;

- (void)shipsPlaced;

- (void)switchPlayers;

- (void)beginGameLoop;

- (void)startoneturn;

- (void)endturn;

- (void)endgame;

- (void)hitsound;

- (void)misssound;

- (void)winsound;

- (void)restartgame;

- (void)switchPlayerchoose;

- (void)showupload;

@end
