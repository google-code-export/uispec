#import "DescribeEmployeeAdmin.h"
#import "UIBug.h"
#import "NSNumberCreator.h"

@implementation DescribeEmployeeAdmin

-(void)beforeAll {
	app = [[UIQuery withApplicationAndDefaultTimeout:10] retain];
	[UIBug bugAtPoint:CGPointMake(0, 465)];
}

-(void)afterAll {
	[app release];
}

-(void)addTestUser {
	app.navigationButton.touch;
	[[app.textField.with placeholder:@"First Name"] setText:@"Brian"];
	[[app.textField placeholder:@"Last Name"] setText:@"Knorr"];
	[[app.textField placeholder:@"Email"] setText:@"b@g.com"];
	[[app.textField placeholder:@"Username*"] setText:@"bkuser"];
	[[app.textField placeholder:@"Password*"] setText:@"test"];
	[[app.textField placeholder:@"Confirm*"] setText:@"test"];
	[[app.navigationButton.label text:@"Save"] touch];
}

-(void)deleteTestUser {
	[[[app.tableView.label text:@"Brian Knorr"] parent].tableViewCell delete];
}

-(void)itShouldShowListOfDefaultUsers {
	[expectThat([app.tableView.label text:@"Larry Stooge"]) should].exist;
	[expectThat([app.tableView.label text:@"Curly's Stooge"]) should].exist;
	[expectThat([app.tableView.label text:@"Moe Stooge"]) should].exist;
	
	UIQuery *tableView = app.tableView;
	int rows = [[tableView dataSource] tableView:tableView numberOfRowsInSection:0];
	[expectThat(rows) should:be(3)];
}

-(void)itShouldNotAddANewUserWithInvalidData {
	app.navigationButton.touch;
	[[app.navigationButton.label text:@"Save"] touch];
	[expectThat(app.alertView) should].exist;
	[[app view:@"UIThreePartButton"] touch];
	[[app view:@"UINavigationItemButtonView"] touch];
}

-(void)itShouldAddAndDeleteAUser {
	[self addTestUser];
	[expectThat([app timeout:1].alertView) should].not.exist;
	[expectThat([app.tableView.label text:@"Brian Knorr"]) should].exist;
	
	[self deleteTestUser];
	[expectThat([[app.tableView.label timeout:1] text:@"Brian Knorr"]) should].not.exist;
}

-(void)itShouldUpdateUserProfile {
	[self addTestUser];
	[[app.label.with text:@"Brian Knorr"] touch];
	
	[[app.textField placeholder:@"First Name"] setText:@"Jake"];
	[[app.textField placeholder:@"Last Name"] setText:@"Dempsey"];
	[[app.navigationButton.label text:@"Save"] touch];
	[expectThat([app timeout:1].alertView) should].not.exist;
	[expectThat([app.tableView.label text:@"Jake Dempsey"]) should].exist;
	[[app.label text:@"Jake Dempsey"] touch];
	[[expectThat([app.textField placeholder:@"First Name"]) should].have text:@"Jake"];
	[[expectThat([app.textField placeholder:@"Last Name"]) should].have text:@"Dempsey"];
	
	[[app.textField placeholder:@"First Name"] setText:@"Brian"];
	[[app.textField placeholder:@"Last Name"] setText:@"Knorr"];
	[[app.navigationButton.label text:@"Save"] touch];
	[self deleteTestUser];
}



//-(void)itShouldGo {
//    $(@"label text:'Curly's Stooge' touch");
//    [[app.label index:1] setText:@"wwwww"];
//    $(@"label index:1 setText:'wowo'");
//    $(@"show");
//    
//    id result;
//    NSString *commandValue = @"windows";
//    NSMethodSignature *signature = [[UIApplication sharedApplication] methodSignatureForSelector:NSSelectorFromString(commandValue)];
//    NSString *returnType = [NSString stringWithFormat:@"%s", [signature methodReturnType]];
//    NSLog(@"**Return Type = %@", returnType);
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//    [invocation setTarget:[UIApplication sharedApplication]];
//    [invocation setSelector:NSSelectorFromString(commandValue)];
//    [invocation invoke];
//
//    
//    
//    unsigned int length = [[invocation methodSignature] methodReturnLength];
//    void *buffer = (void *)malloc(length);
//    [invocation getReturnValue:buffer];
//    result = [NSNumberCreator numberWithValue:buffer objCType:[signature methodReturnType]];
//    
//    NSLog(@"rect = %@",result);
    //$(@"accessibilityFrame");
//}

-(void)itShouldUpdateUserRoles {
	[self addTestUser];
    $(@"label text:'Brian Knorr' touch");
    $(@"label with text:'User Roles' touch");
    
    $(@"tableViewCell all label text:'Returns' parent tableViewCell scrollTo");

	[[app.label text:@"Returns"] touch];
	[app wait:.5];
	[[expectThat([[app.label text:@"Returns"] parent].tableViewCell) should].be selected];
	$(@"label text:'Returns' parent tableViewCell should have accessoryType:%d", UITableViewCellAccessoryCheckmark);
	
	[[app.label text:@"Returns"] touch];
	[[expectThat([[app.label text:@"Returns"] parent].tableViewCell) should].have accessoryType:UITableViewCellAccessoryNone];
	
	[[app view:@"UINavigationItemButtonView"] touch];
	[[app view:@"UINavigationItemButtonView"] touch];
	[self deleteTestUser];
}

@end
