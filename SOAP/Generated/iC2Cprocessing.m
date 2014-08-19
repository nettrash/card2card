/*
	iC2Cprocessing.m
	The implementation classes and methods for the processing web service.
	Generated by SudzC.com
*/

#import "iC2Cprocessing.h"
				
#import "Soap.h"
	
#import "iC2CStartRequest.h"
#import "iC2CStateResponse.h"

/* Implementation of the service */
				
@implementation iC2Cprocessing

	- (id) init
	{
		if(self = [super init])
		{
			self.serviceUrl = @"http://misc.roboxchange.com/External/Card2Card/Mobile/processing.asmx";
			self.namespace = @"http://misc.roboxchange.com/External/Card2Card/";
			self.headers = nil;
			self.logging = NO;
		}
		return self;
	}
	
	- (id) initWithUsername: (NSString*) username andPassword: (NSString*) password {
		if(self = [super initWithUsername:username andPassword:password]) {
		}
		return self;
	}
	
	+ (iC2Cprocessing*) service {
		return [iC2Cprocessing serviceWithUsername:nil andPassword:nil];
	}
	
	+ (iC2Cprocessing*) serviceWithUsername: (NSString*) username andPassword: (NSString*) password {
		return [[iC2Cprocessing alloc] initWithUsername:username andPassword:password];
	}

		
	// Returns NSString*
	/*  */
	- (SoapRequest*) Start: (id <SoapDelegate>) handler request: (iC2CStartRequest*) request
	{
		return [self Start: handler action: nil request: request];
	}

	- (SoapRequest*) Start: (id) _target action: (SEL) _action request: (iC2CStartRequest*) request
		{
		NSMutableArray* _params = [NSMutableArray array];
		
		[_params addObject: [[SoapParameter alloc] initWithValue: request forName: @"request"]];
		NSString* _envelope = [Soap createEnvelope: @"Start" forNamespace: self.namespace withParameters: _params withHeaders: self.headers];
		SoapRequest* _request = [SoapRequest create: _target action: _action service: self soapAction: @"http://misc.roboxchange.com/External/Card2Card/Start" postData: _envelope deserializeTo: @"NSString"];
		[_request send];
		return _request;
	}

	// Returns iC2CStateResponse*
	/*  */
	- (SoapRequest*) Check: (id <SoapDelegate>) handler OpKey: (NSString*) OpKey
	{
		return [self Check: handler action: nil OpKey: OpKey];
	}

	- (SoapRequest*) Check: (id) _target action: (SEL) _action OpKey: (NSString*) OpKey
		{
		NSMutableArray* _params = [NSMutableArray array];
		
		[_params addObject: [[SoapParameter alloc] initWithValue: OpKey forName: @"OpKey"]];
		NSString* _envelope = [Soap createEnvelope: @"Check" forNamespace: self.namespace withParameters: _params withHeaders: self.headers];
		SoapRequest* _request = [SoapRequest create: _target action: _action service: self soapAction: @"http://misc.roboxchange.com/External/Card2Card/Check" postData: _envelope deserializeTo: [iC2CStateResponse alloc]];
		[_request send];
		return _request;
	}


@end
	