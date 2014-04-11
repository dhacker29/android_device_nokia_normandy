#!/system/bin/sh
#
# Copyright (c) 2013 Qualcomm Technologies, Inc.  All Rights Reserved.
# Qualcomm Technologies Proprietary and Confidential.
#
#Usage firmware must name in following format "<project_name>_<ic_name>_<module_ID>_ver<fw_version_ID>_app.bin"
#e.g. "skue_ft5316_0x51_ver0x13_app.bin "
#Currently supported project name available  "skue" "skud"
#All character in filename use lower case.
#---------Constant---------
readonly busybox="/data/busybox/busybox"
readonly hw_platform=`getprop ro.hw_platform`
readonly skuE_name='skue'
#readonly skuD_name='skud' #Not to update SKUD to compatible with old panel HW
readonly skuD_name=''
readonly file_postfix='app.bin'
readonly ft5x0x_debug='/mnt/debugfs/ft5x0x-debug/'
readonly fw_path='/system/etc/firmware/'
readonly version_pattern='ver0x??'
#---------Prepare---------
chmod 777 $busybox
#input keyevent 26
#sleep 1

#---------Get TP info---------
echo -n 0xa3>${ft5x0x_debug}read_register
ic_type=`cat ${ft5x0x_debug}read_register | $busybox cut -d "=" -f 2 | $busybox grep "0x[0-9,a-f]\{2\}" | $busybox cut -c 1-4`

echo -n 0xa6>${ft5x0x_debug}read_register
fw_version=`cat ${ft5x0x_debug}read_register | $busybox cut -d "=" -f 2 | $busybox grep "0x[0-9,a-f]\{2\}" | $busybox cut -c 1-4`

echo -n 0xa8>${ft5x0x_debug}read_register
module_type=`cat ${ft5x0x_debug}read_register | $busybox cut -d "=" -f 2 | $busybox grep "0x[0-9,a-f]\{2\}" | $busybox cut -c 1-4`

detect_gpio=`cat ${ft5x0x_debug}detection_pin`

#---------Construct FW file name search---------
#select firmeare file
case $hw_platform in
    "msm8x25q_skue")
        project_name=$skuE_name
        ;;
    "msm8x25q_skud")
        project_name=$skuD_name
        ;;
    *)
        project_name="unknown_project"
        ;;
esac

case $ic_type in
    "0x55")
      ic_name='ft5306i'
      ;;
    "0x0a")
      ic_name='ft5316'
      ;;
    *)
      ic_name='unknown_ic'
      ;;
esac

#case "$module_type" in
#    "0x80")
#      module_name='yeji'
#    "0x51")
#      module_name='ofilm'
#      ;;
#    "0x5a")
#      module_name='truly'
#      ;;
#    *)
#      module_name='unknown_module'
#      ;;
#esac

if [ "$module_type" = "0x00" ]; then
#Use gpio detection for skuE if cannot read moduel type from register
  case $hw_platform in
      "msm8x25q_skue")
          if [ "$detect_gpio" = "1" ]; then
            module_name='0x80'
          else
            module_name='0x51'
          fi
          ;;
      *)
          module_name=$module_type
          ;;
  esac
else
module_name=$module_type
fi


search_name="${project_name}_${ic_name}_${module_name}_${version_pattern}_${file_postfix}"

#---------Find newest firmware file and update if new version is available---------
echo seaching firmware "$search_name" from "$fw_path"
cd $fw_path
newest_fw_file=`$busybox find . -name "$search_name" | $busybox sort | $busybox tail -n 1`
newest_ver=${newest_fw_file##*ver}
newest_ver=${newest_ver:0:4}

if [ "$((16#${newest_ver:2:2}))" -gt "$((16#${fw_version:2:2}))" ]; then
  echo "Need update, use firmware file $newest_fw_file"
  echo -n $newest_fw_file > ${ft5x0x_debug}firmware_update
  cat ${ft5x0x_debug}firmware_update
else
  echo "No need to update"
fi
