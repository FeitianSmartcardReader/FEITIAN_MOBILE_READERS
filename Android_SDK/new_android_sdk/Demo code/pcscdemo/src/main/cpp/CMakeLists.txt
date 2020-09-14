cmake_minimum_required(VERSION 3.4.1)

include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}
)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} SRC_LIST)

add_library( pcsc
        SHARED
        ${SRC_LIST} )

find_library( log-lib
        log )

# IMPORTED 表示只需要导入，不需要构建库
add_library(comm STATIC IMPORTED)

# 设置库的路径
set_target_properties(
        comm
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${ANDROID_ABI}/libFTReaderPCSC_1.0.2.a
)

target_link_libraries( pcsc
        comm
        ${log-lib} )