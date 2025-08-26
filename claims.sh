#!/bin/bash

FILE_DIR="$(dirname "$0")"
FILE_PATH="$FILE_DIR/requests.txt"
content=$(< $FILE_PATH)

# 删除反斜杠+换行+空白
processed=$(echo "$content" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\\\n[[:space:]]*//g')

# 按行分割并过滤空行
IFS=$'\n' read -d '' -ra parts <<< "$processed"

# 遍历并输出每行
for ((i=0; i<${#parts[@]}; i++)); do
    command="${parts[$i]}"
    if [ -n "$command" ]; then
        echo "执行中..."
        echo "$command"
        echo ""
        resp=$(eval "$command")
        echo "响应内容:"
        echo "$resp"
        echo ""

        t=$(date "+%Y-%m-%d %H:%M:%S")
        if echo "$resp" | jq empty >/dev/null 2>&1; then
            echo "JSON解析成功"
            if echo "$resp" | jq -e '.success' >/dev/null 2>&1; then
                v=$(echo "$resp" | jq -r '.response.reward_list[0].value')
                echo -e "[$t] 领取成功：$v"
            else
                echo -e "[$t] 领取失败"
                echo "抓包数据已过期, 将重置$FILE_PATH文件"
                cat "$FILE_DIR/example_requests.txt" > "$FILE_PATH"
                break
            fi
        else
            echo "[$t] JSON解析失败"
        fi
        echo ""
        echo "----------------------------------------"
        sleep 2
    fi
done