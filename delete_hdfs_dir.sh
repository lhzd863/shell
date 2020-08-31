#!/bin/bash
######################################################################
#  brief :delete hdfs dir
#version :2020-08-06     create              liuhui
######################################################################
HDFS_FILESPOOL=/tmp

function main()
{
  #
  while read line
  do
      #blank string
      if [ ${#line} -lt 1 ];then
        continue
      fi
      #begin
      if [ `echo "${line}"|grep "^#"|wc -l|sed 's/ //g'` -gt 0 ];then
        continue
      fi
      if [ `echo "${line}"|awk -F ',' '{print NF}'|sed 's/ //g'` -ne 3 ];then
        echo "config columns not equal 3,ingore this line"
        continue
      fi      

      local batch_local_path=`echo "$line"|awk -F ',' '{printf("%s",$1)}'`
      local batch_local_keepdays=`echo "$line"|awk -F ',' '{printf("%s",$2)}'`
      local batch_local_pathtype=`echo "$line"|awk -F ',' '{printf("%s",$3)}'`
      
      echo "Directory:$batch_local_path"
      end_timestamp_s=0
      start_timestamp_s=0
      
      if [ "$batch_local_pathtype" == "dir" ]||[ "$batch_local_pathtype" == "file" ];then
        let batch_local_file_keep_s=$batch_local_keepdays*24*3600
        
        #local tmp_touch_file_tm=`date '+%Y%m%d%H%M%S'`
        #local tmp_touch_file_id=$RANDOM
        #local tmp_touch_file_name="test_touch_${tmp_touch_file_tm}_${tmp_touch_file_id}.txt"
        #
        #hadoop fs -touchz $HDFS_FILESPOOL/$tmp_touch_file_name
        #errquit $? "hadoop touchz file fail"
        #
        #local current_timestamp=`hadoop fs -ls $HDFS_FILESPOOL/$tmp_touch_file_name|tail -1|awk -F ' ' '{printf("%s %s:00",$6,$7)}'`
        #hadoop fs -rm -r -f -skipTrash $HDFS_FILESPOOL/$tmp_touch_file_name
        #
        #local current_date=`echo "${current_timestamp:0:10}"|sed 's/\-//g'|sed 's/\.//g'`
        current_timestamp=`date '+%Y-%m-%d %H:%M:%S'`
        end_timestamp_s=$(date +%s -d "$current_timestamp")
        let end_timestamp_s=$end_timestamp_s-$batch_local_file_keep_s
      elif [ "$batch_local_pathtype" == "dirfrom" ]||[ "$batch_local_pathtype" == "filefrom" ];then
        if [ ${#batch_local_keepdays} -ne 10 ];then
          echo "$batch_local_path from timestamp error."
          continue
        fi
        local current_timestamp="${batch_local_keepdays} 00:00:00"
        end_timestamp_s=$(date +%s -d "$current_timestamp")
      else
        echo "$batch_local_path type current not support."
        continue
      fi
      
      if [ "$batch_local_pathtype" == "dirfrom" ]||[ "$batch_local_pathtype" == "dir" ];then
        local cnt=0
        local batch_local_oldIFS=$IFS
        IFS=$'\n'
        
        local batch_local_file_lst=`hadoop fs -ls "$batch_local_path"|awk -F ' ' '{ if(length($0)>19) {printf("%s %s:00,%s\n",$6,$7,$8)}}'`
        for filename in $batch_local_file_lst
        do
            if [ "$filename" == "." ]||[ "$filename" == ".." ];then
               continue
            fi
            local batch_local_hdfs_ts=`echo "$filename"|awk -F ',' '{printf("%s",$1)}'`
            local batch_local_hdfs_file=`echo "$filename"|awk -F ',' '{printf("%s",$2)}'`
            local batch_local_hdfs_file_name=`echo "$batch_local_hdfs_file"|awk -F '/' '{printf("%s",$NF)}'`
        
            start_timestamp_s=$(date +%s -d "$batch_local_hdfs_ts")
            if [ $start_timestamp_s -gt $end_timestamp_s ];then
              continue
            fi
            let cnt+=1
            echo "delete hdfs $batch_local_hdfs_file $batch_local_hdfs_ts "
            #hadoop fs -rm -r -f -skipTrash "$batch_local_hdfs_file"
        done
        IF="$batch_local_oldIFS"
        echo "$batch_local_path delete file count [$cnt]" 
      elif [ "$batch_local_pathtype" == "filefrom" ]||[ "$batch_local_pathtype" == "file" ];then
        local current_timestamp=`hadoop fs -ls $batch_local_path|tail -1|awk -F ' ' '{printf("%s %s:00",$6,$7)}'`
        start_timestamp_s=$(date +%s -d "$current_timestamp")
        if [ $start_timestamp_s -gt $end_timestamp_s ];then
          continue
        fi
        let cnt+=1
        echo "delete hdfs $batch_local_path $current_timestamp "
        #hadoop fs -rm -r -f -skipTrash "$batch_local_path"
      else
        echo "$batch_local_path type current not support."
        continue      
      fi

  done</home/lbs/liuh/delete_hdfs_dir/delete_hdfs_dir.cfg

  return 0
}

main
