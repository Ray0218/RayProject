// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: person.proto

#import "GPBProtocolBuffers.h"

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30000
#error This file was generated by a different version of protoc-gen-objc which is incompatible with your Protocol Buffer sources.
#endif

// @@protoc_insertion_point(imports)

CF_EXTERN_C_BEGIN


#pragma mark - PersonRoot

@interface PersonRoot : GPBRootObject

// The base class provides:
//   + (GPBExtensionRegistry *)extensionRegistry;
// which is an GPBExtensionRegistry that includes all the extensions defined by
// this file and all files that it depends on.

@end

#pragma mark - PBUser

typedef GPB_ENUM(PBUser_FieldNumber) {
  PBUser_FieldNumber_UserId = 1,
  PBUser_FieldNumber_Nick = 2,
  PBUser_FieldNumber_Avatar = 3,
};

@interface PBUser : GPBMessage

@property(nonatomic, readwrite) BOOL hasUserId;
@property(nonatomic, readwrite, copy) NSString *userId;

@property(nonatomic, readwrite) BOOL hasNick;
@property(nonatomic, readwrite, copy) NSString *nick;

@property(nonatomic, readwrite) BOOL hasAvatar;
@property(nonatomic, readwrite, copy) NSString *avatar;

@end

CF_EXTERN_C_END

// @@protoc_insertion_point(global_scope)
