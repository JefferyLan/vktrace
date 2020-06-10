@echo off
REM # Copyright 2015-2019 The Android Open Source Project
REM # Copyright (C) 2015-2019 Valve Corporation
REM # Copyright (C) 2015-2019 LunarG, Inc.
REM
REM # Licensed under the Apache License, Version 2.0 (the "License");
REM # you may not use this file except in compliance with the License.
REM # You may obtain a copy of the License at
REM
REM #      http://www.apache.org/licenses/LICENSE-2.0
REM
REM # Unless required by applicable law or agreed to in writing, software
REM # distributed under the License is distributed on an "AS IS" BASIS,
REM # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM # See the License for the specific language governing permissions and
REM # limitations under the License.

echo Removing old generated directory in build-android
echo ********
if exist generated (
    RMDIR /S /Q generated
)

echo Creating new empty generated directories in build-android
echo ********
MKDIR generated
MKDIR generated\include
MKDIR generated\common

echo Setting some environment variables
echo ********
set LVL_BASE=%~dp0\third_party\Vulkan-ValidationLayers
set LVL_SCRIPTS=%LVL_BASE%\scripts
set VT_SCRIPTS=..\..\..\scripts
set REGISTRY_PATH=%~dp0\third_party\Vulkan-Headers\registry
set REGISTRY=%REGISTRY_PATH%\vk.xml

echo Entering Generated/Include Folder
echo ********
pushd generated\include

REM apidump
echo Generating apidump header/source files
echo ********
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% api_dump.cpp
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% api_dump_text.h
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% api_dump_html.h
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% api_dump_json.h
 
REM vktrace
echo Generating vktrace header/source files
echo ********
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% vktrace_vk_vk.h
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% vktrace_vk_vk.cpp
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% vktrace_vk_vk_packets.h
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% vktrace_vk_packet_id.h
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% vk_struct_size_helper.h
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% vk_struct_size_helper.c

REM vkreplay
echo Generating vkreplay header/source files
echo ********
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% vkreplay_vk_func_ptrs.h
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% vkreplay_vk_replay_gen.cpp
py -3 %VT_SCRIPTS%\vt_genvk.py -registry %REGISTRY% -scripts %REGISTRY_PATH% vkreplay_vk_objmapper.h

REM Copy over the built source files to LVL.  Otherwise,
REM cube won't build.
echo Entering third_party\Vulkan-ValidationLayers\build-android
echo ********
pushd %LVL_BASE%\build-android
REM Removing old generated directory in third_party\Vulkan-ValidationLayers\build-android
if exist generated (
    RMDIR /S /Q generated
)
REM Creating new empty generated directories in third_party\Vulkan-ValidationLayers\build-android
MKDIR generated
MKDIR generated\include
MKDIR generated\common

echo Leaving third_party\Vulkan-ValidationLayers\build-android
echo ********
popd
