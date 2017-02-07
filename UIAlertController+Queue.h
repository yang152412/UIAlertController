//
//  UIAlertController+Queue.h
//  neighborhood
//
//  Created by Yang on 2017/1/11.
//  Copyright © 2017年 iYaYa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Queue)

+ (void)addAlertController:(UIAlertController *)alertController inOwner:(id)owner;
+ (void)removeAllAlertsInOwner:(id)owner;
+ (void)dismissAlert; // dismiss showing alert
@end
