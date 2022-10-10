//
//  DSNSDataMD5Extensions.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "DSNSDataMD5Extensions.h"

@implementation NSData(SHA256)
 
- (NSString*)SHA256 {
  // Create byte array of unsigned chars
  unsigned char sha256Buffer[CC_SHA256_DIGEST_LENGTH];
 
  // Create 16 byte MD5 hash value, store in buffer
  CC_SHA256(self.bytes, (unsigned int)self.length, sha256Buffer);
 
  // Convert unsigned char buffer to NSString of hex values
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
  for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", sha256Buffer[i]];
 
  return output;
}

@end
