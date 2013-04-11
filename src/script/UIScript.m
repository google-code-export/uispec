#import "UIScript.h"
#import "UISPEC_HTTPServer.h"
#import "HTTPResponse.h"
#import "UISPEC_SBJson.h"
#import "NSNumberCreator.h"

@implementation UIScript

static int timeout = -1;

+(void)runOnPort:(UInt16)port {
    [[[UIScript alloc] initOnPort:port] autorelease];
}

+(void)runOnPort:(UInt16)port defaultTimeout:(int)_timeout {
    timeout = _timeout;
    [UIScript runOnPort:port];
}

-(id)initOnPort:(UInt16)port {
	if (self = [super init]) {
        httpServer = [[[UISPEC_HTTPServer alloc] init] retain];
        [httpServer setName:@"UIScript"];
        [httpServer setType:@"_http._tcp."];
        [httpServer setPort:port];
        [httpServer setConnectionClass:[UIScript class]];
        NSError *error;
        if([httpServer start:&error]) {
            //NSLog(@"Yeah Started HTTP Server on port %hu", [httpServer port]);
        } else {
            NSLog(@"Error starting HTTP Server: %@", error);
        }
	}
	return self;
}

- (NSDictionary *)parseGetParams {
    NSDictionary *result = nil;
	
	NSURL *url = [(NSURL *)CFHTTPMessageCopyRequestURL(request) autorelease];
	if(url)
	{
		NSString *query = [url query];
		if (query)
		{
			result = [self parseParams:query];
		}
	}
	
	return result;
}

- (NSDictionary *)parseParams:(NSString *)query
{
	NSArray *components = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[components count]];
	
	NSUInteger i;
	for (i = 0; i < [components count]; i++)
	{
		NSString *component = [components objectAtIndex:i];
		if ([component length] > 0)
		{
			NSRange range = [component rangeOfString:@"="];
			if (range.location != NSNotFound)
			{
				NSString *escapedKey = [component substringToIndex:(range.location + 0)];
				NSString *escapedValue = [component substringFromIndex:(range.location + 1)];
				
				if ([escapedKey length] > 0)
				{
					CFStringRef k, v;
					
					k = CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)escapedKey, CFSTR(""));
					v = CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)escapedValue, CFSTR(""));
					
					NSString *key, *value;
					
					key   = (NSString *)k;
					value = (NSString *)v;
					
					if (key)
					{
						if (value)
							[result setObject:value forKey:key];
						else
							[result setObject:[NSNull null] forKey:key];
					}
				}
			}
		}
	}
	
	return result;
}

- (NSObject<HTTPResponse> *)httpResponseForURI:(NSString *)path {
    NSDictionary *params = [self parseGetParams];
    //NSLog(@"params:%@",params);
    NSString *scriptParam = [params objectForKey:@"$"];
    if (!scriptParam) {
        return [[[UISPEC_HTTPDataResponse alloc] initWithData:[@" " dataUsingEncoding:NSUTF8StringEncoding]] retain];
    }
    NSMutableString *script = [NSMutableString stringWithString:scriptParam];
    NSString *result = @"";
    NSException *error = nil;
    if (script) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:script forKey:@"script"];
        [self performSelectorOnMainThread:@selector(execute:) withObject:params waitUntilDone:YES];
        result = [params objectForKey:@"result"];
        error = [params objectForKey:@"error"];
    }
    if (result==nil) {
        result = @"";
    }
    //NSLog(@"result=%@",result);
	NSMutableDictionary *response = [NSMutableDictionary dictionaryWithObject:result forKey:@"result"];
    if (error != nil) {
        [response setObject:[error reason] forKey:@"error"];
    }
    NSString *json = [response JSONRepresentation];
    if (!json) {
        [response setObject:[NSString stringWithFormat:@"%@",result] forKey:@"result"];
        json = [response JSONRepresentation];
    }
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    //[NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSObject<HTTPResponse> *dataReponse = [[[UISPEC_HTTPDataResponse alloc] initWithData:data] retain];
    return dataReponse;
}

-(void)execute:(NSMutableDictionary *)params {
    NSMutableString *script = [params objectForKey:@"script"];
   //NSLog(@"timeout = %d", timeout);
    id result;
    @try {
        result = $(script);
    } @catch (NSException *exception) {
        return [params setObject:exception forKey:@"error"];
    }
    if (result==nil) {
        result = @"";
    }
    
    [params setObject:result forKey:@"result"];
}

UIQuery * $(NSMutableString *script, ...) {
	va_list args;
	va_start(args, script);
	script = [[NSMutableString alloc] initWithFormat:script arguments:args];
	va_end(args);
	
    id result;
	if (timeout<0) {
        result = [UIQuery withApplication];
    } else {
        result = [UIQuery withApplicationAndDefaultTimeout:timeout];
    }
    //NSLog(@"Starting result = %@", result);
	//NSLog(@"script = %@, length = %d", script, script.length);
    NSMutableArray *strings = [NSMutableArray array];
    
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"'([^:]+)'" options:0 error:&error];
    NSArray* matches = [regex matchesInString:script options:0 range:NSMakeRange(0, [script length])];
    //NSLog(@"matches count=%d",matches.count);
    if (matches.count>0) {
        for (NSTextCheckingResult* match in matches) {
            NSRange range = [match range];
            NSString* matchText = [script substringWithRange:NSMakeRange(range.location+1,range.length-2)];
            //NSLog(@"match = %@", matchText);
            [strings addObject:matchText];
        }
        for (NSString *string in strings) {
            [script replaceOccurrencesOfString:[NSString stringWithFormat:@"'%@'",string] withString:@"BIGFATGUYWITHPIGFEET" options:NSLiteralSearch range:NSMakeRange(0, [script length])];
            //NSLog(@"script=%@",script);
        }
    }

//	NSArray *stringParams = [script componentsSeparatedByString:@"'"];
//	//NSLog(@"stringParams = %@", stringParams);
//	if (stringParams.count > 1) {
//		for (int i=1; i<stringParams.count; i=i+2) {
//			[strings addObject:[stringParams objectAtIndex:i]];
//			[script replaceOccurrencesOfString:[NSString stringWithFormat:@"'%@'", [stringParams objectAtIndex:i]] withString:@"BIGFATGUYWITHPIGFEET" options:NSLiteralSearch range:NSMakeRange(0, [script length])];
//		}
//	}
    //	NSLog(@"script = %@", script);
    //	NSLog(@"strings = %@", strings);
	
	NSArray *commands = [script componentsSeparatedByString:@" "];
	//NSLog(@"commands = %@", commands);
	
	int stringCount = 0;
    int counter = 0;
	for (NSString *command in commands) {
		NSArray *commandAndParam = [command componentsSeparatedByString:@":"];
		NSString *commandValue = [commandAndParam objectAtIndex:0];
		//NSLog(@"commandValue = %@", commandValue);
		NSString *param = nil;
		if (commandAndParam.count > 1) {
			param = [commandAndParam objectAtIndex:1];
		}
        if (counter == commands.count-1) {
            //NSLog(@"doing last");
            SEL commandValueSelector = NSSelectorFromString(commandValue);
            if (param !=nil) {
                commandValueSelector = NSSelectorFromString([NSString stringWithFormat:@"%@:", commandValue]);
            }
            //NSLog(@"commandValueSelector = %@", NSStringFromSelector(commandValueSelector));
            if (param==nil) {
                id target = [[result targetViews] objectAtIndex:0];
                if ([target respondsToSelector:commandValueSelector]) {
                    result = target;
                }
            }
            NSMethodSignature *signature = [result methodSignatureForSelector:commandValueSelector];
            if (signature==nil) {
                [NSException raise:nil format:@"Unrecognized selector sent to instance."];
                return result;
            }
            NSString *returnType = [NSString stringWithFormat:@"%s", [signature methodReturnType]];
            //NSLog(@"** UISCript Return Type = %@", returnType);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:result];
            [invocation setSelector:commandValueSelector];
            
            if (param != nil) {
                id *paramValue = nil;
                if ([param isEqualToString:@"BIGFATGUYWITHPIGFEET"]) {
                    paramValue = [strings objectAtIndex:stringCount];
                    stringCount++;
                    //NSLog(@"paramValue = %@", paramValue);
                } else if ([param isEqualToString:@"YES"] || [param isEqualToString:@"NO"]) {
                    paramValue = [param isEqualToString:@"YES"];
                    //NSLog(@"paramValue = %d", paramValue);
                } else {
                    paramValue = [param intValue];
                    //NSLog(@"paramValue = %d", paramValue);
                }
                [invocation setArgument:&paramValue atIndex:2];
            }
            [invocation invoke];
            if ([returnType isEqualToString:@"v"]) {
                result = @"";
            } else {
                unsigned int length = [[invocation methodSignature] methodReturnLength];
                void *buffer = (void *)malloc(length);
                [invocation getReturnValue:buffer];
                result = [[NSNumberCreator numberWithValue:buffer objCType:[signature methodReturnType]] retain];
                if ([returnType isEqualToString:@"@"]) {
                    if ([result isKindOfClass:[UIRedoer class]]) {
                        result = [result target];
                    }
                }
            }
        } else if (param != nil) {
			id paramValue = nil;
			if ([param isEqualToString:@"BIGFATGUYWITHPIGFEET"]) {
				paramValue = [strings objectAtIndex:stringCount];
				stringCount++;
                //NSLog(@"paramValue = %@", paramValue);
			} else if ([param isEqualToString:@"YES"] || [param isEqualToString:@"NO"]) {
				paramValue = [param isEqualToString:@"YES"];
                //NSLog(@"paramValue = %d", paramValue);
			} else {
				paramValue = [param intValue];
                //NSLog(@"paramValue = %d", paramValue);
			}
			result = [result performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:", commandValue]) withObject:paramValue];
		} else {
            result = [result performSelector:NSSelectorFromString(commandValue)];
		}
        //NSLog(@"result = %@", result);
        counter++;
	}
	return result;
}

@end


