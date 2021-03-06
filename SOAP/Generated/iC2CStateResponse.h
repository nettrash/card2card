/*
	iC2CStateResponse.h
	The interface definition of properties and methods for the iC2CStateResponse object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface iC2CStateResponse : SoapObject
{
	NSString* _Process;
	NSString* _Comments;
	NSString* _RedirectURL;
	
}
		
	@property (retain, nonatomic) NSString* Process;
	@property (retain, nonatomic) NSString* Comments;
	@property (retain, nonatomic) NSString* RedirectURL;

	+ (iC2CStateResponse*) createWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
