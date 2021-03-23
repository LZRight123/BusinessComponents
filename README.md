
# git
```sh
git clone https://github.com/LZRight123/BusinessComponents.git
git submodule update --init --recursive
# or
git clone --recursive

# add
git submodule add https://github.com/LZRight123/BusinessDeer.git
```

# use
1. pod update BusinessComponents --no-repo-update
2. pod 'BusinessComponents', :path => '../BusinessComponents'

## 鹿管家公用组件
1. pod 'BusinessComponents/Deer', :git => 'https://github.com/LZRight123/BusinessComponents.git'