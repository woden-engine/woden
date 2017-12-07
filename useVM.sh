#!/bin/bash
WODEN2_SRC_TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

VM_NAME="$1"
if test ! -e "$VM_NAME"; then
    echo "useVM.sh <VMName>"
    exit 1
fi

cat > "$WODEN2_SRC_TOP/woden2.sh" <<EOF
#!/bin/sh
TOP="\$( cd "\$( dirname "$0" )" && pwd )"

OS="\$(uname)"
if test "\$OS" = "Darwin"; then
    export DYLD_LIBRARY_PATH="\$TOP/native-libraries-32:\$TOP/native-libraries-64:\$DYLD_LIBRARY_PATH"
else
    export LD_LIBRARY_PATH="\$TOP/native-libraries-32:\$TOP/native-libraries-64:\$LD_LIBRARY_PATH"
fi

exec $VM_NAME \$@
EOF

chmod +x "$WODEN2_SRC_TOP/woden2.sh"
