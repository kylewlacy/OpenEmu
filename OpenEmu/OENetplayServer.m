/*
 Copyright (c) 2016, OpenEmu Team
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the OpenEmu Team nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OENetplayServer.h"
#import "OENetplayHostGameOptions.h"
#import "OENetplayConnection.h"
#import "GCDAsyncSocket.h"

@interface OENetplayServer () <GCDAsyncSocketDelegate>

@property GCDAsyncSocket *socket;

@end

@implementation OENetplayServer

- (BOOL)OE_setupSocketWithOptions:(OENetplayHostGameOptions*)options
{
    NSError *error = nil;
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSLog(@"Trying to host server...");
    [socket acceptOnPort:[options port] error:&error];
    if(error != nil)
    {
        NSLog(@"Failed to host server!");
        return NO;
    }
    
    NSLog(@"Server running on port %d", [options port]);
    
    [self setSocket:socket];
    return YES;
}

+ (OENetplayServer*)serverWithOptions:(OENetplayHostGameOptions*)options
{
    OENetplayServer *server = [[OENetplayServer alloc] init];
    if([server OE_setupSocketWithOptions:options])
    {
        return server;
    }
    else
    {
        return nil;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"Accepted connection: %@", [newSocket connectedHost]);
    [newSocket readDataToLength:5 withTimeout:5.0 tag:2];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received: %@", string);
    
    NSData *reply = [@"Pong!" dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:reply withTimeout:5.0 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"Sent data");
}

@end
