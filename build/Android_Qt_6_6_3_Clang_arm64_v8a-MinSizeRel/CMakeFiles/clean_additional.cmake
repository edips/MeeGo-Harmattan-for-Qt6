# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "MinSizeRel")
  file(REMOVE_RECURSE
  "CMakeFiles/appmeego_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appmeego_autogen.dir/ParseCache.txt"
  "appmeego_autogen"
  )
endif()
