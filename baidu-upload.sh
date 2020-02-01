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


uploadbaidu $1
