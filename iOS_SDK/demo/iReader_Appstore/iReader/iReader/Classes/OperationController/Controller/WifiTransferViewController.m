//
//  WifiTransferViewController.m
//  iReader
//
//  Created by Jermy on 2019/3/1.
//  Copyright © 2019 ft. All rights reserved.
//

#import "WifiTransferViewController.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "Tools.h"

@interface WifiTransferViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HTTPServer *httpServer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *IPTF;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation WifiTransferViewController
{
    NSArray *_fileList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fileList = [NSArray array];
    //
    self.httpServer = [[HTTPServer alloc] init];
    //
    [self.httpServer setType:@"_http._tcp."];
    //
    NSString *webPath = [[NSBundle mainBundle] resourcePath];
    /*
     *
     *
     */
    [self.httpServer setDocumentRoot:webPath];
    // 
    [self.httpServer setConnectionClass:[MyHTTPConnection class]];
    NSError *err;
    if ([self.httpServer start:&err]) {
        NSString *ipString = [[Tools shareTools] getIPAddress];
        NSUInteger port = [self.httpServer listeningPort];
        NSString *ip = [NSString stringWithFormat:@"%@:%lu", ipString, (unsigned long)port];
        self.IPTF.text = ip;
    }else{
        [[Tools shareTools] showError:err.description];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginWithFile:) name:@"beginWithFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deliverEnd) name:@"deliverEnd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveData:) name:@"didReceiveData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endReceiveFromFile:) name:@"endReceiveFromFile" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    _fileList = [[Tools shareTools] getAPDU];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)beginWithFile:(NSNotification *)notify {
    NSString *file = notify.object;
    [self showMsg:[NSString stringWithFormat:@"receive file: %@", file]];
}

- (void)deliverEnd {
    [self showMsg:@"reveive done!!!\n"];
    
    _fileList = [[Tools shareTools] getAPDU];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didReceiveData:(NSNotification *)notify {
    NSDictionary *dic = notify.object;
    NSData *data = dic[@"data"];
    [self showMsg:[NSString stringWithFormat:@"receive data length: %zd", data.length]];
}

- (void)endReceiveFromFile:(NSNotification *)notify {
    NSString *file = notify.object;
    [self showMsg:[NSString stringWithFormat:@"finish receive file: %@", file]];
}

- (void)showMsg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = self.textView.text;
        self.textView.text = [NSString stringWithFormat:@"%@\n%@", str, msg];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fileList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = _fileList[0];
    return cell;
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"beginWithFile" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deliverEnd" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didReceiveData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"endReceiveFromFile" object:nil];
    
}
@end
