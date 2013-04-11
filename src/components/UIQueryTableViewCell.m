
#import "UIQueryTableViewCell.h"
#import "UIQueryAll.h"
#import <objc/runtime.h>

static char indexKey;
static char tableKey;

@implementation UIQueryTableViewCell

+(void)associateIndexPath:(UITableViewCell *)tableViewCell indexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(tableViewCell, &indexKey, indexPath, OBJC_ASSOCIATION_RETAIN);
}

+(void)associateTableView:(UITableViewCell *)tableViewCell tableView:(UITableView *)tableView {
    objc_setAssociatedObject(tableViewCell, &tableKey, tableView, OBJC_ASSOCIATION_RETAIN);
}

-(UIQuery *)all {
    UITableView *table = (UITableView *)[[views objectAtIndex:0] superview];
    //NSLog(@"TABLE=%@",table);
	NSMutableArray *tableViewCells = [NSMutableArray array];
	int numberOfSections = [table numberOfSections];
	for(int i=0; i< numberOfSections; i++) {
		int numberOfRowsInSection = [table numberOfRowsInSection:i];
		for(int j=0; j< numberOfRowsInSection; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            UITableViewCell *cell = [[table dataSource] tableView:table cellForRowAtIndexPath:indexPath];
			[tableViewCells addObject:cell];
            [UIQueryTableViewCell associateIndexPath:cell indexPath:indexPath];
            [UIQueryTableViewCell associateTableView:cell tableView:table];
		}
	}
	//NSLog(@"!!!tableViewCells size = %d", tableViewCells.count);
	return [UIQueryAll withViews:tableViewCells className:className];
}

-(UIQuery *)delete {
	UITableView *tableView = self.parent.tableView;
	[tableView.dataSource tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[tableView indexPathForCell:[self.views objectAtIndex:0]]];
    return [UIQuery withViews:views className:className];
}

-(UIQuery *)scrollTo {
    UITableViewCell *cell = [[self targetViews] objectAtIndex:0];
    NSIndexPath *indexPath = objc_getAssociatedObject(cell, &indexKey);
    UITableView *table = objc_getAssociatedObject(cell, &tableKey);
    //NSLog(@"cell=%@ and index = %@ and table=%@", cell, indexPath, table);
    if (indexPath && table) {
        [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        table = self.parent.tableView;
        [table scrollToRowAtIndexPath:[table indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return [UIQuery withViews:views className:className];
}

@end
