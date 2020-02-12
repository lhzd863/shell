cur=1
while [ $cur -lt 1118 ]
do
   curv=`printf "%03d" $cur`
   wget http://177l.tt56w.com:8000/玄幻小说/剑道独尊/$curv.mp3?10103851686419x1581523374x10103857817079-8ff8f5cd62a86567ad4f5fc86147a970?3
   mv "$curv.mp3?10103851686419x1581523374x10103857817079-8ff8f5cd62a86567ad4f5fc86147a970?3" $curv.mp3
   let cur+=1
done
