
#import "UISpec.h"
#import "UIScript.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    [UIScript runOnPort:12345];
	[UISpec runSpecsAfterDelay:3];
    //[UISpec runSpec:@"DescribeEmployeeAdmin" example:@"itShouldGo" afterDelay:2];
	
    
	int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
