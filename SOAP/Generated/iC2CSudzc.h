/*
	iC2CSudzc.h
	Creates a list of the services available with the iC2C prefix.
	Generated by SudzC.com
*/
#import "iC2Cprocessing.h"

@interface iC2CSudzC : NSObject {
	BOOL logging;
	NSString* server;
	NSString* defaultServer;
iC2Cprocessing* processing;

}

-(id)initWithServer:(NSString*)serverName;
-(void)updateService:(SoapService*)service;
-(void)updateServices;
+(iC2CSudzC*)sudzc;
+(iC2CSudzC*)sudzcWithServer:(NSString*)serverName;

@property (nonatomic) BOOL logging;
@property (nonatomic, retain) NSString* server;
@property (nonatomic, retain) NSString* defaultServer;

@property (nonatomic, retain, readonly) iC2Cprocessing* processing;

@end
			