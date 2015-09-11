//
//  IWMutalExclusionCondition.m
//
//  Created by Idriss on 03/08/2015.
//

#import "IWMutalExclusionCondition.h"

#import "IWConditionEvalutation.h"

@interface IWMutalExclusionCondition ()

@property (nonatomic, strong) NSString *className;

@end

@implementation IWMutalExclusionCondition

+ (IWMutalExclusionCondition*)alertControllerMutex
{
    IWMutalExclusionCondition *alertControllerMutex = [IWMutalExclusionCondition new];
    alertControllerMutex.className                  = @"UIAlertController";
    
    return alertControllerMutex;
}

- (NSString*)name
{
    NSString *displayName = _className;
    if (!displayName) {
        displayName = NSStringFromClass([self class]);
    }
    
    return [NSString stringWithFormat:@"IWMutalExclusionCondition<%@>", displayName];
}

- (BOOL)isMutuallyExclusive
{
    return YES;
}

- (BOOL)conditionSatisfied
{
    return YES;
}

- (void)evaluateConditionForOperation:(IWOperation *)operation completion:(void (^)(IWConditionEvalutation *))completionBlock
{
    completionBlock([IWConditionEvalutation success]);
}

@end
