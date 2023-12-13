if(NOT TARGET ReactAndroid::fabricjni)
add_library(ReactAndroid::fabricjni SHARED IMPORTED)
set_target_properties(ReactAndroid::fabricjni PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/fabricjni/libs/android.x86/libfabricjni.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/fabricjni/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::folly_runtime)
add_library(ReactAndroid::folly_runtime SHARED IMPORTED)
set_target_properties(ReactAndroid::folly_runtime PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/folly_runtime/libs/android.x86/libfolly_runtime.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/folly_runtime/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::glog)
add_library(ReactAndroid::glog SHARED IMPORTED)
set_target_properties(ReactAndroid::glog PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/glog/libs/android.x86/libglog.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/glog/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::hermes_executor)
add_library(ReactAndroid::hermes_executor SHARED IMPORTED)
set_target_properties(ReactAndroid::hermes_executor PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/hermes_executor/libs/android.x86/libhermes_executor.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/hermes_executor/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::jscexecutor)
add_library(ReactAndroid::jscexecutor SHARED IMPORTED)
set_target_properties(ReactAndroid::jscexecutor PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/jscexecutor/libs/android.x86/libjscexecutor.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/jscexecutor/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::jsi)
add_library(ReactAndroid::jsi SHARED IMPORTED)
set_target_properties(ReactAndroid::jsi PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/jsi/libs/android.x86/libjsi.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/jsi/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::jsinspector)
add_library(ReactAndroid::jsinspector SHARED IMPORTED)
set_target_properties(ReactAndroid::jsinspector PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/jsinspector/libs/android.x86/libjsinspector.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/jsinspector/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_codegen_rncore)
add_library(ReactAndroid::react_codegen_rncore SHARED IMPORTED)
set_target_properties(ReactAndroid::react_codegen_rncore PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_codegen_rncore/libs/android.x86/libreact_codegen_rncore.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_codegen_rncore/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_debug)
add_library(ReactAndroid::react_debug SHARED IMPORTED)
set_target_properties(ReactAndroid::react_debug PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_debug/libs/android.x86/libreact_debug.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_debug/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_nativemodule_core)
add_library(ReactAndroid::react_nativemodule_core SHARED IMPORTED)
set_target_properties(ReactAndroid::react_nativemodule_core PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_nativemodule_core/libs/android.x86/libreact_nativemodule_core.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_nativemodule_core/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_newarchdefaults)
add_library(ReactAndroid::react_newarchdefaults SHARED IMPORTED)
set_target_properties(ReactAndroid::react_newarchdefaults PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_newarchdefaults/libs/android.x86/libreact_newarchdefaults.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_newarchdefaults/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_animations)
add_library(ReactAndroid::react_render_animations SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_animations PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_animations/libs/android.x86/libreact_render_animations.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_animations/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_componentregistry)
add_library(ReactAndroid::react_render_componentregistry SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_componentregistry PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_componentregistry/libs/android.x86/libreact_render_componentregistry.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_componentregistry/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_core)
add_library(ReactAndroid::react_render_core SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_core PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_core/libs/android.x86/libreact_render_core.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_core/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_debug)
add_library(ReactAndroid::react_render_debug SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_debug PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_debug/libs/android.x86/libreact_render_debug.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_debug/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_graphics)
add_library(ReactAndroid::react_render_graphics SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_graphics PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_graphics/libs/android.x86/libreact_render_graphics.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_graphics/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_imagemanager)
add_library(ReactAndroid::react_render_imagemanager SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_imagemanager PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_imagemanager/libs/android.x86/libreact_render_imagemanager.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_imagemanager/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_mapbuffer)
add_library(ReactAndroid::react_render_mapbuffer SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_mapbuffer PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_mapbuffer/libs/android.x86/libreact_render_mapbuffer.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_mapbuffer/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_mounting)
add_library(ReactAndroid::react_render_mounting SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_mounting PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_mounting/libs/android.x86/libreact_render_mounting.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_mounting/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_scheduler)
add_library(ReactAndroid::react_render_scheduler SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_scheduler PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_scheduler/libs/android.x86/libreact_render_scheduler.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_scheduler/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::react_render_uimanager)
add_library(ReactAndroid::react_render_uimanager SHARED IMPORTED)
set_target_properties(ReactAndroid::react_render_uimanager PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_uimanager/libs/android.x86/libreact_render_uimanager.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/react_render_uimanager/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::reactnativejni)
add_library(ReactAndroid::reactnativejni SHARED IMPORTED)
set_target_properties(ReactAndroid::reactnativejni PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/reactnativejni/libs/android.x86/libreactnativejni.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/reactnativejni/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::rrc_image)
add_library(ReactAndroid::rrc_image SHARED IMPORTED)
set_target_properties(ReactAndroid::rrc_image PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/rrc_image/libs/android.x86/librrc_image.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/rrc_image/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::rrc_root)
add_library(ReactAndroid::rrc_root SHARED IMPORTED)
set_target_properties(ReactAndroid::rrc_root PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/rrc_root/libs/android.x86/librrc_root.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/rrc_root/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::rrc_view)
add_library(ReactAndroid::rrc_view SHARED IMPORTED)
set_target_properties(ReactAndroid::rrc_view PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/rrc_view/libs/android.x86/librrc_view.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/rrc_view/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::runtimeexecutor)
add_library(ReactAndroid::runtimeexecutor SHARED IMPORTED)
set_target_properties(ReactAndroid::runtimeexecutor PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/runtimeexecutor/libs/android.x86/libruntimeexecutor.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/runtimeexecutor/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::turbomodulejsijni)
add_library(ReactAndroid::turbomodulejsijni SHARED IMPORTED)
set_target_properties(ReactAndroid::turbomodulejsijni PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/turbomodulejsijni/libs/android.x86/libturbomodulejsijni.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/turbomodulejsijni/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET ReactAndroid::yoga)
add_library(ReactAndroid::yoga SHARED IMPORTED)
set_target_properties(ReactAndroid::yoga PROPERTIES
    IMPORTED_LOCATION "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/yoga/libs/android.x86/libyoga.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/rodrigobertolotti/.gradle/caches/transforms-3/524c60072bcd5ecc90651ecae64adfe4/transformed/jetified-react-android-0.71.4-debug/prefab/modules/yoga/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

