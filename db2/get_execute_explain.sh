#!/bin/bash

function help() {
  cat << "__EOF__"

  get_execute_explain.sh
  ============

  Description:
    DB2の実行計画を取得する

  Usage:
    $1 対象SQLファイル
    $2 出力対象ファイル

  Remarks:
    環境変数 ${DB2_DBNAME} ${DB2_USER} ${DB2_PASSWORD} が定義されている必要がある
__EOF__
  exit 1
}

function connect_db() {
  db2 connect to ${DB2_DBNAME} user ${DB2_USER} using ${DB2_PASSWORD}
}

function exec_sql() {
  db2 set current explain mode explain
  db2 -tvf ${target_sql}
  db2 set current explain mode no
}

function output_result() {
  db2exfmt -1 -d ${DB2_DBNAME} -o ${output_file}
}

# start
if [ -z ${DB2_DBNAME} ] && [ -z ${DB2_USER} ] && [ -z ${DB2_PASSWORD} ]; then
  echo 'environment variables are not defined'
  help
fi

# parameter check
if [ $# -ne 2 ]; then
  echo 'parameter is invalid'
  help
fi
target_sql=$1
output_file=$2

connect_db
exec_sql
output_result
