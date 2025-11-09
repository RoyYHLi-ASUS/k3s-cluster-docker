FROM alpine:latest

# 安裝 Ansible 和必要工具
RUN apk add --no-cache \
    ansible \
    python3 \
    py3-pip \
    openssh-client \
    curl \
    bash

# 創建工作目錄
WORKDIR /ansible

# 複製 playbook and vars
COPY playbooks/k3s_playbook.yml /ansible/k3s_playbook.yml
COPY ansible-vars-config/vars.yml /ansible/vars.yml

# 設置 Ansible 配置
RUN mkdir -p /etc/ansible && \
    echo "[defaults]" > /etc/ansible/ansible.cfg && \
    echo "host_key_checking = False" >> /etc/ansible/ansible.cfg && \
    echo "interpreter_python = auto_silent" >> /etc/ansible/ansible.cfg

# 入口腳本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
