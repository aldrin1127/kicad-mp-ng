#!/bin/bash -e
_work_dir="$(pwd)"
_sources_dir="${_work_dir}/sources"

! [ -d "${_sources_dir}" ] && mkdir -p "${_sources_dir}"

clone_data="$(cat "${_work_dir}"/clones.json)"
printf "${clone_data}" | jq -c '.[] | {name: .name, url: .url}' | while read -r line; do
    name="$(printf "${line}" | jq -r '.name')"
    url="$( printf "${line}" | jq -r '.url' )"
    echo "${name}: ${url}"
done

# _platform="${1}"
# case "${_platform}" in
#     android)
# 	  _arch="${2}"
# 	  case "${_arch}" in
#	      aarch64) arch="aarch64"   ;;
#	      x86_64)  arch="x86_64" ;;
#	  esac
#         ;;
#     apple)
#	  _flavor="${3}"
#	  case "${_flavor}" in
#	      ios)    flavor=""
#	      ipados) 
#	      esac
#	  ;;
# esac

# if   [[ "${_platform}" == "android" ]]; then
#     "${_work_dir}"/android/build.sh "${arch}"
# elif [[ "${_platform}" == "apple"   ]]; then
#     "${_work_dir}"/apple/build.sh   "${arch}"
# fi

_arch="${1}"
"${_work_dir}"/android/build.sh "${_arch}"
