//
//  CContact.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-30.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CContact.h"

@implementation CContact
-(NSMutableDictionary *)phoneInfo
{
    if(_phoneInfo == nil)
    {
        _phoneInfo = [[NSMutableDictionary alloc] init];
    }
    
    return _phoneInfo;
}


-(NSMutableDictionary *)emailInfo
{
    if(_emailInfo == nil)
    {
        _emailInfo = [[NSMutableDictionary alloc] init];
    }
    return  _emailInfo;
}

//取得所有的联系人
-(NSMutableArray *)allContacts
{
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSArray * contacts = (NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    
    
    //    if([_allContacts retainCount] > 0) [_allContacts release];
    
    _allContacts = [[NSMutableArray alloc] init];
    
    
    int contactsCount = [contacts count];
    
    for(int i = 0; i < contactsCount; i++)
    {
        ABRecordRef record = (ABRecordRef)[contacts objectAtIndex:i];
        CContact * contact = [[CContact alloc] init];
        //取得姓名
        CFStringRef  firstNameRef =  ABRecordCopyValue(record, kABPersonFirstNameProperty);
        contact.firstName = (NSString *)firstNameRef;
        CFStringRef lastNameRef = ABRecordCopyValue(record, kABPersonLastNameProperty);
        contact.lastName = (NSString *)lastNameRef;
        CFStringRef compositeNameRef = ABRecordCopyCompositeName(record);
        contact.compositeName = (NSString *)compositeNameRef;
        
        firstNameRef != NULL ? CFRelease(firstNameRef) : NULL;
        lastNameRef != NULL ? CFRelease(lastNameRef) : NULL;
        compositeNameRef != NULL ? CFRelease(compositeNameRef) : NULL;
        
        //取得联系人的ID
        contact.recordID = (int)ABRecordGetRecordID(record);
        
        
        
        //联系人头像
        if(ABPersonHasImageData(record))
        {
            //            NSData * imageData = ( NSData *)ABPersonCopyImageData(record);
            NSData * imageData = (NSData *)ABPersonCopyImageDataWithFormat(record,kABPersonImageFormatThumbnail);
            UIImage * image = [[UIImage alloc] initWithData:imageData];
            
            [imageData release];
            
            contact.image = image;
            
            [image release];
            
        }
        
        
        //处理联系人电话号码
        ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        for(int i = 0; i < ABMultiValueGetCount(phones); i++)
        {
            
            CFStringRef phoneLabelRef = ABMultiValueCopyLabelAtIndex(phones, i);
            CFStringRef localizedPhoneLabelRef = ABAddressBookCopyLocalizedLabel(phoneLabelRef);
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
            
            NSString * localizedPhoneLabel = (NSString *) localizedPhoneLabelRef;
            NSString * phoneNumber = (NSString *)phoneNumberRef;
            
            [contact.phoneInfo setValue:phoneNumber forKey:localizedPhoneLabel];
            
            //释放内存
            phoneLabelRef == NULL ? : CFRelease(phoneLabelRef);
            localizedPhoneLabelRef == NULL ? : CFRelease(localizedPhoneLabelRef);
            phoneNumberRef == NULL ? : CFRelease(phoneNumberRef);
            
        }
        if(phones != NULL) CFRelease(phones);
        
        //处理联系人邮箱
        ABMultiValueRef emails = ABRecordCopyValue(record, kABPersonEmailProperty);
        for(int i = 0; i < ABMultiValueGetCount(emails); i++)
        {
            
            CFStringRef emailLabelRef = ABMultiValueCopyLabelAtIndex(emails, i);
            CFStringRef localizedEmailLabelRef = ABAddressBookCopyLocalizedLabel(emailLabelRef);
            CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, i);
            
            NSString * localizedEmailLabel = ( NSString *)localizedEmailLabelRef;
            
            NSString * email = (NSString *)emailRef;
            
            [contact.emailInfo setValue:email forKey:localizedEmailLabel];
            
            emailLabelRef == NULL ? : CFRelease(emailLabelRef);
            localizedEmailLabel == NULL ? : CFRelease(localizedEmailLabelRef);
            emailRef == NULL ? : CFRelease(emailRef);
            
        }
        if(emails != NULL) CFRelease(emails);
        
        
        [_allContacts addObject:contact];
        [contact release];
        CFRelease(record);
        
    }
    
    [pool drain];
    return [_allContacts autorelease];
    
}
@end
