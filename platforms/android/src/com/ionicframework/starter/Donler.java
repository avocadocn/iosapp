/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
 */

package com.ionicframework.starter;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import org.apache.cordova.*;

import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushManager;
//import com.cmpsoft.mobile.plugin.pushnotification.LoginActivity;
import com.cmpsoft.mobile.plugin.pushnotification.Utils;

public class Donler extends CordovaActivity 
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        super.init();
        // Set by <content src="index.html" /> in config.xml
        super.loadUrl(Config.getStartUrl());
        //super.loadUrl("file:///android_asset/www/index.html");
        parameter.CONTEX = getApplicationContext();
        if (!Utils.hasBind(getApplicationContext())) {
            PushManager.startWork(getApplicationContext(),
                PushConstants.LOGIN_TYPE_API_KEY,
                Utils.getMetaValue(Donler.this, "api_key"));
        }
    }
}

