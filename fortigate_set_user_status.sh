#!/bin/sh

function help() {
  cat << __EOF__

  $0
  ============

  Description:
    FortiGateにtelnet接続し、
    指定ユーザのstatusを設定する

  Usage:
    \$1 設定するステータス("enable" or "disable")
    \$2... 設定を実施するユーザID

  Remark:
    以下の環境変数が必要
    FORTIGATE_ADDRESS: "address_of_fortigate"
    FORTIGATE_USER: "user_of_forigate"
    FORTIGATE_PASSWORD: "password_of_fortigate"
    FORTIGATE_PROMPT: "prompt_fo_fortigate"

  Options:
    -h: ヘルプ表示
__EOF__
  exit 1
}

function check_status() {
  if [ "$status" != "enable" -a "$status" != "disable" ]; then
    echo "specify \"enable\" or \"disable\" for status."
    exit 1
  fi
}

function set_status_by_telnet() {
  # 実行コマンドを生成
  command=$(cat << EOF
    spawn telnet ${FORTIGATE_ADDRESS} 23;
    expect "login:";
    send "${FORTIGATE_USER}\n";
    expect "Password:";
    send "${FORTIGATE_PASSWORD}\n";
    expect "${FORTIGATE_PROMPT} $ ";
EOF
  )
  for user in $users
  do
    command+=$(cat << EOF
      send "config user local\n";
      expect "${FORTIGATE_PROMPT} (local) $ ";
      send "edit ${user}\n";
      expect "${FORTIGATE_PROMPT} (${user}) $ ";
      send "set status ${status}\n";
      expect "${FORTIGATE_PROMPT} (${user}) $ ";
      send "end\n";
      expect "${FORTIGATE_PROMPT} $ ";
EOF
    )
  done

  expect -c "${command}"
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
# check the number of parameters
if [ $# -lt 2 ]; then
  echo 'parameters are missing'
  help
fi
status=$1
shift
users=$@

# parmaters check
check_status

# exec
set_status_by_telnet
