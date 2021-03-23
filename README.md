
# git
```sh
# 下载
git clone https://github.com/LZRight123/BusinessComponents.git
git submodule update --init --recursive
# or
git clone --recursive https://github.com/LZRight123/BusinessComponents.git

# 添加子模块
git submodule add https://github.com/LZRight123/BusinessDeer.git

# 更新子模块
git submodule update --remote
```
## [Git submodule的坑](https://blog.devtang.com/2013/05/08/git-submodule-issues/)

# use
1. pod update BusinessComponents --no-repo-update
2. pod 'BusinessComponents', :path => '../BusinessComponents'

## 鹿管家公用组件
1. pod 'BusinessComponents/Deer', :git => 'https://github.com/LZRight123/BusinessComponents.git'