cmake_minimum_required(VERSION 3.5)

# QUICK AND DIRTY cmake
project(ImPlot CXX)

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

file(GLOB IMPLOT_SOURCES
    implot.cpp
    implot.h
    implot_demo.cpp
    implot_internal.h
    implot_items.cpp
)

add_library(ImPlot STATIC imgui_target)
target_sources(ImPlot PRIVATE ${IMPLOT_SOURCES})
target_link_libraries(ImPlot PRIVATE imgui)

# Install
install(TARGETS ImPlot DESTINATION lib)
install(FILES ${IMPLOT_SOURCES} DESTINATION include/ImPlot)
