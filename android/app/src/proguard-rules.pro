# Keep OkHttp classes for image_cropper
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Keep UCrop classes
-dontwarn com.yalantis.ucrop**
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }

# Keep image_cropper classes
-keep class vn.hunghd.flutter.plugins.imagecropper.** { *; }