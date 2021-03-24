# git push 

function exit_script() {   
	echo "\033[31m exit script!"                                                   
    exit 1                                                                    
}

COMMIT_MSG=$1
echo "\033[32m commit message is $COMMIT_MSG"
if [ ! -n "$COMMIT_MSG" ] ;then
 echo "\033[31m you have not input a commit message!"
 exit_script
fi 
echo $(date)
echo "commmit：$COMMIT_MSG";
echo "=========start push========="
open /Applications/ClashX.app
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
#执行的时候是 ./git.sh来执行的，这样执行的话终端会产生一个 子shell，子shell去执行我的脚本，在子shell中已经切换了目录了，但是子shell一旦执行完，马上退出，子shell中的变量和操作全部都收回。回到终端根本就看不到这个过程的变化。
#或者用source git.sh 来执行
pushd ~/Desktop/TMUIKit
git add .
git commit -m "$1"
git push origin main
echo "=========push finish========="
popd
