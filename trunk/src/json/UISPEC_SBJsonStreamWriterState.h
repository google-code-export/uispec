/*
 Copyright (c) 2010, Stig Brautaset.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
   Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
  
   Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 
   Neither the name of the the author nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

@class UISPEC_SBJsonStreamWriter;

@interface UISPEC_SBJsonStreamWriterState : NSObject
+ (id)sharedInstance;
- (BOOL)isInvalidState:(UISPEC_SBJsonStreamWriter*)writer;
- (void)appendSeparator:(UISPEC_SBJsonStreamWriter*)writer;
- (BOOL)expectingKey:(UISPEC_SBJsonStreamWriter*)writer;
- (void)transitionState:(UISPEC_SBJsonStreamWriter*)writer;
- (void)appendWhitespace:(UISPEC_SBJsonStreamWriter*)writer;
@end

@interface UISPEC_SBJsonStreamWriterStateObjectStart : UISPEC_SBJsonStreamWriterState
@end

@interface UISPEC_SBJsonStreamWriterStateObjectKey : UISPEC_SBJsonStreamWriterStateObjectStart
@end

@interface UISPEC_SBJsonStreamWriterStateObjectValue : UISPEC_SBJsonStreamWriterState
@end

@interface UISPEC_SBJsonStreamWriterStateArrayStart : UISPEC_SBJsonStreamWriterState
@end

@interface UISPEC_SBJsonStreamWriterStateArrayValue : UISPEC_SBJsonStreamWriterState
@end

@interface UISPEC_SBJsonStreamWriterStateStart : UISPEC_SBJsonStreamWriterState
@end

@interface UISPEC_SBJsonStreamWriterStateComplete : UISPEC_SBJsonStreamWriterState
@end

@interface UISPEC_SBJsonStreamWriterStateError : UISPEC_SBJsonStreamWriterState
@end

