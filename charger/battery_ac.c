/*
 * Copyright (c) 2012, The Linux Foundation. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of The Linux Foundation nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <cutils/klog.h>

#define LOGE(x...) do { KLOG_ERROR("charger", x); } while (0)

int read_file_buffer(const char *file_path, char * buffer, int count)
{
    int rc;
    int fd = open(file_path, O_RDONLY);

    if (fd < 0) {
        LOGE("open file %s failed\n", file_path);
        return fd;
    }

    lseek(fd, 0, SEEK_SET);
    rc = read(fd, buffer, count);
    close(fd);

    if (rc >= 0 && rc < count){
        buffer[rc] = '\0';
    }else if (rc == count){
        buffer[rc - 1] = '\0';
    }

    return rc;
}

int is_usb_exist()
{
    char buffer[16];
    int rc = read_file_buffer("/sys/class/power_supply/usb/online", buffer, sizeof(buffer));

    if (rc < 0){
        return 0;
    }

    if (atoi(buffer) == 1) {
        return 1;
    } else {
        return 0;
    }
}

int is_ac_exist()
{
    char buffer[16];
    int rc = read_file_buffer("/sys/class/power_supply/ac/online", buffer, sizeof(buffer));

    if (rc < 0){
        return 0;
    }

    if (atoi(buffer) == 1) {
        return 1;
    } else {
        return 0;
    }
}

int is_unknown_exist()
{
    char buffer[16];
    int rc = read_file_buffer("/sys/class/power_supply/unknown/online", buffer, sizeof(buffer));

    if (rc < 0){
        return 0;
    }

    if (atoi(buffer) == 1) {
        return 1;
    } else {
        return 0;
    }
}
