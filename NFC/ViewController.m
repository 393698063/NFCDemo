//
//  ViewController.m
//  NFC
//
//  Created by Qiao,Gang(RM) on 2018/9/22.
//  Copyright © 2018年 jorgon. All rights reserved.
//

#import "ViewController.h"
#import <CoreNFC/CoreNFC.h>

@interface ViewController ()<NFCNDEFReaderSessionDelegate,
UITableViewDelegate,
UITableViewDataSource,
NFCReaderSessionDelegate>
@property (nonatomic, strong) NFCNDEFReaderSession * nfcSession;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray <NFCNDEFMessage *> * messages;
@end

@implementation ViewController
/*
 Background tag reading doesn't support custom URL schemes. Use universal links instead.
 
 
 nfc不可用的几种状况
 
 The device has never been unlocked.
 A Core NFC reader session is in progress.
 Apple Pay Wallet is in use.
 The camera is in use.
 Airplane mode is enabled
 
 /////
 苹果x之前的设备不支持后台扫描
 iPhone X and earlier devices don’t support background tag reading.
 
 
 //Handle an Invalid Reader Session
 The phone successfully read an NFC tag with a reader session configured to invalidate the session after reading the first tag. The error code is NFCReaderSessionInvalidationErrorFirstNDEFTagRead.
 The user canceled the session or the app called invalidateSession to terminate the session. The error code is NFCReaderSessionInvalidationErrorUserCanceled.
 An error occurred during the reader session. See NFCReaderError for the complete list of error codes.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUI];
}

- (void)setUI{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 60, 40);
    [button setTitle:@"扫描" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startReading) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.title = @"主界面";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
}

- (void)startReading{
    if (@available(iOS 11.0, *)) {
        if (!_nfcSession) {
            _nfcSession = [[NFCNDEFReaderSession alloc] initWithDelegate:self
                                                                   queue:nil
                                                invalidateAfterFirstRead:YES];
        }
       
            _nfcSession.alertMessage = @"请靠近要扫描的物体";
            
            [_nfcSession beginSession];
        
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - NFCNDEFReaderSessionDelegate
- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages{
    [self.messages addObjectsFromArray:messages];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error{
//   NFCReaderError
    if (error.code != NFCReaderSessionInvalidationErrorFirstNDEFTagRead &&
        error.code != NFCReaderSessionInvalidationErrorUserCanceled) {
        UIAlertController * controller= [UIAlertController alertControllerWithTitle:@"有错啦" message:@"处理下" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:action];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    [self.nfcSession invalidateSession];
    self.nfcSession = nil;
}

#pragma mark - NFCReaderSessionDelegate
- (void)readerSessionDidBecomeActive:(NFCReaderSession *)session {
    
}

- (void)readerSession:(NFCReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCTag>> *)tags{
    
}



#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
    }
    NFCNDEFMessage * message = self.messages[indexPath.row];
    NSString * unit = message.records.count == 1 ? @" Payload" : @" Payloads";
    cell.textLabel.text = [NSString stringWithFormat:@"%d%@",message.records.count,unit];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSMutableArray<NFCNDEFMessage *> *)messages{
    if (!_messages) {
        _messages = [NSMutableArray arrayWithCapacity:1];
    }
    return _messages;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
