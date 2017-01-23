//
//  ExchangeRatesViewController.m
//  zenrus
//
//  Created by Dennis Burdin on 20.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "ExchangeRatesViewController.h"
#import "WebServiceWrapper.h"

static NSString *const kCBR = @"Центробанк";
static NSString *const kWebServiceURL = @"http://www.cbr.ru/scripts/XML_daily.asp";

@interface ExchangeRatesViewController ()

@end

@implementation ExchangeRatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WebServiceWrapper *webService = [[WebServiceWrapper alloc] initWithURLString:kWebServiceURL];
    [webService test];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configurateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurateUI {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationItem setHidesBackButton:NO animated:NO];
    self.navigationItem.title = kCBR;
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
