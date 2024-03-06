set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(triple x86_64-apple-darwin21.4)

set(CMAKE_C_COMPILER ${triple}-clang)
set(CMAKE_CXX_COMPILER ${triple}-clang++)
set(CMAKE_RANLIB ${triple}-ranlib)
set(CMAKE_AR ${triple}-ar)

set(CMAKE_OSX_DEPLOYMENT_TARGET 12.3)