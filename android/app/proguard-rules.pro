# Retain all Zego classes and generic type information
-keep class im.zego.** { *; }
-keep class j3.a { *; }
-keepattributes Signature

# Retain Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }
-dontwarn com.google.firebase.messaging.**

# HeyTap Push SDK
-keep class com.heytap.msp.** { *; }

# Huawei Push SDK
-keep class com.huawei.hms.** { *; }

# Vivo Push SDK
-keep class com.vivo.push.** { *; }

# Xiaomi Push SDK
-keep class com.xiaomi.mipush.sdk.** { *; }

# Suppress warnings for known classes
-dontwarn com.heytap.msp.push.**
-dontwarn com.huawei.hms.**
-dontwarn com.vivo.push.**
-dontwarn com.xiaomi.mipush.sdk.**
-dontwarn java.beans.**
-dontwarn org.w3c.dom.bootstrap.**

# Retain Jackson Annotations and Beans
-keep class java.beans.** { *; }
-keepattributes *Annotation*

# Retain W3C DOM Implementation
-keep class org.w3c.dom.bootstrap.DOMImplementationRegistry { *; }
# Zego Core
-keep class im.zego.** { *; }
-keep class **.zego.** { *; }
-keep class im.zego.zpns.** { *; }
-keep class im.zego.zpns_flutter.** { *; }

# Specific Zego Classes
-keep class M3.a { *; }
-keep class M3.a.b { *; }
-keep class j3.a { *; }

# Generic Signatures
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken

# Jackson
-keep @com.fasterxml.jackson.annotation.JsonIgnoreProperties class * { *; }
-keep class com.fasterxml.jackson.** { *; }

# Gson
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }