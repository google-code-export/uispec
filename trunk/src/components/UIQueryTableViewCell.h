//
//  UIQueryTableViewCell.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

#import "UIQuery.h"

@interface UIQueryTableViewCell : UIQuery {
    UITableView *parentTable;
}

+(void)associateIndexPath:(UITableViewCell *)tableViewCell indexPath:(NSIndexPath *)indexPath;
+(void)associateTableView:(UITableViewCell *)tableViewCell tableView:(UITableView *)tableView;
-(UIQuery *)delete;
-(UIQuery *)scrollTo;

@end
