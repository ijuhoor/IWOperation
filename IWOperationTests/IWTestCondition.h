//
//  IWTestCondition.h
//  TestOperations
//
//  Created by Idriss on 05/08/2015.
//  Copyright © 2015 lastminute. All rights reserved.
//

#import "IWOperation.h"

#import "IWConditionOperationProtocol.h"

@interface IWTestCondition : IWOperation <IWConditionOperationProtocol>

@property (nonatomic) BOOL succeeds;

@end
