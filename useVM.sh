#!/bin/bash
WODEN_SRC_TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

VM_NAME="$1"
if test ! -e "$VM_NAME"; then
    echo "useVM.sh <VMName>"
    exit 1
fi

cat > "$WODEN_SRC_TOP/woden.sh" <<EOF
#!/bin/sh
TOP="\$( cd "\$( dirname "$0" )" && pwd )"

OS="\$(uname)"
if test "\$OS" = "Darwin"; then
    export DYLD_LIBRARY_PATH="\$TOP:\$DYLD_LIBRARY_PATH"
else
    export LD_LIBRARY_PATH="\$TOP:\$LD_LIBRARY_PATH"
fi

exec $VM_NAME \$@
EOF

chmod +x "$WODEN_SRC_TOP/woden.sh"
