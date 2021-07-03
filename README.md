
# git
```sh
# 下载
git clone https://github.com/LZRight123/BusinessComponents.git


# push
git add --all; git commit -m "update";git pull --rebase; git push


# push
git add --all; git commit -m "update";git pull; git push

```
## [Git submodule的坑](https://blog.devtang.com/2013/05/08/git-submodule-issues/)

# use
1. pod update BusinessComponents --no-repo-update
2. pod 'BusinessComponents', :path => '../BusinessComponents'
3. pod 'BusinessComponents/Deer', :git => 'https://github.com/LZRight123/BusinessComponents.git'

## 鹿管家公用组件
```pod
pod 'BusinessDeer', :path => '../BusinessComponents/BusinessDeer'
pod 'DeerLbs', :path => '../BusinessComponents/DeerLbs'
```