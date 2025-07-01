cmake_minimum_required(VERSION 3.30)

project("frames_to_atlas")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Stb REQUIRED)

set(EXE "frames_to_atlas")
file(GLOB_RECURSE SRC_FILES "src/**.cpp")
add_executable(${EXE} ${SRC_FILES})

target_include_directories(${EXE} PRIVATE ${Stb_INCLUDE_DIR})

install(TARGETS ${EXE} DESTINATION .)
