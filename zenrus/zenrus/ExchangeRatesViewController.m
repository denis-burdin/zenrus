//
//  ExchangeRatesViewController.m
//  zenrus
//
//  Created by Dennis Burdin on 20.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "ExchangeRatesViewController.h"
#import "WebServiceWrapper.h"
#import "RatesCell.h"
#import "UIScrollView+SVPullToRefresh.h"

static NSString *const kCBR = @"Центробанк";
static NSString *const kWebServiceURL = @"http://www.cbr.ru/scripts/XML_daily.asp";

@interface ExchangeRatesViewController ()
{
    NSString* lastDate;
    NSString* lastUSValue; // TODO: store it into NSArray
    NSString* lastEuroValue;
    WebServiceWrapper *_webService;
}

@property (weak, nonatomic) IBOutlet UITableView *tableRates;

@end

@implementation ExchangeRatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webService = [[WebServiceWrapper alloc] initWithURLString:kWebServiceURL];
    __weak typeof(self) weakSelf = self;
    
    [_webService run:^(NSArray *result) {
        [weakSelf updateTableView:result];
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableRates.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_tableRates setBackgroundColor:[UIColor clearColor]];
    [_tableRates addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    [self registerCells];

}

- (void)refreshData {
    __weak typeof(self) weakSelf = self;
    [_webService run:^(NSArray *result) {
        [weakSelf updateTableView:result];
        [_tableRates.pullToRefreshView stopAnimating];
    }];
}

-(void)updateTableView:(NSArray*)result {
    self->lastDate = [result objectAtIndex:CurrencyIndexDate];
    self->lastUSValue = [result objectAtIndex:CurrencyIndexUSDollarValue];
    self->lastEuroValue = [result objectAtIndex:CurrencyIndexEuroValue];
    [self.tableRates reloadData];
}

- (void)registerCells
{
    [self.tableRates registerNib:[UINib nibWithNibName:@"RatesCell" bundle:nil]
         forCellReuseIdentifier:@"RatesCell"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self->lastDate;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.contentView.backgroundColor = [UIColor clearColor];
    view.tintColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RatesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RatesCell" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        [cell.lblCurrency setText:@"USD/RUB"];
        [cell.lblValue setText:self->lastUSValue];
    } else if (indexPath.row == 1) {
        [cell.lblCurrency setText:@"EUR/RUB"];
        [cell.lblValue setText:self->lastEuroValue];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];

    return cell;
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
