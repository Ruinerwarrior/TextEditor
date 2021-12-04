rm -rf ./build
cmake -S . -B build -D CMAKE_BUILD_TYPE=Release
cmake --build build
cd ./build
cpack -C Release --verbose