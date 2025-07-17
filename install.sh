Nội dung cho file install.sh
#!/bin/bash
#
# Trình cài đặt tự động cho Công cụ Quản lý Proxy
# Tác giả:  phandong9999
# Phiên bản: 1.1 (Sửa lỗi vòng lặp nhập key)
#

# --- CẤU HÌNH ---
# URL trỏ đến file "quanlyproxy" đã được biên dịch trên GitHub của bạn
readonly TOOL_URL="https://raw.githubusercontent.com/code17072025/vv66/main/quanlyproxy"
# Đường dẫn cài đặt công cụ trên máy khách
readonly INSTALL_PATH="/usr/local/bin/quanlyproxy"

# --- Bảng màu ---
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_RESET='\033[0m'

# --- Hàm chính ---
main() {
    # Kiểm tra quyền root
    if [[ $EUID -ne 0 ]]; then
       echo -e "${COLOR_RED}Lỗi: Vui lòng chạy script này với quyền root hoặc sudo.${COLOR_RESET}"
       exit 1
    fi

    clear
    echo -e "${COLOR_YELLOW}=====================================================${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}==  Bắt đầu quá trình cài đặt công cụ quản lý proxy  ==${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}=====================================================${COLOR_RESET}"
    echo ""

    # 1. Cài đặt các gói phụ thuộc cần thiết
    echo -e "${COLOR_YELLOW}--> Bước 1: Cài đặt các gói phụ thuộc...${COLOR_RESET}"
    apt-get update >/dev/null 2>&1
    
    # Cấu hình trước để iptables-persistent không hỏi
    echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections
    echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections
    
    local required_packages=("wget" "curl" "jq" "iptables" "sqlite3" "coreutils" "gawk" "bc" "iptables-persistent")
    if ! DEBIAN_FRONTEND=noninteractive apt-get install -y "${required_packages[@]}" >/dev/null 2>&1; then
        echo -e "${COLOR_RED}LỖI: Không thể cài đặt các gói cần thiết. Vui lòng chạy 'sudo apt-get update' và thử lại.${COLOR_RESET}"
        exit 1
    fi
    echo -e "${COLOR_GREEN}Cài đặt gói phụ thuộc thành công.${COLOR_RESET}"

    # 2. Tải file thực thi từ GitHub
    echo -e "${COLOR_YELLOW}--> Bước 2: Tải công cụ chính...${COLOR_RESET}"
    if ! curl -sL "$TOOL_URL" -o "$INSTALL_PATH"; then
        echo -e "${COLOR_RED}LỖI: Tải công cụ thất bại. Vui lòng kiểm tra lại đường dẫn trên GitHub.${COLOR_RESET}"
        exit 1
    fi
    echo -e "${COLOR_GREEN}Tải công cụ thành công, đã lưu tại: $INSTALL_PATH${COLOR_RESET}"

    # 3. Cấp quyền thực thi
    echo -e "${COLOR_YELLOW}--> Bước 3: Cấp quyền thực thi...${COLOR_RESET}"
    chmod +x "$INSTALL_PATH"
    echo -e "${COLOR_GREEN}Cấp quyền thành công.${COLOR_RESET}"

    # 4. Hoàn tất
    echo ""
    echo -e "${COLOR_GREEN}=====================================================${COLOR_RESET}"
    echo -e "${COLOR_GREEN}  CÀI ĐẶT HOÀN TẤT!                                ${COLOR_RESET}"
    echo -e "${COLOR_GREEN}=====================================================${COLOR_RESET}"
    echo ""
    echo -e "Bạn có thể chạy công cụ từ bất kỳ đâu bằng lệnh:"
    echo -e "  ${COLOR_YELLOW}sudo quanlyproxy${COLOR_RESET}"
    echo ""
}

# Bắt đầu thực thi hàm main
main

