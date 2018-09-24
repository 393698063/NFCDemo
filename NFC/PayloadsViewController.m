//
//  PayloadsViewController.m
//  NFC
//
//  Created by Qiao,Gang(RM) on 2018/9/24.
//  Copyright © 2018年 jorgon. All rights reserved.
//

#import "PayloadsViewController.h"

@interface PayloadsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation PayloadsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI{
    self.navigationItem.title = @"payloads";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paloads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"payload"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payload"];
    }
    NFCNDEFPayload * payload = self.paloads[indexPath.row];
    /*
     @property (nonatomic, assign) NFCTypeNameFormat typeNameFormat;
     @property (nonatomic, copy) NSData *type;
     @property (nonatomic, copy) NSData *identifier;
     @property (nonatomic, copy) NSData *payload;
     */
    
    switch (payload.typeNameFormat) {
        case NFCTypeNameFormatEmpty:
        {
            
            break;
        }
        case NFCTypeNameFormatNFCWellKnown:
        {
            NSString * type = [[NSString alloc] initWithData:payload.type encoding:NSUTF8StringEncoding];
            if (type) {
                cell.textLabel.text = [@"NFC Well Known type:" stringByAppendingString:type];
            }
            else {
                cell.textLabel.text = @"Invalid data";
            }
            break;
        }
        case NFCTypeNameFormatMedia:
        {
            NSString * type = [[NSString alloc] initWithData:payload.type encoding:NSUTF8StringEncoding];
            if (type) {
                cell.textLabel.text = [@"Media type:" stringByAppendingString:type];
            }
            else {
                cell.textLabel.text = @"Invalid data";
            }
            break;
        }
        case NFCTypeNameFormatAbsoluteURI:
        {
            NSString * text = [[NSString alloc] initWithData:payload.payload encoding:NSUTF8StringEncoding];
            if (text) {
                cell.textLabel.text = text;
            }
            else {
                cell.textLabel.text = @"Invalid data";
            }
            break;
        }
        case NFCTypeNameFormatNFCExternal:
        {
            cell.textLabel.text = @"NFC External type";
            break;
        }
        case NFCTypeNameFormatUnknown:
        {
            cell.textLabel.text = @"Unknown type";
            break;
        }
        case NFCTypeNameFormatUnchanged:
        {
            cell.textLabel.text = @"Unchanged type";
            break;
        }
        default:
            cell.textLabel.text = @"Invalid data";
            break;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
