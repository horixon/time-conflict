//
//  TimeSlotTests.m
//  TimeSlotTests
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use these files
//  except in compliance with the License. You may obtain a copy of the License
//  at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed
//  to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for
//  the specific language governing permissions and limitations under the License.
//

#import <XCTest/XCTest.h>
#import "TimeSlot.h"
#import "NSMutableArray+Shuffle.h"
#import "TimeConflict/TimeConflict.h"

@import EventKit;

@interface TimeSlotTests : XCTestCase
+(bool) isOrderedSame:(NSDate*)reciever sender:(NSDate*)sender;
@end

@implementation TimeSlotTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

+(bool) isOrderedSame:(NSDate*)reciever sender:(NSDate*)sender{
    return
    [reciever compare: sender] == NSOrderedSame;
}

- (void)testIdentifyConflicts
{
    TimeSlot *t0 =
    [[TimeSlot alloc]
     initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)0]
     endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)1]];
 
    
    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *t1 = [EKEvent eventWithEventStore:store];
    t1.startDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)1];
    t1.endDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)3];
    
    
    TimeSlot *t2 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)1] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)2]];
    
    
    TimeSlot *t3 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)2] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)4]];
    TimeSlot *t4 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)2] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)3]];
    TimeSlot *t5 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)3] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)4]];
    TimeSlot *t6 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)4] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)5]];
    
    NSMutableArray *timeSlots = [@[t0,t1, t2, t3, t4, t5, t6] mutableCopy];
    [timeSlots shuffle];
    
    NSArray *array =  [TimeConflict identifyConflicts:timeSlots];
    
    XCTAssertTrue( [array count] == 1 );
    
    XCTAssertTrue( [array[0] count] == 5 );
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][0] startDate] sender:t1.startDate]);
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][0] endDate] sender:t1.endDate]);
    
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][1] startDate] sender:t2.startDate]);
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][1] endDate] sender:t2.endDate]);
    
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][2] startDate] sender:t3.startDate]);
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][2] endDate] sender:t3.endDate]);
    
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][3] startDate] sender:t4.startDate]);
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][3] endDate] sender:t4.endDate]);
    
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][4] startDate] sender:t5.startDate]);
    XCTAssertTrue(
        [TimeSlotTests isOrderedSame:[array[0][4] endDate] sender:t5.endDate]);
    
}


- (void)testNoConflicts
{

    TimeSlot *t0 =
    [[TimeSlot alloc]
     initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)0]
     endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)1]];
    
    
    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *t1 = [EKEvent eventWithEventStore:store];
    t1.startDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)1];
    t1.endDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)3];
    
    
    TimeSlot *t2 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)3] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)4]];
    
    
    TimeSlot *t3 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)4] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)5]];
    TimeSlot *t4 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)100] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)200]];
    TimeSlot *t5 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)8] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)9]];
    TimeSlot *t6 = [[TimeSlot alloc] initWithStartDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)25] endDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)100]];
    
    
    NSMutableArray *timeSlots = [@[t0,t1, t2, t3, t4, t5, t6] mutableCopy];
    [timeSlots shuffle];
    
    NSArray *array =  [TimeConflict identifyConflicts:timeSlots];
    
    XCTAssertTrue( [array count] == 0 );

}

- (void)testOneEvent
{
    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *t1 = [EKEvent eventWithEventStore:store];
    t1.startDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)1];
    t1.endDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)3];
    
    NSMutableArray *timeSlots = [@[t1] mutableCopy];
    [timeSlots shuffle];
    
    NSArray *array =  [TimeConflict identifyConflicts:timeSlots];
    
    XCTAssertTrue( [array count] == 0 );
    
}

- (void)testOverlapAndEndOnConflicts
{
    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *t1 = [EKEvent eventWithEventStore:store];
    t1.startDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)1];
    t1.endDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)3];
    
    EKEvent *t2 = [EKEvent eventWithEventStore:store];
    t2.startDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)2];
    t2.endDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)4];
    
    
    NSMutableArray *timeSlots = [@[t1,t2] mutableCopy];
    [timeSlots shuffle];
    
    NSArray *array =  [TimeConflict identifyConflicts:timeSlots];
    
    XCTAssertTrue( [array count] == 1 );
    
}

- (void)testNoEvents
{
    NSMutableArray *timeSlots = [@[] mutableCopy];
    [timeSlots shuffle];
    
    NSArray *array =  [TimeConflict identifyConflicts:timeSlots];
    
    XCTAssertTrue( [array count] == 0 );
    
}



@end
