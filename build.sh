#!/bin/bash

# 每日饮食记录应用构建脚本

echo "开始构建每日饮食记录应用..."

# 创建构建目录
mkdir -p build
cd build

# 运行CMake配置
echo "配置CMake..."
cmake -DCMAKE_PREFIX_PATH=/Users/benjamin/Qt/6.8.3/macos ..

# 检查CMake配置是否成功
if [ $? -eq 0 ]; then
    echo "CMake配置成功，开始编译..."
    
    # 编译项目
    make -j$(sysctl -n hw.ncpu)
    
    if [ $? -eq 0 ]; then
        echo "编译成功！"
        echo "可执行文件位置: build/appdaily_diet"
        echo ""
        echo "运行应用:"
        echo "./appdaily_diet"
    else
        echo "编译失败！"
        exit 1
    fi
else
    echo "CMake配置失败！"
    exit 1
fi 