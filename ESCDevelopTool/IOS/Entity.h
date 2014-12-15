//
//  Entity.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/7/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * identifier;

@end
