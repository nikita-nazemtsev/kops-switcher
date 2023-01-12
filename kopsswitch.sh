#!/bin/bash

mkdir -p ~/.kops/bin/
mkdir -p ~/.kops/releases

kopsswitch_file=`pwd`/kopsswitch.txt

if test -f "$kopsswitch_file"; then
  VERSION=`cat $kopsswitch_file`
  echo "Reading version from kopsswitch.txt file. Version: $VERSION"
else
  if [ -z "$1" ]; then
    echo "Using: kopsswitch [version]"
    echo "Versions example: 1.25.2, 1.24.2"
    exit 1
  else 
    VERSION=$1
  fi
fi

if test -f ~/.kops/arch; then
  arch=`cat ~/.kops/arch`
else
  echo "Set architecture [amd64 or arm64]"
  read -p 'Arch:' arch
  if [ "$arch" == "amd64" ] || [ "$arch" == "arm64" ]; then
    echo $arch > ~/.kops/arch
  else
    echo "Not valid arch. Exiting"
    exit 1
  fi
fi

if test -f ~/.kops/platform; then
  platform=`cat ~/.kops/platform`
else
  echo "Set platform [linux or darwin]"
  read -p 'Platform:' platform
  if [ "$platform" == "linux" ] || [ "$platform" == "darwin" ]; then
    echo $platform > ~/.kops/platform
  else
    echo "Not valid platform. Exiting"
    exit 1
  fi
fi

kops_bin=kops_${platform}_${VERSION}

if test -f ~/.kops/releases/$kops_bin; then
  rm ~/.kops/bin/kops
  ln -s ~/.kops/releases/$kops_bin ~/.kops/bin/kops
  echo "Version currently selected: v$VERSION"
else
  download_url=https://github.com/kubernetes/kops/releases/download/v$VERSION/kops-${platform}-${arch}
  response=$(curl --write-out '%{http_code}' --silent --output /dev/null $download_url)
  if [ "$response" == "404" ];then
    echo "No such version"
    exit 1
  fi
  echo "Downloading version $VERSION."
  wget -q $download_url -O /tmp/$kops_bin
  mv /tmp/$kops_bin ~/.kops/releases/$kops_bin
  chmod +x ~/.kops/releases/$kops_bin
  rm -f ~/.kops/bin/kops
  ln -s ~/.kops/releases/$kops_bin ~/.kops/bin/kops
  echo "Version currently selected: v$VERSION"
fi
