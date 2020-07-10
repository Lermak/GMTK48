cmake_minimum_required(VERSION 3.10)
set(EXECUTABLE_OUTPUT_PATH "bin")
project (WwiseBuildProject)

set(WWISE_VERSION "Wwise 2019.1.1.6977")
set(WWISE_SDK_FOLDER "C:/Program Files (x86)/Audiokinetic/${WWISE_VERSION}/SDK")
set(WWISE_FOLDER "${WWISE_SDK_FOLDER}/samples/DynamicLibraries/AkSoundEngineDLL")


file(GLOB_RECURSE wwise_dll "src/*.cpp" "${WWISE_SDK_FOLDER}/samples/SoundEngine/Win32/*.cpp" "${WWISE_SDK_FOLDER}/samples/SoundEngine/Common/*.cpp")

include_directories("${WWISE_FOLDER}/Win32")
include_directories("${WWISE_SDK_FOLDER}/include/")
include_directories("${WWISE_SDK_FOLDER}/samples/SoundEngine/Win32")

add_definitions(-D_USRDLL)
add_definitions(-DAKSOUNDENGINE_DLL)
add_definitions(-DAKSOUNDENGINE_EXPORTS)
add_definitions(-DWWISE_EXPORTS)
add_definitions(-DUNICODE)


add_definitions(-DAK_OPTIMIZED)
file(GLOB WWISE_LIBS "${WWISE_SDK_FOLDER}/Win32_vc150/Release/lib/*.lib")

#file(GLOB WWISE_LIBS "${WWISE_SDK_FOLDER}/Win32_vc150/Profile/lib/*.lib")


add_library (WwiseBuildProject SHARED ${wwise_dll})


target_link_libraries(WwiseBuildProject ${WWISE_LIBS})
target_link_libraries(WwiseBuildProject "dinput8.lib" "dxguid.lib" "dsound.lib" "ws2_32.lib")