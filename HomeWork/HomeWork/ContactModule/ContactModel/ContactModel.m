//
//  ContactModel.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "ContactModel.h"

@interface ContactModel ()

@end

@implementation ContactModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setModelArr];
        [self setSectionHeaderArr];
    }
    return self;
}

- (void)setModelArr {
    self.modelArr = @[
        @[@"Alice"],  // A组
        @[@"Bob", @"Bella", @"Ben", @"Brenda", @"Brock"],     // B组
        @[@"Cameron", @"Cara", @"Carl", @"Claire", @"Cathy"], // C组
        @[@"Daniel", @"Daisy", @"Dean", @"Dana", @"Dylan"],   // D组
        @[@"Evan", @"Elsa", @"Eli", @"Ellie", @"Edith"],      // E组
        @[@"Frank", @"Fay", @"Finn", @"Freya", @"Felix"],     // F组
        @[@"George", @"Gina", @"Grant", @"Grace", @"Gary"],   // G组
        @[@"Hannah", @"Hank", @"Holly", @"Hailey", @"Harry"], // H组
        @[@"Ian", @"Ivy", @"Isaac", @"Irene", @"Iris"],       // I组
        @[@"Jack", @"Jill", @"Joe", @"Joan", @"Jake"],        // J组
        @[@"Karen", @"Kyle", @"Kim", @"Keith", @"Kara"],      // K组
        @[@"Liam", @"Lily", @"Luna", @"Leo", @"Laura"]        // L组
    ];
}

- (void)setSectionHeaderArr {
    self.sectionHeaderArr = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L"];
}

@end
