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

#import "OENetplayJoinGameWindowController.h"
#import <OpenEmuSystem/OpenEmuSystem.h>

@interface OENetplayJoinGameWindowController ()

@property NSWindow *activeWindow;

@end

@implementation OENetplayJoinGameWindowController

- (id)init
{
    if(self = [super initWithWindowNibName:@"OENetplayJoinGameWindowController"])
    {
        
    }
    
    return self;
}

- (void)windowDidLoad
{
    [self OE_validateForm];
}

- (OENetplayJoinGameOptions *)options
{
    NSURL *url = [NSURL URLWithString:[[self address] stringValue]];
    BOOL spectate = [[self spectate] state] == NSOnState;
    
    return [OENetplayJoinGameOptions optionsWithURL:url spectate:spectate];
}

- (void)beginSheetModalForWindow:(NSWindow *)window completionHandler:(void (^)(NSModalResponse))handler
{
    [self OE_endSheetWithReturnCode:NSModalResponseCancel];
    
    [self setActiveWindow:window];
    [window beginSheet:[self window] completionHandler:handler];
}

- (IBAction)ok:(id)sender
{
    [self OE_endSheetWithReturnCode:NSModalResponseOK];
}

- (IBAction)cancel:(id)sender
{
    [self OE_endSheetWithReturnCode:NSModalResponseCancel];
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    [self OE_validateForm];
}

- (void)OE_endSheetWithReturnCode:(NSModalResponse)code
{
    if([self activeWindow])
    {
        [[self activeWindow] endSheet:[self window] returnCode:code];
        [self setActiveWindow:nil];
    }
}

- (void)OE_validateForm
{
    if([self okButton] != nil)
    {
        [[self okButton] setEnabled:[self OE_formIsValid]];
    }
}

- (BOOL)OE_formIsValid
{
    return [self options] != nil;
}

@end
