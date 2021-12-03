cmake_minimum_required(VERSION 3.21.1)

project(TextEditor 
VERSION 1.0.0
LANGUAGES C
DESCRIPTION "Vim like editor for windows, linux and mac" 
HOMEPAGE_URL "https://github.com/Ruinerwarrior/TextEditor")

# works only for multi-config generators
set ( BUILD_CONFIG $<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>$<$<CONFIG:RelWithdepInfo>:RelWithdepInfo>)

if(NOT BUILD_CONFIG)

if(NOT CMAKE_BUILD_TYPE)
set (CMAKE_BUILD_TYPE Release)
endif(NOT CMAKE_BUILD_TYPE)

set (BUILD_CONFIG ${CMAKE_BUILD_TYPE})

endif(NOT BUILD_CONFIG)

message(STATUS ${CMAKE_BUILD_TYPE})
message(STATUS ${BUILD_CONFIG})

set(OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_SYSTEM_NAME}/${CMAKE_C_COMPILER_ID}/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>$<$<CONFIG:RelWithdepInfo>:RelWithdepInfo>/)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}/bin)

# make version available in code
configure_file (
    "${PROJECT_SOURCE_DIR}/version.h.in"
    "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}/include/version.h"
)

include(CTest)
enable_testing()

add_subdirectory("TextEditor")

include(CPack.cmake)
include(CPack)
