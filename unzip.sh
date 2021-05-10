#!/bin/bash

function help() {
  cat << __EOF__

  $0
  ============

  Description:
    指定ディレクトリ内の*.zipファイルを解凍する

  Usage:
    $0 [-h] [-p password] [-o output_path] [-d] target_directory
    \$1 処理対象ディレクトリ

  Options:
    -h: ヘルプを表示
    -p: zipファイルのパスワードを指定
    -o: 解凍先を指定
    -d: 元zipファイルを消す
__EOF__
  exit 1
}

function check_directory() {
  targetDirectory=$1
  if [ ! -e ${targetDirectory} ]; then
    echo "The Directory ${targetDirectory} is not exists!!"
    exit 1
  fi
}

function unzip() {
  if [ -n "${password}" ]; then
    opts="${opts} -p ${password}"
  fi

  if [ -n "${outputDir}" ]; then
    opts="${opts} -o ${outputDir}"
  fi

  find ${targetDir} -maxdepth 1 -type f -name '*.zip' | while read file
  do
    unar ${opts} -r "${file}"
    if [ -n "${DELETE_FILE}" ]; then
      rm -f "${file}"
    fi
  done
}

# option
while getopts :hp:o:d OPT
do
  case ${OPT} in
  h)
    help
    ;;
  p)
    password=${OPTARG}
    ;;
  o)
    outputDir=${OPTARG}
    ;;
  d)
    DELETE_FILE=1
    ;;
  esac
done
shift $(($OPTIND - 1))

# parameters
if [ $# -ne 1 ]; then
  echo 'parameter is invalid'
  help
fi
targetDir=$1

# parameters check
check_directory ${targetDir}
if [ -n "${outputDir}" ]; then
  check_directory ${outputDir}
fi

# exec
unzip
