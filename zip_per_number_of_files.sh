#!/bin/bash

function help() {
  cat << __EOF__

  $0
  ============

  Description:
    指定されたファイル数毎にzip形式にてファイル圧縮を行う

  Usage:
    $0 [-h]
    \$1 出力ファイル名 (出力ファイル名[連番]の形で出力)
    \$2 一つのzipファイルに含めるファイル数
    \$3... 圧縮対象ファイル

  Options:
    -h: ヘルプを表示
__EOF__
  exit 1
}

function read_output_filename() {
  outDirectory=$(dirname ${outputFile})
  outFilename=$(basename ${outputFile})
  outFileRoot=${outFilename%.*}
  outFileSuffix=${outFilename##*.}
}

function exec_zip() {
  # make array by target files
  targetFiles=($(echo ${fileSearchConditions}))

  # make archive
  archiveTargetFiles=()
  fileIndex=1

  for i in $(seq 1 ${#targetFiles[@]})
  do
    archiveTargetFiles+=(${targetFiles[$i-1]})

    if [ $(( $i % ${fileCountPerZip} )) -eq 0 ]; then
      zip ${outDirectory}/${outFileRoot}${fileIndex}.${outFileSuffix} ${archiveTargetFiles[@]}
      archiveTargetFiles=()
      (( fileIndex++ ))
    fi
  done

  if [ ${#targetFiles[@]} -ne 0 ]; then
    zip ${outDirectory}/${outFileRoot}${fileIndex}.${outFileSuffix} ${archiveTargetFiles[@]}
    archiveTargetFiles=()
    (( fileIndex++ ))
  fi
}

# option
while getopts :h OPT
do
  case ${OPT} in
  h)
    shift
    help
    ;;
  esac
done

# parameters
if [ $# -lt 3 ]; then
  echo 'parameter is invalid'
  help
fi
outputFile=$1
fileCountPerZip=$2
shift
shift
fileSearchConditions="$@"

# prepare
read_output_filename
# exec
exec_zip
