#import "ContextBuilderPlugin.h"
#import <context_builder/context_builder-Swift.h>

@implementation ContextBuilderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftContextBuilderPlugin registerWithRegistrar:registrar];
}
@end
