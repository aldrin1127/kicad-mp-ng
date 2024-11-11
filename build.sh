#!/bin/bash -e
_work_dir="$(pwd)"
_dl_dir="${_work_dir}/.dl"
_sources_dir="${_work_dir}/sources"

! [ -d "${_dl_dir}"      ] && mkdir -p "${_dl_dir}"
! [ -d "${_sources_dir}" ] && mkdir -p "${_sources_dir}"

rm -rf "${_sources_dir}/dl"
dl_data="$(cat "${_work_dir}"/dls.json)"
printf "${dl_data}" | jq -c '.[] | {name: .name, url: .url, filename: .filename}' | while read -r line; do
    name="$(    printf "${line}" | jq -r      '.name')"
    url="$(     printf "${line}" | jq -r       '.url')"
    filename="$(printf "${line}" | jq -r  '.filename')"
    if ! [ -f "${_dl_dir}/${filename}" ]; then
      echo "Downloading ${name}..."
      wget -q -O "${_dl_dir}/${filename}" "${url}"
    fi
    ! [ -d "${_sources_dir}/dl/${name}" ] && mkdir -p "${_sources_dir}/dl/${name}"
    echo "Extracting ${name}..."
    tar -xf "${_dl_dir}/${filename}" -C "${_sources_dir}/dl/${name}" --strip-components=1
done

clone_data="$(cat "${_work_dir}"/clones.json)"
printf "${clone_data}" | jq -c '.[] | {name: .name, url: .url}' | while read -r line; do
    name="$(printf "${line}" | jq -r '.name')"
    url="$( printf "${line}" | jq -r  '.url')"
    echo "Cloning ${name}..."
    git clone --depth=1 "${url}" "${_sources_dir}/clone/${name}" > /dev/null 2>&1
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
