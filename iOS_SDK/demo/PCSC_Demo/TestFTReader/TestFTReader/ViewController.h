//
//  ViewController.h
//  TestFTReader
//
//  Created by 洪捷 on 2019/11/5.
//  Copyright © 2019 洪捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDK/include/ReaderInterface.h"

@interface ViewController : UIViewController<ReaderInterfaceDelegate>
{
//    ReaderInterface *interface;
    SCARDCONTEXT ContxtHandle;
    SCARDHANDLE CardHandle;
    int retry_count;
}

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *retry_button;
@property (strong, nonatomic) ReaderInterface *interface;
//@property (assign) SCARDCONTEXT ContxtHandle;
//@property (assign) SCARDHANDLE CardHandle;

@end

