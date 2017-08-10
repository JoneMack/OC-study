#!/bin/bash
#该脚本主要更新测试版本列表的HTML文件


log_file='/opt/app/ios.log'
html_file='/opt/app/download/ios_history.html'
lastLog='/opt/app/lastLog'
reverse_log='/opt/app/reverse.ios.log'

#首先更新版本历史文件，版本历史包括三个字段：版本名，对应的commitId，版本注释

#获取文件名
appName=`ls target/`
#根据软件包获取版本名
#appName=styler_build_290_2013-11-09-16-53.ipa
versionName=${appName#*styler_build_}
versionName=${versionName%%.ipa*}

#获取当前版本的commitId
currentCommitId=`git log -1 --pretty=format:"%H"`

#获取自上一个测试版到当前的所有的代码提交注释，将其保存到lastLog文件中
#首先访问日志文件获取上一次的commitId，再获取上次commit到当前的版本注释
lastestLog=`tail -n 1 $log_file`
lastestCommitId=${lastestLog#*;}
lastestCommitId=${lastestCommitId%%;*}
last100Log=`git log -50 --pretty=format:"%H %s"`

rm -rf $lastLog
touch $lastLog
echo "$last100Log" | while read log  
do  
logCommitId=${log%% *}
logComment=${log#* }
if [ "$lastestCommitId" != "$logCommitId" ] ;then    
lastLogs="${lastLogs}${logComment};"
else
	echo -e "$lastLogs" >> $lastLog
break
fi
done


#追加版本日志
lastLogNote=`cat $lastLog`
if [ "$lastLogNote" != "" ] ;then
cat >> $log_file << END
$versionName;$currentCommitId;$lastLogNote
END
fi

function create_html_head(){  
    echo -e "<!DOCTYPE html>
             <html lang="zh-cn">
             <head>
             <meta http-equiv='Content-Type' content='text/html;charset=utf-8' />
             <body>
             <h1>历史版本</h1>
			 <ul>"  
}

function create_html_end(){  
    echo -e "</ul></body></html>"  
} 

#根据版本日志生成HTML文档
rm -rf $reverse_log
cat >> $reverse_log << END
`nl $log_file | sort -nr | cut -f2`
END

rm -rf $html_file
touch $html_file

create_html_head >> $html_file
while read line  
    do  
        #echo $line 
		versionName=${line%%;*}
		versionDescription=${line#*;}
		versionCommitId=${versionDescription%%;*}
		versionDescription=${versionDescription#*;}
		#echo $versionName
		echo -e "<li><a href='styler_build_${versionName}.ipa'>${versionName}</a>
				<p>$versionCommitId</p>
				<p>${versionDescription//;/<br/>}</p>
				</li>" >> $html_file 
    done < $reverse_log 
	
create_html_end >> $html_file





