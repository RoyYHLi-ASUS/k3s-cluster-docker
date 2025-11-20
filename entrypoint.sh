#!/bin/bash
#set -e

echo "=== K3s Ansible 安裝程序 ==="
echo ""

# 複製 playbook 到 host
cp /ansible/k3s_playbook.yml /host/tmp/k3s_playbook.yml
cp /ansible/vars.yml /host/tmp/vars.yml

echo "正在 host 命名空間中執行 Ansible..."

# 使用 nsenter 進入 host 的命名空間並執行 Ansible
nsenter --target 1 --mount --uts --ipc --net --pid -- bash -c "
    set -e
    # 確保在 host 上安裝 ansible（如果需要）
    if ! command -v ansible-playbook &> /dev/null; then
        echo '正在 host 上安裝 Ansible...'
        # 根據不同發行版安裝 ansible
        if command -v apt-get &> /dev/null; then
            apt-get update && apt-get install -y ansible
        elif command -v yum &> /dev/null; then
            yum install -y epel-release && yum install -y ansible
        elif command -v dnf &> /dev/null; then
            dnf install -y ansible
        elif command -v apk &> /dev/null; then
            apk add ansible
        else
            echo '錯誤: 無法自動安裝 Ansible'
            exit 1
        fi
    fi
    
    # 在 host 上執行 playbook
    cd /tmp
    ansible-playbook k3s_playbook.yml \
        --connection=local \
        --inventory localhost, \
        --extra-vars \"@/tmp/vars.yml\" \
        -v
"

EXIT_CODE=$?
#echo "Exit code: $EXIT_CODE"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Ansible Playbook execute success!"
    echo ""
    echo "=== you are all set ==="
    exit 0
else
    echo "❌ Ansible Playbook execute fail!error code: $EXIT_CODE"
    exit $EXIT_CODE
fi
