cmake_minimum_required(VERSION 3.21.1)

add_executable(TextEditor main.c)

target_include_directories(TextEditor PRIVATE "include")