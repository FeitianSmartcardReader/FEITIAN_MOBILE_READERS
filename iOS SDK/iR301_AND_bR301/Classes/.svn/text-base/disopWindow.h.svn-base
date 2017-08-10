//
//  disopWindow.h
//  call_lib
//
//  Created by test on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "winscard.h"

#import "ReaderInterface.h"

@interface disopWindow : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,ReaderInterfaceDelegate>{
    
    IBOutlet UIButton* dropList;
    IBOutlet UIButton* infoBut;
    IBOutlet UISwitch *cardState;
    
	IBOutlet UITextField *commandText;    
    IBOutlet UITextView *ATR_Label;
    IBOutlet UITextView *disTextView;
    
    IBOutlet UILabel* APDU_Label;
    IBOutlet UILabel* cardState_Latel;
    
    IBOutlet UIImageView *disResp;
    IBOutlet UIImageView *apduInput;
    
    SCARDHANDLE  gCardHandle;

    UIView *showInfoView;
    UIView *clearView;

}
@property (nonatomic, readonly) ReaderInterface *readInf;
-(IBAction) showInfo;
-(IBAction) powerOnFun:(id)sender;
-(IBAction) powerOffFun:(id)sender;
-(IBAction) sendCommandFun:(id)sender;
-(IBAction) textFieldDone:(id)sender; 

-(IBAction) limitCharacter:(id)sender;
-(IBAction)runBtnPressed:(id)sender;
-(void) moveToDown;


@property (nonatomic, retain) IBOutlet UIButton *powerOn;
@property (nonatomic, retain) IBOutlet UIButton *powerOff;
@property (nonatomic, retain) IBOutlet UIButton *sendCommand;


@property (nonatomic, retain) IBOutlet UIButton *getSerialNo;
@property (nonatomic, retain) IBOutlet UIButton *getCardState;
@property (nonatomic, retain) IBOutlet UIButton *writeFlash;
@property (nonatomic, retain) IBOutlet UIButton *readFlash;


@property (nonatomic,retain) UIButton* runCommand;
@property (nonatomic,retain) NSArray* listData;
@property (nonatomic,retain) NSArray* showInfoData;

@end
