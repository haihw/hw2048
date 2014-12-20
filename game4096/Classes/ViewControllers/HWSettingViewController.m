//
//  HWSettingViewController.m
//  game4096
//
//  Created by Hai Hw on 6/12/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWSettingViewController.h"
#import "MBProgressHUD.h"
#import "HWGameSetting.h"
#import <StoreKit/StoreKit.h>
@interface HWSettingViewController () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSArray *products;
}
@end

@implementation HWSettingViewController
+(id)SharedInstance {
    static dispatch_once_t pred;
    static HWSettingViewController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[HWSettingViewController alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:shared];
    });
    return shared;
}
#pragma mark - Sharekit
// Custom method
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Validating...";
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    products = response.products;
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
        NSLog(@"Invalid: %@", invalidIdentifier);
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - actions
- (IBAction)btnCloseTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnRateTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%d", kAppStoreID]]];
}

- (IBAction)btnRemoveAdTapped:(id)sender {
    SKProduct *product = products.firstObject;
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction)switchSoundChanged:(id)sender {
    [HWGameSetting SharedSetting].isSoundEnabled = [(UISwitch *)sender isOn];
}

- (IBAction)btnRestorePurchaseTapped:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self validateProductIdentifiers:@[kInAppPurchaseRemoveAdProductID]];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_switchSoundOption setOn: [HWGameSetting SharedSetting].isSoundEnabled];

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
- (void)showAlertTitle:(NSString *)title message:(NSString *)message delegate: (id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}
- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
//                [self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred:
//                [self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed:
                ;
                [self showAlertTitle:@"Transaction failed" message:[NSString stringWithFormat:@"%@, please try again later", transaction.error.localizedDescription] delegate:nil];
                break;
            case SKPaymentTransactionStatePurchased:
                break;
            case SKPaymentTransactionStateRestored:
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}
@end
