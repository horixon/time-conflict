//
//  TimeSlot.m
//  TimeSlot
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use these files
//  except in compliance with the License. You may obtain a copy of the License
//  at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed
//  to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for
//  the specific language governing permissions and limitations under the License.
//

#import "TimeSlot.h"

@implementation TimeSlot

-(id)initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    self = [super init];
    if( self ){
        self.startDate = startDate;
        self.endDate = endDate;
    }
    return self;
}

@end