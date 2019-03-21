//
//  ViewController.m
//  Obj3
//
//  Created by Nicholas Smith on 31/08/2018.
//  Copyright © 2018 PAL Technologies Ltd. All rights reserved.
//

#import "ViewController.h"
//#import <TestFramework/TestFramework-Swift.h>
#import <PalBleSwift/PalBleSwift-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

PalBle* palBle;
PalActivator* palActivator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    printf("Starting\n");
    //[TestCode Shout];
    
    //TestCode* testCode = [[TestCode alloc] init];
    //NSLog(@"%@", [testCode getMessage]);
    
    palBle = [[PalBle alloc] init];
    [palBle setListenerWithListener:self];
    
    //[palBle startScan];
    //[palBle connectWithSerial:@"780000"];
    [palBle connectWithSerial:@"780000" key:@"ciNNPxZXoB_0C7htKpejCw=="];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onScanResultsChanged {
    NSArray *devices = [palBle getScanResults];
    printf("New result");
    
    for (PalDevice *device in devices) {
        NSLog(@"Device = %@", [device getSerial]);
        
        if([[device getSerial] isEqualToString:@"680247"]) {
            NSLog(@"Found what I'm after");
            [palBle stopScan];
            [device connectWithKey:@"abcdefg" listener:self];
        }
    }
}

- (void)onScanTimeOut {
    printf("all done");
}

- (void)onScanErrorWithScanException:(BleScanException * _Nonnull)scanException { 
    printf("%ld", (long)scanException.getReason);
}




- (void)onConnectedWithDevice:(PalDevice * _Nonnull)device {
    NSLog(@"Device has connected");
    if ([device isKindOfClass:[PalActivator class]]) {
        palActivator = (PalActivator *)device;
    }
}



- (void)onSummariesRetrieved {
    printf("Summaries Retrieved\n");
    if(palActivator != nil) {
        PalActivatorData *data = [palActivator getSummaries];
        NSArray<DaySummary *> *summaries = [data getDaySummaries];
        for(id summary in summaries) {
            NSLog(@"Date: %@ - Steps: %ld - Upright: %ld - Sedentary: %ld",
                  [summary getDate],
                  (long)[summary getSteps],
                  (long)[summary getUpright],
                  (long)[summary getSedentary]);
        }
    }
}

@end
