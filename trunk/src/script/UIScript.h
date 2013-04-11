#import "UIQuery.h"
#import "UISPEC_HTTPConnection.h"
#import "UISPEC_HTTPServer.h"

UIQuery * $(NSMutableString *script, ...);

@interface UIScript : UISPEC_HTTPConnection {
    UISPEC_HTTPServer *httpServer;
}

+(void)runOnPort:(UInt16)port;
+(void)runOnPort:(UInt16)port defaultTimeout:(int)timeout;

@end
