#!/system/bin/sh
# dump_lowinode_log.sh
# 导出内核中的 lowinode 调试日志到 /data/local/tmp
#
# 用法:
#   adb push dump_lowinode_log.sh /data/local/tmp/
#   adb shell su -c "sh /data/local/tmp/dump_lowinode_log.sh"

set -u

OUT_DIR="/data/local/tmp"
STAMP="$(date +%Y%m%d_%H%M%S 2>/dev/null || echo now)"
OUT_FILE="$OUT_DIR/lowinode_$STAMP.log"

if [ "$(id -u)" -ne 0 ]; then
    echo "必须 root 执行"
    exit 1
fi

mkdir -p "$OUT_DIR" 2>/dev/null || true

if dmesg >/dev/null 2>&1; then
    dmesg | grep 'lowinode:' > "$OUT_FILE"
else
    logcat -b kernel -d | grep 'lowinode:' > "$OUT_FILE"
fi

echo "日志已导出到: $OUT_FILE"
wc -l "$OUT_FILE" 2>/dev/null || true
