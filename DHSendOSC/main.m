//
//  main.m
//  DHSendOSC
//
//  Created by Douglas Heriot on 23/01/13.
//  Copyright (c) 2013 Douglas Heriot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "F53OSC.h"

#include <getopt.h>

enum OPTION
{
	O_VERSION			= 'V',
	O_HELP				= 'h',
	
	O_PORT				= 'p',
	O_SERVER			= 's',
};

void printVersion(void);
void printHelp(void);

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		F53OSCClient *client = [F53OSCClient new];
		
		NSMutableString *commandString = [NSMutableString string];
		
		for(NSUInteger i = 1; i < argc; ++i)
		{
			if(i != 1)
				[commandString appendString:@" "];
			
			NSString *currentArg = [NSString stringWithUTF8String:argv[i]];
			
			if([currentArg rangeOfString:@" "].location == NSNotFound)
				// Add normally
				[commandString appendString:currentArg];
			else
				// Add quoted (would have originally been quoted in the shell)
				[commandString appendFormat:@"\"%@\"", currentArg];
		}
		
		F53OSCMessage *message = [F53OSCMessage messageWithString:commandString];
		[client sendPacket:message];
	}
    return 0;
}


void printVersion(void)
{
	printf("DHSendOSC 1.0\nCopyright 2013, Douglas Heriot\nhttps://github.com/DouglasHeriot/DHSendOSC\n");
}

void printHelp(void)
{
	printf("\n"
		   "Usage:	DHSendOSC -c server -p port address [arguments]\n\n"
		   "Options:\n"
		   "	--version, -V               Displays version\n"
		   "	--help, -h                  Displays this help\n"
		   "\n");
}

