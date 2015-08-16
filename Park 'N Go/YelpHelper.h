//
//  YelpHelper.h
//  Park 'N Go
//
//  Created by Shaheen Sharifian on 7/18/15.
//  Copyright (c) 2015 Shaheen Sharifian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpHelper : NSObject

@property (nonatomic, strong) NSString * Client_Id;

@property (nonatomic, strong) NSString * Client_Secret;

@property (nonatomic, strong) NSString * Token;

@property (nonatomic, strong) NSString * Token_Secret;

-(NSString *)GetBusiness;

@end
