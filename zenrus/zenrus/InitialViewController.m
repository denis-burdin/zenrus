//
//  InitialViewController.m
//  zenrus
//
//  Created by Dennis Burdin on 18.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "InitialViewController.h"
#import "UIStoryboard+Instant.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurateUI {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
