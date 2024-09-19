//
//  DeviceInfoTableViewController.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface DeviceInfoTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy)NSString *readerName;
@property (nonatomic, assign)FTReaderType readerType;
@property (nonatomic, strong)UITableView * myTableView;
@end
