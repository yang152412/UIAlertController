//
//  UIAlertController+Queue.m
//  neighborhood
//
//  Created by Yang on 2017/1/11.
//  Copyright © 2017年 iYaYa. All rights reserved.
//

#import "UIAlertController+Queue.h"

static NSMutableArray *GlobalAlertControllers;
static BOOL GlobalIsAlertShowing = NO;

@interface AlertControllerModel : NSObject

@property (nonatomic, weak) id owner;
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation AlertControllerModel

- (instancetype)initWithAlertController:(UIAlertController *)alertController
{
    self = [super init];
    if (self) {
        self.alertController = alertController;
    }
    return self;
}

@end

@implementation UIAlertController (Queue)

+ (UIViewController *)applicationRootViewController
{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

+ (NSMutableArray *)alertControllers
{
    if (!GlobalAlertControllers) {
        GlobalAlertControllers = [[NSMutableArray alloc] init];
    }
    return GlobalAlertControllers;
}

+ (void)addAlertController:(UIAlertController *)alertController inOwner:(id)owner
{
    AlertControllerModel *model = [[AlertControllerModel alloc] initWithAlertController:alertController];
    model.owner = owner;
    [[self alertControllers] addObject:model];
    
    [self showAlert];
}

+ (void)removeAlertController:(UIAlertController *)alertController inOwner:(id)owner
{
    AlertControllerModel *model = [self alertModelByAlertController:alertController inOwner:owner];
    [[self alertControllers] removeObject:model];
}

+ (void)removeAllAlertsInOwner:(id)owner
{
    for (AlertControllerModel *model in [self alertControllers]) {
        if (model.owner == owner) {
            [[self alertControllers] removeObject:model];
        }
    }
}

+ (void)removeShowingAlertController
{
    [[self alertControllers] removeObjectAtIndex:0];
    
    GlobalIsAlertShowing = NO;
    [self showAlert];
}

+ (AlertControllerModel *)alertModelByAlertController:(UIAlertController *)alertController inOwner:(id)owner
{
    for (AlertControllerModel *model in [self alertControllers]) {
        if (model.alertController == alertController &&
            model.owner == owner) {
            return model;
        }
    }
    return nil;
}

+ (NSArray *)alertModelsInOwner:(id)owner
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (AlertControllerModel *model in [self alertControllers]) {
        if (model.owner == owner) {
            [arr addObject:model];
        }
    }
    return arr;
}

+ (void)showAlert
{
    if (self.alertControllers.count == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!GlobalIsAlertShowing) {
            NSLog(@"\n *****show alert : %@\n",self.alertControllers);
            GlobalIsAlertShowing = YES;
            AlertControllerModel *model = (AlertControllerModel *)[self alertControllers].firstObject;
            [[self applicationRootViewController] presentViewController:model.alertController animated:YES completion:nil];
        }
    });
    
}

+ (void)dismissAlert
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self applicationRootViewController] dismissViewControllerAnimated:NO completion:nil];
        [self removeShowingAlertController];
    });
}

@end
