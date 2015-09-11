//
//  IWGroupOperationTests.m
//  IWOperation
//
//  Created by Idriss on 20/08/2015.
//  Copyright © 2015 iOSWorkshop. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "IWGroupOperation.h"
#import "IWOperation.h"
#import "IWOperationQueue.h"
#import "IWOperationBlockObserver.h"

@interface IWGroupOperationTests : XCTestCase

@end

@implementation IWGroupOperationTests

- (void)testAddOperations
{
    __block BOOL op1Started;
    __block BOOL op1Finished;
    __block BOOL op2Started;
    __block BOOL op2Finished;
    
    IWOperation *op1 = [IWOperation new];
    IWOperation *op2 = [IWOperation new];
    [op2 addDependency:op1];
    
    XCTestExpectation *exp = [self expectationWithDescription:@"all operations should be completed"];

    
    IWOperationBlockObserver *obs = [[IWOperationBlockObserver alloc] initWithStartBlock:^(IWOperation *operation) {
        
        if (operation == op1) {
            op1Started = YES;
        } else if (operation == op2) {
            op2Started = YES;
        }
        
    } andFinishBlock:^(IWOperation *operation, NSArray *errors) {
        if (operation == op1) {
            op1Finished = YES;
        } else if (operation == op2) {
            op2Finished = YES;
        }
        
        if (op1Finished && op2Finished) {
            [exp fulfill];
        }

    }];
    
    [op1 addObserver:obs];
    [op2 addObserver:obs];
    
    
    IWGroupOperation *op = [IWGroupOperation new];
    [op setOperations:@[op1, op2]];
    
    IWOperationQueue *queue = [IWOperationQueue new];
    
    [queue addOperation:op];
    
    
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        
    }];
    
    XCTAssertEqual(op1Started,  YES);
    XCTAssertEqual(op2Started,  YES);
    XCTAssertEqual(op1Finished, YES);
    XCTAssertEqual(op2Finished, YES);

    
}

@end
