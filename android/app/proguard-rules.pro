# Keep Google Crypto Tink classes
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn javax.annotation.concurrent.**
-dontwarn com.google.api.client.**
-dontwarn org.joda.time.**

# Keep annotations
-keep class com.google.errorprone.annotations.** { *; }
-keep class javax.annotation.** { *; }
-keep class javax.annotation.concurrent.** { *; }

# Keep Google API Client classes
-keep class com.google.api.client.** { *; }
-keepclassmembers class com.google.api.client.** { *; }

# Keep Joda Time classes
-keep class org.joda.time.** { *; }
-keepclassmembers class org.joda.time.** { *; }

# Keep Tink classes
-keep class com.google.crypto.tink.** { *; }
-keepclassmembers class com.google.crypto.tink.** { *; }

