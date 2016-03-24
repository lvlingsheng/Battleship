//
//  myviewcontroller.m
//  
//
//  Created by 吕凌晟 on 15/11/1.
//
//

#import "myviewcontroller.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AIcontroller.h"
#import "gamecentercontrol.h"
@implementation myviewcontroller {
}


@synthesize gamemode2;



- (void)viewDidLoad {
    [super viewDidLoad];

    [[gamecentercontrol sharedInstance] authenticateLocalUser];
    
}

- (void)viewDidAppear:(BOOL)animated{
    //[self gamemodechoose];

    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gamemodechoose)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    setupComplete = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];

}


- (void)hitsound {
    SystemSoundID hit;
    NSString *strSoundFilehit = [[NSBundle mainBundle] pathForResource:@"hit" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFilehit],&hit);
    AudioServicesPlaySystemSound(hit);
}

- (void)misssound {
    SystemSoundID losthit;
    NSString *strSoundFilelosthit = [[NSBundle mainBundle] pathForResource:@"lost-hit" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFilelosthit],&losthit);
    AudioServicesPlaySystemSound(losthit);
}

- (void)winsound {
    
    SystemSoundID gamewin;
    NSString *strSoundFilegamewin = [[NSBundle mainBundle] pathForResource:@"gamewin" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFilegamewin],&gamewin);
    AudioServicesPlaySystemSound(gamewin);
}


-(void)gamemodechoose{
    moves=0;
    
    [self.view removeGestureRecognizer:tapGestureRecognizer];
    self.startlabel.hidden=YES;
    modechoose = [[UIActionSheet alloc]
                  initWithTitle:@"Choose game mode"
                  delegate:self
                  cancelButtonTitle:nil
                  destructiveButtonTitle:nil
                  otherButtonTitles:@"one player", @"multiplayer", nil];
    modechoose.tag=1;
    [modechoose showInView:self.view];
}

-(void)switchPlayerchoose{
    restart.hidden=YES;
    switchplayer = [[UIActionSheet alloc]
                  initWithTitle:@"Please Hand over device to another player"
                  delegate:self
                  cancelButtonTitle:nil
                  destructiveButtonTitle:nil
                  otherButtonTitles:@"Done", nil];
   
    switchplayer.tag=2;
    [switchplayer showInView:self.view];
}

-(void)gameloopchangeplayer{
    restart.hidden=YES;
    loopchangeplayer = [[UIActionSheet alloc]
                    initWithTitle:@"Please Hand over device to another player"
                    delegate:self
                    cancelButtonTitle:nil
                    destructiveButtonTitle:nil
                    otherButtonTitles:@"Done", nil];
    loopchangeplayer.tag=3;
    [loopchangeplayer showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if(actionSheet.tag==1){
        if(buttonIndex==0){
            
            [self oneplayermode];
            
        }else{
            
            [self twoplayermode];
            
        }
    }
    if(actionSheet.tag==2){
        if(buttonIndex==0){
            [self generateship2];
        }
    }
    if(actionSheet.tag==3){
        if(buttonIndex==0){
            [self startoneturn];
        }
    }
}

- (void)oneplayermode {
    gamemode2 = NO;
    firstPlayer = 1;
    
    [self generateship1];
}

- (void)twoplayermode {
    gamemode2 = YES;
    firstPlayer = 1;
    
    [self performSelectorOnMainThread:@selector(generateship1) withObject:nil waitUntilDone:NO];
}



- (void)generateship1 {
    playernow = 1;
    
    CGRect currentview = self.view.frame;
    CGFloat width = CGRectGetWidth(currentview);
    CGFloat height = CGRectGetHeight(currentview);
    CGFloat boardScaling = 0.8;
    CGFloat verticalSpacing = (height-(width*boardScaling))/2.0;
    CGFloat horizontalSpacing = (width-(width*boardScaling))/2.0;
    
    turnlabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.1, height*0.77, width*0.8, verticalSpacing*0.6)];
    //verticalSpacing*0.25
    turnlabel.text = @"Place the first player's ship. Hit: Tap ship to rorate";
    turnlabel.numberOfLines = 0;
    turnlabel.textAlignment = NSTextAlignmentCenter;
    turnlabel.font=[UIFont fontWithName:@"Helvetica-Light" size:25];
    [self.view addSubview:turnlabel];
    
    p1ground = [[playground alloc] initWithFrame:CGRectMake(horizontalSpacing,
                                                      verticalSpacing,
                                                      width*boardScaling,
                                                      width*boardScaling)];
    p1ground.player = firstPlayer;
    [self.view addSubview:p1ground];
    
    lockbutton = [[UIButton alloc] initWithFrame:CGRectMake(width*0.05, height-0.8*verticalSpacing, width*0.9, verticalSpacing*0.3)];
    [lockbutton addTarget:self
                       action:@selector(confirmloc)
             forControlEvents:UIControlEventTouchUpInside];
    
    [lockbutton setTitle:@"Lock your placement" forState:UIControlStateNormal];
    [lockbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    lockbutton.hidden=NO;
    [self.view addSubview:lockbutton];
    
     restart= [[UIButton alloc] initWithFrame:CGRectMake(width*0.1, height-0.4*verticalSpacing, width*0.8, verticalSpacing*0.15)];
    [restart addTarget:self
                   action:@selector(restartgame)
         forControlEvents:UIControlEventTouchUpInside];
    
    [restart setTitle:@"restart game" forState:UIControlStateNormal];
    [restart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    restart.hidden=NO;
    [self.view addSubview:restart];
    [p1ground placeship];
}

- (void)generateship2 {
    playernow = 2;
    
    restart.hidden=NO;
    turnlabel.hidden = NO;
    turnlabel.text = @"Place the second player's ship. Hit: Tap ship to rorate";
    
    CGRect currentview = self.view.frame;
    CGFloat width = CGRectGetWidth(currentview);
    CGFloat height = CGRectGetHeight(currentview);
    CGFloat boardScaling = 0.8;
    CGFloat verticalSpacing = (height-(width*boardScaling))/2.0;
    CGFloat horizontalSpacing = (width-(width*boardScaling))/2.0;
    
    p2ground = [[playground alloc] initWithFrame:CGRectMake(horizontalSpacing,
                                                      verticalSpacing,
                                                      width*boardScaling,
                                                      width*boardScaling)];
    
    [self.view addSubview:p2ground];
    if(firstPlayer==1){
        p2ground.player=2;
    }else{
        p2ground.player=1;
    }
    
    
    
    
    if(gamemode2==TRUE){
        lockbutton.hidden = NO;
        [p2ground placeship];
    }
    else{
        p2ground.hidden = YES;
        
        [p2ground aiplaceship];
    }
}

- (void)switchPlayers {
    moves=moves+1;
    p1ground.hidden = YES;
    p2ground.hidden = YES;
    uplabel.hidden = YES;
    downlabel.hidden = YES;
    turnlabel.hidden = YES;
    restart.hidden =NO;
    
    if(playernow==1){
        playernow=2;
    }else{
        playernow=1;
    }
    

   
    
    NSString* playernowText;
    if(playernow == 1) {
        playernowText = @"Player One";
    }
    else {
        playernowText = @"Player Two";
    }

    [turnlabel setText:[playernowText stringByAppendingString:@"'s turn"]];
    turnlabel.font=[UIFont fontWithName:@"Helvetica-Light" size:15];
    
    
    if(gamemode2)
        //playerSwitchButton.hidden = NO;
        [self gameloopchangeplayer];
    
    if(setupComplete){
        if(gamemode2){
            playground* tmp = bottomBoard;
            bottomBoard = topBoard;
            topBoard = tmp;
            
            topBoard.frame = topRect;
            [topBoard hideShips];
            
            bottomBoard.frame = bottomRect;
            [bottomBoard showShips];
        }
        
        if(gamemode2 || playernow == 1) topBoard.acceptingMoves = YES;
        bottomBoard.acceptingMoves = NO;
    }
    
    if(!gamemode2) {
        [self startoneturn];
    }
}

- (void)confirmloc {
    if(playernow == 1){
        p1ground.hidden=YES;
        //restart.hidden=YES;
        [p1ground confirmShipLocations];
    }
    else {
        //p2ground.hidden=YES;
        //restart.hidden=YES;
        [p2ground confirmShipLocations];
    }
}

- (void)shipsPlaced {
    restart.hidden=YES;
    if(playernow == 1){
        lockbutton.hidden = YES;
        turnlabel.hidden = YES;
        
        if(gamemode2){

            [self switchPlayerchoose];

        }
        else{

            [self generateship2];
        }
    }
    else{
        lockbutton.hidden = YES;
        turnlabel.hidden = YES;
        
        [self beginGameLoop];
        

    }
}

- (void)beginGameLoop {
    restart.hidden=NO;
    p1ground.hidden = YES;
    p2ground.hidden = YES;
    
    CGRect currentview = self.view.frame;
    CGFloat width = CGRectGetWidth(currentview);
    CGFloat height = CGRectGetHeight(currentview);
    
    CGFloat boardScaling = 0.5;
    CGFloat verticalSpacing = (height-(width*2*boardScaling))/3.0;
    CGFloat horizontalSpacing = (width-(width*boardScaling))/2.0;
    
    topRect = CGRectMake(horizontalSpacing, verticalSpacing, width*boardScaling, width*boardScaling);
    bottomRect = CGRectMake(horizontalSpacing, verticalSpacing*2 + width*boardScaling, width*boardScaling, width*boardScaling);
    
    p1ground.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5/0.8, 0.5/0.8);
    uplabel = [[UILabel alloc] initWithFrame:CGRectMake(topRect.origin.x, topRect.origin.y - topRect.size.height*0.1, topRect.size.width, topRect.size.height*0.1)];
    [uplabel setText:@"Enemy Board"];
    uplabel.font=[UIFont fontWithName:@"Helvetica-Light" size:15];
    [uplabel setTextAlignment:NSTextAlignmentCenter];
    uplabel.hidden = YES;
    [self.view addSubview:uplabel];
    
    p2ground.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5/0.8, 0.5/0.8);
    downlabel = [[UILabel alloc] initWithFrame:CGRectMake(bottomRect.origin.x, bottomRect.origin.y - bottomRect.size.height*0.1, bottomRect.size.width, bottomRect.size.height*0.1)];
    [downlabel setText:@"Your Board"];
    downlabel.font=[UIFont fontWithName:@"Helvetica-Light" size:15];
    [downlabel setTextAlignment:NSTextAlignmentCenter];
    downlabel.hidden = YES;
    [self.view addSubview:downlabel];
    
    NSString* playernowText;
    if(playernow == 1) playernowText = @"Player One";
    else playernowText = @"Player Two";
    
    turnlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width, verticalSpacing*0.5)];
    [turnlabel setText:[playernowText stringByAppendingString:@"'s turn"]];
    turnlabel.font=[UIFont fontWithName:@"Helvetica-Light" size:20];
    [turnlabel setTextAlignment:NSTextAlignmentCenter];
    turnlabel.hidden = YES;
    [self.view addSubview:turnlabel];
    
    setupComplete = YES;
    
    topBoard = p1ground;
    topBoard.frame = topRect;
    [topBoard hideShips];
    
    bottomBoard = p2ground;
    bottomBoard.frame = bottomRect;
    [bottomBoard showShips];
    
    if(!gamemode2) {
        topBoard = p2ground;
        topBoard.frame = topRect;
        [topBoard hideShips];
        topBoard.hidden = NO;
        
        bottomBoard = p1ground;
        bottomBoard.frame = bottomRect;
        [bottomBoard showShips];
        bottomBoard.hidden = NO;
    }
    else {
        topBoard.acceptingMoves = YES;
        bottomBoard.acceptingMoves = NO;
    }
    
    if(firstPlayer == 2){
        [self startoneturn];
    }
    else{
        [self switchPlayers];
    }
}

- (void)startoneturn {
    
    restart.hidden=NO;
    topBoard.hidden = NO;
    bottomBoard.hidden = NO;
    uplabel.hidden = NO;
    downlabel.hidden = NO;
    turnlabel.hidden = NO;
    
    if(gamemode2==false){
        if(playernow==2){
            [p1ground aiturn];
        }
    }
}

- (void)endturn {
    
    if(gamemode2 || playernow == 1) topBoard.acceptingMoves = NO;
    else bottomBoard.acceptingMoves = NO;
    
    int deadship = 0;
    for(int i = 0; i < 5; ++i){
        playground *b = topBoard;
        
        if(gamemode2==false){
            if(playernow==2){
                b=bottomBoard;
            }
        }
        
        battleship *s = [b.ships objectAtIndex:i];
        
        if(s.die) {
            deadship++;
        }
    }
    
    if(deadship == 5){
        winner = playernow;
        p1ground.hidden = YES;
        p2ground.hidden = YES;
        p1ground = nil;
        p2ground = nil;
        topBoard = nil;
        bottomBoard = nil;
        lockbutton.hidden = YES;
        lockbutton = nil;
        turnlabel.hidden = YES;
        turnlabel = nil;
        uplabel.hidden = YES;
        uplabel = nil;
        downlabel.hidden = YES;
        downlabel = nil;
        [self endgame];
        return;
    }
    
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(switchPlayers) userInfo:nil repeats:NO];
}

- (void)endgame {
    
    [self winsound];
    NSString* winnerText;
    if(winner == 1){
        winnerText = @"Player One";
    }else{
        winnerText = @"Player Two";
    }
    
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                    message:[winnerText stringByAppendingString:@" win!"]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    //[self gamemodechoose];
    if(gamemode2==false){
        if(winner==1){
            //NSLog(@"%lld",(moves+1)/2);
            [[gamecentercontrol sharedInstance] reportScore:(moves+1)/2 forLeaderboardID:@"moves_to_win"];
            [self showupload];
        }
    }
    
    
}

-(void) showupload{
    NSString *uploaded=@"uploaded score to Game Center";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uploaded"
                                                    message:uploaded
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)restartgame{
    restart.hidden=YES;
    lockbutton.hidden = YES;
    lockbutton = nil;
    turnlabel.hidden = YES;
    turnlabel = nil;
    uplabel.hidden = YES;
    uplabel = nil;
    downlabel.hidden = YES;
    downlabel = nil;
    p1ground.hidden = YES;
    p2ground.hidden = YES; 
    p1ground = nil;
    p2ground = nil;
    topBoard = nil;
    bottomBoard = nil;
    [self gamemodechoose];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
