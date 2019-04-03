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
    
    palBle = [[PalBle alloc] init];
    [palBle setListenerWithListener:self];
    
    //Test to generate new key
    for(int i = 0; i < 5; i = i + 1) {
        printf("%s\n", [[palBle generateKey] UTF8String]);
    }
    
    //[palBle startScan];
    //[palBle connectWithSerial:@"780000"];
    [palBle connectWithSerial:@"982039" key:@"ciNNPxZXoB_0C7htKpejCw==\n"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onScanResultsChanged {
    //NSArray *devices = [palBle getScanResults];
    printf("New result\n");
    
    /*for (PalDevice *device in devices) {
        NSLog(@"Device = %@", [device getSerial]);
        
        if([[device getSerial] isEqualToString:@"982030"]) {
            NSLog(@"Found what I'm after");
            [palBle stopScan];
            //[device connectWithKey:@"abcdefg" listener:self];
            
            if ([device isKindOfClass:[PalActivator class]]) {
                palActivator = (PalActivator *)device;
                [palActivator setHapticFeedbackOn:true];
            }
        }
    }*/
}

- (void)onScanTimeOut {
    printf("all done\n");
    
    [palBle startScan];
}

- (void)onScanErrorWithScanException:(BleScanException * _Nonnull)scanException { 
    printf("%ld", (long)scanException.getReason);
}


- (void)onConnectTimeout {
    printf("device not found\n");
}

- (void)onDeviceFound {
    printf("device found\n");
}

- (void)onConnectedWithDevice:(PalDevice * _Nonnull)device {
    printf("Device has connected\n");
    if ([device isKindOfClass:[PalActivator class]]) {
        palActivator = (PalActivator *)device;
    }
}

- (void)onWaking {
    printf("Waking\n");
}

- (void)onWoken {
    printf("Woken\n");
}

- (void)onNewEncryptionKeyNeeded {
    printf("New encryption key needed\n");
    [palActivator setEncryptionKeyWithKeyBase64:(@"ciNNPxZXoB_0C7htKpejCw==\n")];
}

- (void)onInvalidEncryptionKey {
    printf("Invalid encryption key\n");
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
