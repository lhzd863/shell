#a.sh
cur=1
while [ $cur -lt 1118 ]
do
   curv=`printf "%03d" $cur`
   if [ ! -f $curv.mp3 ];then
       wget http://pse.tt56w.com:8000/单田芳/单田芳_白眉大侠320清晰/5tps.com_单田芳_白眉大侠_$curv.mp3?10103851687289x1581524244x10103857817949-316df399fa27d72058009a29f7f98f56?3
       mv "5tps.com_单田芳_白眉大侠_$curv.mp3?10103851687289x1581524244x10103857817949-316df399fa27d72058009a29f7f98f56?3" $curv.mp3
   fi
   let cur+=1
done



#
nohup bash a.sh > run.log 2>&1 &
