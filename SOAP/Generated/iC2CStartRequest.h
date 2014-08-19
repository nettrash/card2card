/*
	iC2CStartRequest.h
	The interface definition of properties and methods for the iC2CStartRequest object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface iC2CStartRequest : SoapObject
{
	NSString* _FromCardNumber;
	int _FromCardExpMonth;
	int _FromCardExpYear;
	NSString* _FromCardCVC;
	NSString* _ToCardNumber;
	NSDecimalNumber* _Summa;
	
}
		
	@property (retain, nonatomic) NSString* FromCardNumber;
	@property int FromCardExpMonth;
	@property int FromCardExpYear;
	@property (retain, nonatomic) NSString* FromCardCVC;
	@property (retain, nonatomic) NSString* ToCardNumber;
	@property (retain, nonatomic) NSDecimalNumber* Summa;

	+ (iC2CStartRequest*) createWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end