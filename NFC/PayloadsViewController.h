//
//  PayloadsViewController.h
//  NFC
//
//  Created by Qiao,Gang(RM) on 2018/9/24.
//  Copyright © 2018年 jorgon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreNFC/CoreNFC.h>

@interface PayloadsViewController : UIViewController
@property (nonatomic, strong) NSArray <NFCNDEFPayload *> * paloads;
@end
