include(ExternalProject)

macro(append_cmake_prefix_path)
    list(APPEND CMAKE_PREFIX_PATH ${ARGN})
    string(REPLACE ";" "|" CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}")
endmacro()

function(BuildExternalProject)
    set(one_value_args
        NAME # name of directory in <INSTALL_DIR>/NAME"
        LIB_NAME # For example, the glfw library needs us to link against the target glfw3 not glfw
        GIT_REPO # URL : https://github.com/user/repo.git
        GIT_TAG # Release tags: "3.3.8","2.3.2" ...
        INSTALL_PATH # "${PROJECT_SOURCE_DIR}/external" in this example
        BUILD_TYPE # "Release", "Debug" ...
        ARCHITECTURE # "x64","x86"...
        BUILD_IN_SOURCE # If there are other install targets
    )
    set(multi_value_args
        EXTRA_CMAKE_ARGS
        EXT_BUILD_ARGS
        EXT_INSTALL_ARGS
    )

    # Parse arguments.
    cmake_parse_arguments(
        _ARGS # Main prefix for parsed args
        "${options}"
        "${one_value_args}"
        "${multi_value_args}"
        ${ARGN} # Number of Args
    )

    # Set new path
    set(INSTALL_PATH_NEW_PREFIX ${_ARGS_INSTALL_PATH}/${_ARGS_ARCHITECTURE}-${_ARGS_BUILD_TYPE}/${_ARGS_NAME})

    set(INSTALL_PATH_LIB ${INSTALL_PATH_NEW_PREFIX}/lib)
    set(INSTALL_PATH_INCLUDE ${INSTALL_PATH_NEW_PREFIX}/include)

    set(_UTILITY_NAME ${_ARGS_NAME}_utility)

    ExternalProject_Add(
        ${_UTILITY_NAME}
        PREFIX ${_UTILITY_NAME}
        GIT_REPOSITORY ${_ARGS_GIT_REPO}
        GIT_TAG ${_ARGS_GIT_TAG}

        CMAKE_CACHE_ARGS # CMAKE_ARGS does not use the FORCE option, this is a problem especially in IDEs
            "-DCMAKE_BUILD_TYPE:STRING=${_ARGS_BUILD_TYPE}"

        # This is where the install will
        "-DCMAKE_INSTALL_PREFIX:PATH=${INSTALL_PATH_NEW_PREFIX}"

        # Addition parsed args
        ${_ARGS_EXTRA_CMAKE_ARGS}

        # Commands to build
        BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target install --config ${_ARGS_BUILD_TYPE}
        COMMAND ${_ARGS_EXT_BUILD_ARGS}

        # Commands to install
        INSTALL_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target install --config ${_ARGS_BUILD_TYPE}
        COMMAND ${_ARGS_EXT_INSTALL_ARGS}

        BUILD_IN_SOURCE ${_ARGS_BUILD_IN_SOURCE}

        CONFIGURE_HANDLED_BY_BUILD ON # No config steps are passed
        BUILD_ALWAYS FALSE
        UPDATE_DISCONNECTED TRUE
    )

    # We append to `CMAKE_INSTALL_PREFIX`
    append_cmake_prefix_path(${INSTALL_PATH_NEW_PREFIX})

    # We make the temporary directory
    file(MAKE_DIRECTORY ${INSTALL_PATH_INCLUDE})

    # We make the new dummy imported library
    add_library(${_ARGS_LIB_NAME} INTERFACE IMPORTED GLOBAL ${_UTILITY_NAME})

    target_include_directories(${_ARGS_LIB_NAME} INTERFACE ${INSTALL_PATH_INCLUDE})
    target_link_libraries(${_ARGS_LIB_NAME} INTERFACE ${INSTALL_PATH_LIB}/*.lib)
    add_dependencies(${_ARGS_LIB_NAME} ${_UTILITY_NAME})
endfunction()
