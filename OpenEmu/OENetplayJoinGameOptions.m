/*
 Copyright (c) 2015, OpenEmu Team
 
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

#import "OENetplayJoinGameOptions.h"
#import "OENetplayHostGameOptions.h"

@implementation OENetplayJoinGameOptions

- (id)initWithHost:(NSString * _Nonnull)host port:(uint16_t)port spectate:(BOOL)spectate
{
    if(self = [super init])
    {
        _host = host;
        _port = port;
        _spectate = spectate;
    }
    
    return self;
}

+ (OENetplayJoinGameOptions * _Nullable)optionsWithURL:(NSURL * _Nullable)url spectate:(BOOL)spectate
{
    NSString *host = nil;
    if(url != nil)
    {
        // NOTE: [[NSURL URLWithString:@"192.168.1.1"] host] is nil, and [[NSURL URLWithString:@"http://192.168.1.1"] pathComponents] is empty
        if([url host] != nil)
        {
            host = [url host];
        }
        else if([url pathComponents] != nil && [[url pathComponents] count] >= 1)
        {
            host = [[url pathComponents] objectAtIndex:0];
        }
    }
    
    if(host == nil)
    {
        return nil;
    }
    
    
    
    uint16_t port = 0;
    if([url port] != nil)
    {
        port = [[url port] unsignedShortValue];
    }
    
    if(port == 0)
    {
        port = OENetplayDefaultPort;
    }
    
    return [[OENetplayJoinGameOptions alloc] initWithHost:host port:port spectate:spectate];
}

@end
