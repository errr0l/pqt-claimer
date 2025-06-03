#!/bin/bash

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

FILE_PATH="$SCRIPT_DIR/requests.txt"

if [ ! -f "$FILE_PATH" ]; then
    echo "requests.txt 文件不存在: $FILE_PATH"
    exit 1
fi

content=$(<"$FILE_PATH")

# 将内容按 "&&" 分割成数组
IFS='&&' read -r -d '' -a commands <<< "$content"

for cmd_block in "${commands[@]}"; do

    trimmed=$(echo "$cmd_block" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    [[ -z "$trimmed" ]] && continue

    command=$(echo "$trimmed" | tr -d '\\\n')

    echo "执行中..."
    echo "$command"
    echo ""
    resp=$(eval "$command")
    echo "响应内容:"
    echo "$resp"
    echo ""

    t=$(date "+%Y-%m-%d %H:%M:%S")
    if echo "$resp" | jq -e '.response.reward_list[0].value' >/dev/null 2>&1; then
        v=$(echo "$resp" | jq -r '.response.reward_list[0].value')
        echo -e "[$t] 领取成功：$v"
    else
        echo -e "[$t] 解析失败"
    fi
    echo "----------------------------------------"
    sleep 2
done