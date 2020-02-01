############################################################
#  brief:upload file to baidu
#  date :2020-01-30
############################################################
function uploadbaidu {
  dt="$1"
  #tar
  echo "tar ${dt} file"
  cd /home/stock/stockdata/ && tar -cvf ${dt}.tar ${dt}

  #upload to baidu
  echo "upload  /home/stock/stockdata/${dt}"
  /home/stock/baidu/BaiduPCS-Go upload /home/stock/stockdata/${dt}.tar /stockdata

  #delete local tar file
  rm -f /home/stock/stockdata/${dt}.tar

}


startdate="20190709"
while [ "$curdate" != "20200129" ]
do
   curdate=`date -d"${startdate} 1 days" +"%Y%m%d"|awk '{printf($1)}'`
   startdate="$curdate"

   if [ -d /home/stock/stockdata/$curdate ];then
      uploadbaidu $curdate
   else
      echo "$curdate dir not exists."
   fi

done
