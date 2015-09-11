//
//  IWOperationQueueTests.m
//  
//
//  Created by Idriss on 06/08/2015.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "IWOperationQueue.h"
#import "IWOperation.h"

#import "IWTestCondition.h"

@interface IWOperationQueueTests : XCTestCase

@end

@implementation IWOperationQueueTests

- (void)testAddNilOperation
{
    
    IWOperationQueue *queue = [[IWOperationQueue alloc] init];
    XCTAssertNotNil(queue);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wall"
    [queue addOperation:nil];
#pragma clang diagnostic pop
    XCTAssertEqual(0, [queue operationCount]);
}

- (void)testAddOperations
{
    
    IWOperationQueue *queue = [[IWOperationQueue alloc] init];
    XCTAssertNotNil(queue);
    queue.suspended = YES;
    
    [queue addOperation:[IWOperation new]];
    XCTAssertEqual(1, [queue operationCount]);
    
    [queue addOperation:[IWOperation new]];
    XCTAssertEqual(2, [queue operationCount]);
}

- (void)testAddOperationWithCondition
{
    IWOperationQueue *queue = [[IWOperationQueue alloc] init];
    XCTAssertNotNil(queue);
    queue.suspended = YES;

    IWOperation *op = [IWOperation new];
    [op addCondition:[[IWTestCondition alloc] init]];
    
    [queue addOperation:op];
    
    XCTAssertEqual(2, [queue operationCount]);
    
}


@end
