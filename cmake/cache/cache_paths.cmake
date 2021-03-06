################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(cache/cache_sanitize_version)

function(_cpp_cache_get_recipe_path _ccgrp_path _ccgrp_cache _ccgrp_name)
    set(
        ${_ccgrp_path}
        ${_ccgrp_cache}/get_recipes/get-${_ccgrp_name}.cmake
        PARENT_SCOPE
    )
endfunction()

function(_cpp_cache_find_recipe_path _ccfrp_path _ccfrp_cache _ccfrp_name)
    set(
            ${_ccfrp_path}
            ${_ccfrp_cache}/find_recipes/find-${_ccfrp_name}.cmake
            PARENT_SCOPE
    )
endfunction()

function(_cpp_cache_build_recipe_path _ccbrp_output _ccbrp_cache _ccbrp_name)
    set(_ccbrp_filename build-${_ccbrp_name}.cmake)
    set(
            ${_ccbrp_output}
            ${_ccbrp_cache}/build_recipes/${_ccbrp_filename}
            PARENT_SCOPE
    )
endfunction()

function(_cpp_cache_recipe_path _ccrp_path _ccrp_type _ccrp_cache _ccrp_name)
    if("${_ccrp_type}" STREQUAL "FIND")
        set(
            ${_ccrp_path}
            ${_ccrp_cache}/find_recipes/find-${_ccrp_name}.cmake
            PARENT_SCOPE
        )
    elseif("${_ccrp_type}" STREQUAL "GET")
        set(
            ${_ccrp_path}
            ${_ccrp_cache}/get_recipes/get-${_ccrp_name}.cmake
            PARENT_SCOPE
        )
    elseif("${_ccrp_type}" STREQUAL "BUILD")
        set(
            ${_ccrp_path}
            ${_ccrp_cache}/build_recipes/build-${_ccrp_name}.cmake
            PARENT_SCOPE
        )
    else()
        _cpp_error(
            "Unrecognized recipe type: ${_ccrp_type}. "
            "Recognized types are: GET, FIND, BUILD."
        )
    endif()
endfunction()

function(_cpp_cache_tarball_path _cctp_output _cctp_cache _cctp_name _cctp_ver)
    _cpp_cache_sanitize_version(_cctp_eff_ver "${_cctp_ver}")
    #Return the result
    set(
        ${_cctp_output}
        ${_cctp_cache}/${_cctp_name}/${_cctp_name}.${_cctp_eff_ver}.tar.gz
        PARENT_SCOPE
    )
endfunction()

function(_cpp_cache_source_path _ccsp_path _ccsp_cache _ccsp_name _ccsp_version)
    _cpp_cache_tarball_path(
        _ccsp_tar_path ${_ccsp_cache} ${_ccsp_name} "${_ccsp_version}"
    )
    _cpp_does_not_exist(_ccsp_dne ${_ccsp_tar_path})
    if(_ccsp_dne)
        set(_cssp_temp ${_ccsp_path})
        set(${_ccsp_path} "${_cssp_temp}-NOTFOUND" PARENT_SCOPE)
        return()
    endif()
    file(SHA1 ${_ccsp_tar_path} _ccsp_src_hash)
    set(
        ${_ccsp_path}
        ${_ccsp_cache}/${_ccsp_name}/${_ccsp_src_hash}/source PARENT_SCOPE
    )
endfunction()


function(_cpp_cache_find_module_path _ccfmp_path _ccfmp_cache _ccfmp_name)
    set(
        ${_ccfmp_path}
        ${_ccfmp_cache}/find_recipes/modules/Find${_ccfmp_name}.cmake
        PARENT_SCOPE
    )
endfunction()



function(_cpp_cache_install_path _ccip_output _ccip_cache _ccip_name
                                 _ccip_version _ccip_tc)
    _cpp_cache_source_path(
       _ccip_src ${_ccip_cache} ${_ccip_name} "${_ccip_version}"
    )
    _cpp_contains(_ccip_src_dne "NOTFOUND" "${_ccip_src}")
    if(_ccip_src_dne)
        set(${_ccip_output} "${_ccip_output}-NOTFOUND" PARENT_SCOPE)
        return()
    endif()

    get_filename_component(_ccip_src ${_ccip_src} DIRECTORY)
    file(SHA1 ${_ccip_tc} _ccip_tc_hash)
    set(
        ${_ccip_output}
        ${_ccip_src}/${_ccip_tc_hash}
        PARENT_SCOPE
    )
endfunction()
