//
//  RatesCell.h
//  zenrus
//
//  Created by Dennis Burdin on 23.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCurrency;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

@end
