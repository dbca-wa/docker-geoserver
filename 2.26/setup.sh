#!/usr/bin/env bash
# Reinstall libjpeg-turbo with previous version
dpkg -r "libjpeg-turbo-official"
system_architecture=$(dpkg --print-architecture)
libjpeg_version=2.1.5.1
libjpeg_deb_name="libjpeg-turbo-official_${libjpeg_version}_${system_architecture}.deb"
libjpeg_deb="${resources_dir}/${libjpeg_deb_name}"
if [[ ! -f "${libjpeg_deb}" ]]; then
  curl -vfLo "${libjpeg_deb}" "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/${libjpeg_version}/${libjpeg_deb_name}"
fi

dpkg -i "${libjpeg_deb}"

pushd "${CATALINA_HOME}" || exit
