/*
 * Copyright (C) 2012 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef DEVICE_PERMS_H
#define DEVICE_PERMS_H

#define PROPERTY_PERMS_APPEND \
    { "hw.fm.",           AID_FM_RADIO,  0 }, \
    { "wifi.",            AID_WIFI,     0 },

#define CONTROL_PERMS_APPEND \
    { "fm_dl", AID_FM_RADIO, AID_FM_RADIO}, \
    { "wifi-sdio-on",AID_WIFI, 0 }, \
    { "ril-daemon1",AID_RADIO, AID_RADIO }, \
    { "ril-daemon2",AID_RADIO, AID_RADIO },

#endif /* DEVICE_PERMS_H */
