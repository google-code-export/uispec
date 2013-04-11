#import <Foundation/Foundation.h>


@protocol HTTPResponse

- (UInt64)contentLength;

- (UInt64)offset;
- (void)setOffset:(UInt64)offset;

- (NSData *)readDataOfLength:(unsigned int)length;

@end

@interface UISPEC_HTTPFileResponse : NSObject <HTTPResponse>
{
	NSString *filePath;
	NSFileHandle *fileHandle;
}

- (id)initWithFilePath:(NSString *)filePath;
- (NSString *)filePath;

@end

@interface UISPEC_HTTPDataResponse : NSObject <HTTPResponse>
{
	unsigned offset;
	NSData *data;
}

- (id)initWithData:(NSData *)data;

@end
