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

int main(int argc, char * const * argv)
{
	@autoreleasepool
	{
		F53OSCClient *client = [F53OSCClient new];
		
		
		static struct option longOoptions[] = {
			{"version",			no_argument,		NULL,	O_VERSION},
			{"help",			no_argument,		NULL,	O_HELP},
			
			{"port",			required_argument,	NULL,	'p'},
			{"server",			required_argument,	NULL,	's'},
		};
		const char shortOptions[] = {
			O_VERSION, O_HELP,
			O_SERVER, ':', O_PORT, ':',
			'\0'};
		
		int ch;
		while((ch = getopt_long(argc, argv, shortOptions, longOoptions, NULL)) != -1)
		{
			switch ((enum OPTION)ch)
			{
				case O_VERSION:
					printVersion();
					exit(0);
					break;
					
				case O_HELP:
					printVersion();
					printHelp();
					exit(0);
					break;
					
				case O_PORT:
					client.port = atoi(optarg);
					break;
					
				case O_SERVER:
					client.URL = [NSString stringWithUTF8String:optarg];
					break;
			}
		}
		
		argc -= optind;
		argv += optind;
		
		
		
		// Put back argv together as one string
		// so that F53OSCMessage can parse it back out, with correct types
		
		NSMutableString *commandString = [NSMutableString string];
		
		for(NSUInteger i = 0; i < argc; ++i)
		{
			if(i != 0)
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
		
		if(!message)
		{
			fprintf(stderr, "Invalid OSC message.\n");
			return 1;
		}
		
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
		   "	--server, -s                Set IP of server to send UDP packets to\n"
		   "    --port, -p                  Set UDP port\n"
		   "\n"
		   "	--version, -V               Displays version\n"
		   "	--help, -h                  Displays this help\n"
		   "\n");
}

