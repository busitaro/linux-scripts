#!/bin/bash

function help() {
  cat << __EOF__

  $0
  ============

  Description:
    指定ディレクトリに一定期間ごとに、
    指定処理を行う

  Usage:
    \$1 処理対象ディレクトリ
    \$2 処理インターバル(秒)
    \$3 実行処理(sh)
    \$4... 実行所理のパラメータ

  Options:
    -h: ヘルプを表示
__EOF__
  exit 1
}

function check_path() {
  if [ ! -e ${path} ]; then
    echo "The Folder ${path} is not exists!!"
    exit 1
  fi
}

function check_interval() {
  if ! expr "${interval}" : "[0-9]*$" > /dev/null; then
    echo "Interval must be number!!"
    exit 1
  fi
}

function check_exec() {
  if [ ! -e ${exec} ]; then
    echo 'Shell Script is not exists!!'
  fi
}

function monitor() {
  # シェルの絶対パスを取得
  local shPath=`readlink -f ${exec}` 
  # ディレクトリ移動
  cd ${path}

  while :;do
    sh ${shPath} ${params}
    sleep ${interval}
  done
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
  echo 'parameters are needed'
  help
fi
path=$1
interval=$2
exec=$3
shift 3
params=$@

# parameters check
check_path
check_interval
check_exec

# exec
monitor
