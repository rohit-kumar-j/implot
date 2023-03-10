cmake_minimum_required(VERSION 3.5)

# THIS IS QUICL AND DIRTY ONLY FOR GLFW and
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


add_library(${PROJECT_NAME} STATIC imgui_target)
target_sources(${PROJECT_NAME} PRIVATE ${IMPLOT_SOURCES})
target_link_libraries(${PROJECT_NAME} PRIVATE imgui)

# Install
install(TARGETS ${PROJECT_NAME} DESTINATION lib)
install(FILES ${IMPLOT_SOURCES} DESTINATION include/ImPlot)
