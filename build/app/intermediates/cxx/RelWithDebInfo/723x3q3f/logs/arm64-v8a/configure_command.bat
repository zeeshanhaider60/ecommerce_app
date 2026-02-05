@echo off
"C:\\Users\\NOCS\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\cmake.exe" ^
  "-HC:\\Users\\NOCS\\Downloads\\Compressed\\flutter_windows_3.29.2-stable\\flutter\\packages\\flutter_tools\\gradle\\src\\main\\groovy" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=24" ^
  "-DANDROID_PLATFORM=android-24" ^
  "-DANDROID_ABI=arm64-v8a" ^
  "-DCMAKE_ANDROID_ARCH_ABI=arm64-v8a" ^
  "-DANDROID_NDK=C:\\Users\\NOCS\\AppData\\Local\\Android\\sdk\\ndk\\27.0.12077973" ^
  "-DCMAKE_ANDROID_NDK=C:\\Users\\NOCS\\AppData\\Local\\Android\\sdk\\ndk\\27.0.12077973" ^
  "-DCMAKE_TOOLCHAIN_FILE=C:\\Users\\NOCS\\AppData\\Local\\Android\\sdk\\ndk\\27.0.12077973\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=C:\\Users\\NOCS\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=E:\\Veevotech Task\\ecommerce_app\\build\\app\\intermediates\\cxx\\RelWithDebInfo\\723x3q3f\\obj\\arm64-v8a" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=E:\\Veevotech Task\\ecommerce_app\\build\\app\\intermediates\\cxx\\RelWithDebInfo\\723x3q3f\\obj\\arm64-v8a" ^
  "-DCMAKE_BUILD_TYPE=RelWithDebInfo" ^
  "-BE:\\Veevotech Task\\ecommerce_app\\android\\app\\.cxx\\RelWithDebInfo\\723x3q3f\\arm64-v8a" ^
  -GNinja ^
  -Wno-dev ^
  --no-warn-unused-cli
