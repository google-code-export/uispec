#import "UIQueryWebView.h"
#import "UISPEC_SBJson.h"

@implementation UIQueryWebView


-(NSString *) evalJS:(NSString *)script {
    return [[[self targetViews] objectAtIndex:0] stringByEvaluatingJavaScriptFromString:script];
}

-(void) forceJQuery {
    if ([@"undefined" isEqualToString:[self evalJS:@"typeof jQuery"]]) {
        NSLog(@"jquery undefined");
        [self evalJS:@"var head = document.getElementsByTagName('head')[0];\
         var script = document.createElement('script');\
         script.src = 'http://code.jquery.com/jquery-1.8.0.min.js';\
         script.type = 'text/javascript';\
         head.appendChild(script);"];
    }
    NSDate *start = [NSDate date];
	while ([start timeIntervalSinceNow] > (0 - [self timeout])) {
        NSString *jquery = [self evalJS:@"typeof jQuery"];
        NSLog(@"jquery is %@",jquery);
        if ([@"function" isEqualToString:jquery]) {
            break;
        }
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, false);
    }
}

-(id) dom {
    return [[self evalJS:@"\
        function htmlTree(obj, object){\
             var tagName = obj.tagName;\
             object.tagName = tagName;\
             object.id = obj.id;\
             object.className = obj.className;\
             object.type = obj.type;\
             object.value = obj.value;\
             object.text = obj.text;\
             object.name = obj.name;\
             object.checked = obj.checked;\
             object.offsetWidth = obj.offsetWidth;\
             object.offsetHeight = obj.offsetHeight;\
             object.offsetTop = obj.offsetTop;\
             object.offsetLeft = obj.offsetLeft;\
             if (['HTML','BODY','HEAD'].indexOf(tagName.toUpperCase())===-1) {\
                 object.innerText = obj.innerText;\
             }\
             object.children = [];\
             if (tagName.toUpperCase() === 'IFRAME' || tagName.toUpperCase() === 'FRAME') {\
                 obj = obj.contentDocument;\
             }\
             if (obj && obj.hasChildNodes()) {\
                 var child = obj.firstChild;\
                 while (child) {\
                     if (child.nodeType === 1 && child.nodeName !== 'SCRIPT' && child.nodeName !== 'STYLE') {\
                         var o = {};\
                         object.children.push(o);\
                         htmlTree(child, o);\
                     }\
                     child = child.nextSibling;\
                 }\
             }\
        }\
        var uispecResult = {};\
        htmlTree(document.getElementsByTagName('body')[0],uispecResult);\
        JSON.stringify(uispecResult);\
    "] JSONValue];
}

@end
