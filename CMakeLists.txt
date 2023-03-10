cmake_minimum_required(VERSION 3.5)

# QUICK AND DIRTY cmake
project(ImPlot_Project CXX)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(BuildExternalProject)

BuildExternalProject(
    NAME imgui
    LIB_NAME imgui_target
    GIT_REPO https://github.com/rohit-kumar-j/imgui.git
    GIT_TAG origin/docking
    INSTALL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/external
    BUILD_TYPE Release
    ARCHITECTURE x64
)

set(CMAKE_PREFIX_PATH ${CMAKE_CURRENT_SOURCE_DIR}/external/x64-Release/imgui/include/imgui CACHE PATH "" FORCE) # This is highly convoluted
set(CMAKE_BUILD_TYPE Release CACHE PATH "" FORCE) # This is highly convoluted

# include(FetchContent)
# FetchContent_Declare(imgui GIT_REPOSITORY https://github.com/rohit-kumar-j/imgui.git)
# FetchContent_GetProperties(imgui)
# if(NOT imgui_POPULATED)
# FetchContent_Populate(imgui)
# add_subdirectory(${imgui_SOURCE_DIR} ${imgui_BINARY_DIR} EXCLUDE_FROM_ALL)
# endif()
file(GLOB IMPLOT_SOURCES
    implot.cpp
    implot_demo.cpp
    implot_items.cpp
)
file(GLOB IMPLOT_HEADERS
    implot.h
    implot_internal.h
)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/external/x64-Release/imgui/include/imgui)
add_library(ImPlot STATIC ${IMPLOT_SOURCES})

# target_include_directories(ImPLot
# PRIVATE
# ${imgui_INCLUDEDIR}
# )
target_link_libraries(ImPlot PRIVATE imgui_target)

# Install
install(TARGETS ImPlot DESTINATION lib)
install(FILES ${IMPLOT_HEADERS} DESTINATION include/ImPlot)
