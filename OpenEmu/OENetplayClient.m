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

#import "OENetplayClient.h"
#import "OENetplayJoinGameOptions.h"
#import "OENetplayConnection.h"
#import "GCDAsyncSocket.h"

@interface  OENetplayClient () <GCDAsyncSocketDelegate>

@property GCDAsyncSocket *socket;

@end

@implementation OENetplayClient

- (BOOL)OE_setupSocketWithOptions:(OENetplayJoinGameOptions *)options
{
    NSError *error = nil;
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSLog(@"Trying to connect to host...");
    [socket connectToHost:[options host] onPort:[options port] error:&error];
    if(error != nil)
    {
        NSLog(@"Failed to connect!");
        return NO;
    }
    
    
    NSData *data = [@"Ping!" dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:data withTimeout:5.0 tag:0];
    
    [self setSocket:socket];
    return YES;
}

+ (OENetplayClient *)clientWithOptions:(OENetplayJoinGameOptions *)options
{
    OENetplayClient *client = [[OENetplayClient alloc] init];
    if([client OE_setupSocketWithOptions:options])
    {
        return client;
    }
    else
    {
        return nil;
    }
}



- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Connected to host: %@", host);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"Sent data");
    [sock readDataToLength:5 withTimeout:5.0 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Recieved: %@", string);
}

@end
