#import "DescribeWebView.h"
#import "UIExpectation.h"

@implementation DescribeWebView


-(void)beforeAll {
	[super beforeAll];
	[[app.label.with text:@"Web"] flash].touch;
	[app wait: 2];
}

-(void)afterAll {
	[super afterAll];
	[[app.navigationItemButtonView flash] touch];
}

-(void)itShouldSearchGoogle {
//    NSLog(@"hello = %@", $(@"webView dom"));
//    $(@"wait:10");
//    $(@"webView evalJS:'"
//      "var input = document.getElementsByName(\"q\")[0];"
//      "input.value=\"UISpec\";"
//      "input.focus();"
//    "'");
//    $(@"wait:3");
//    $(@"webView evalJS:'"
//      "var element = document.getElementsByName(\"btnG\")[0];"
//      "var myEvent = document.createEvent (\"MouseEvent\");"
//      "myEvent.initMouseEvent(\"click\", true, true,window, 1, 1, 1, 1, 1, false, false, false, false, 0, element);"
//      "element.dispatchEvent(myEvent);"
//    "'");
//    $(@"wait:2");
}

@end
