//
//  TimeConflict.m
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

#import "TimeConflict.h"

@implementation TimeConflict

static NSComparisonResult compareUsingDuration (id obj1, id obj2, void *context)
{
    NSComparisonResult comparison = [ [obj1 startDate] compare: [obj2 startDate]];
    
    NSTimeInterval selfDuration = [TimeConflict durationStartDate: [obj1 startDate] toEndDate: [obj1 endDate]];
    NSTimeInterval otherDuration = [TimeConflict durationStartDate: [obj2 startDate] toEndDate: [obj2 endDate]];
    
    if (comparison == NSOrderedSame){
        
        if(selfDuration > otherDuration){
            
            return NSOrderedAscending;
        }
        else if(selfDuration < otherDuration){
            
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }
    return comparison;
}

+(NSTimeInterval)durationStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate{
    return [endDate timeIntervalSinceReferenceDate] - [startDate timeIntervalSinceReferenceDate];
}

+(NSArray*)identifyConflicts:(NSArray*) events
{
    if(events.count < 1) return @[];
    
    NSArray *sortedArray = [events sortedArrayUsingFunction:compareUsingDuration context:NULL];
    
    NSMutableArray *conflicts = [NSMutableArray new];
    NSMutableArray *conflictingEvents = [NSMutableArray new];
    [conflictingEvents addObject:[sortedArray firstObject]];
    NSDate* maxEndDate = [[sortedArray firstObject] endDate];
    
    for(int i = 1;i<[sortedArray count];i++ )
    {
        id potentialConflict = sortedArray[i];
        
        if( [maxEndDate compare: [potentialConflict startDate]] == NSOrderedDescending){
            
            if([maxEndDate compare:[potentialConflict endDate]] == NSOrderedAscending){
                maxEndDate = [potentialConflict endDate];
            }
            
            [conflictingEvents addObject:potentialConflict];
            
        }else{
            
            if(conflictingEvents.count > 1)
            {
                [conflicts addObject:conflictingEvents];
            }
            
            maxEndDate = [potentialConflict endDate];
            conflictingEvents = [NSMutableArray new];
            [conflictingEvents addObject:potentialConflict];
        }
    }
    
    if(conflictingEvents.count > 1)
    {
        [conflicts addObject:conflictingEvents];
    }
    
    return [[NSArray alloc] initWithArray:conflicts];
}

@end
