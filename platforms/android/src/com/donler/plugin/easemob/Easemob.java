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
package com.donler.plugin.easemob;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.easemob.EMCallBack;
import com.easemob.EMEventListener;
import com.easemob.EMNotifierEvent;
import com.easemob.EMValueCallBack;
import com.easemob.chat.EMChatManager;
import com.easemob.chat.EMContactManager;
import com.easemob.chat.EMChatOptions;
import com.easemob.chat.EMConversation;
import com.easemob.chat.EMGroup;
import com.easemob.chat.EMGroupManager;
import com.easemob.chat.EMMessage;
import com.easemob.chat.EMMessage.ChatType;
import com.easemob.chat.EMMessage.Type;
import com.easemob.chat.EMChat;
import com.easemob.chat.ImageMessageBody;
import com.easemob.chat.LocationMessageBody;
import com.easemob.chat.NormalFileMessageBody;
import com.easemob.chat.TextMessageBody;
import com.easemob.chat.VoiceMessageBody;
import com.easemob.exceptions.EaseMobException;
import com.easemob.util.VoiceRecorder;
import com.easemob.util.EMLog;
import com.easemob.util.EasyUtils;
import com.donler.plugin.easemob.HXNotifier;
import com.donler.plugin.easemob.HXNotifier.HXNotificationInfoProvider;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Handler;
import android.util.Log;

public class Easemob extends CordovaPlugin {
  private static final String TAG = "Easemob";
  private static int pagesize = 20;
  private static CallbackContext emchatCallbackContext = null;
  private static CordovaWebView webView = null;
  private static HXNotifier noifier = null;
  private VoiceRecorder voiceRecorder;
  private static ArrayList<String> eventQueue = new ArrayList<String>();
  protected static Boolean isInBackground = true;
  private static Activity mainActivity = null;
  private static Boolean deviceready = false;

  enum actionType {
    INIT, LOGIN, LOGOUT, CHAT, RECORDSTART, RECORDEND, RECORDCANCEL, GETMESSAGES, PAUSE, RESUME, GETUNREADMSGCOUNT, RESETUNRADMSGCOUNT, GETMSGCOUNT, CLEARCONVERSATION, DELETECONVERSATION, DELETEMESSAGE, GETGROUPS, GETGROUP, GETCONTACTS, ADDCONTACT, DELETECONTACT, SETTING,GETALLCONVERSATIONS
  }

  @SuppressLint("HandlerLeak")
  private Handler micImageHandler = new Handler() {
    @Override
    public void handleMessage(android.os.Message msg) {
      // 录音过程中的处理函数，what代表了音量大小
      Log.d("Easemob", msg.toString());
      fireEvent("Record", "{what:" + msg.what + "}");
      // micImage.setImageDrawable(micImages[msg.what]);
    }
  };

  /**
   * Sets the context of the Command. This can then be used to do things like
   * get file paths associated with the Activity.
   * 
   * @param cordova
   *            The context of the main Activity.
   * @param webView
   *            The CordovaWebView Cordova is running in.
   */
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    Easemob.webView = super.webView;
    mainActivity = cordova.getActivity();
  }

  /**
   * Executes the request and returns PluginResult.
   * 
   * @param action
   *            The action to execute.
   * @param args
   *            JSONArry of arguments for the plugin.
   * @param callbackContext
   *            The callback id used when calling back into JavaScript.
   * @return True if the action was valid, false if not.
   */
  public boolean execute(String action, JSONArray args,
      CallbackContext callbackContext) throws JSONException {

    Easemob.emchatCallbackContext = callbackContext;
    String target;
    EMConversation conversation;
    switch (actionType.valueOf(action.toUpperCase())) {
    case INIT:
      dealInit();
      break;
    case LOGIN:
      dealLogin(args);
      break;
    case LOGOUT:
      dealLogout();
      break;
    case CHAT:
      dealChat(args);
      break;
    case RECORDSTART:
      target = args.getString(0);
      voiceRecorder = new VoiceRecorder(micImageHandler);
      voiceRecorder.startRecording(null, target, cordova.getActivity()
          .getApplicationContext());
      break;
    case RECORDEND:
      if (voiceRecorder == null) {
        emchatCallbackContext.error("当前没有录音");
      } else {
        String chatType = args.getString(0);
        target = args.getString(1);
        // 获取到与聊天人的会话对象。参数username为聊天人的userid或者groupid，后文中的username皆是如此
        conversation = EMChatManager.getInstance().getConversation(
            target);
        int length = voiceRecorder.stopRecoding();
        if (length > 0) {
          sendVoice(conversation, chatType, target,
              voiceRecorder.getVoiceFilePath(),
              voiceRecorder.getVoiceFileName(target),
              Integer.toString(length), false);
        } else {
          emchatCallbackContext.error("录音时间过短");
        }
      }

      break;
    case RECORDCANCEL:
      if (voiceRecorder != null) {
        voiceRecorder.discardRecording();
        emchatCallbackContext.success("录音取消");
      } else {
        emchatCallbackContext.error("当前没有录音");
      }

      break;
    case GETMESSAGES:
      dealGetMessages(args);
      break;
    case PAUSE:
      isInBackground = true;
      try {
        // 停止录音
        if (voiceRecorder.isRecording()) {
          voiceRecorder.discardRecording();
        }
      } catch (Exception e) {
      }
      break;
    case RESUME:
      isInBackground = false;
      EMChatManager.getInstance().activityResumed();
      cordova.getThreadPool().execute(new Runnable() {
        public void run() {
          deviceready();
          if (noifier != null)
            noifier.reset();
        }
      });
      break;
    case GETUNREADMSGCOUNT:
      target = args.getString(0);
      conversation = EMChatManager.getInstance().getConversation(target);
      emchatCallbackContext.success(conversation.getUnreadMsgCount());
      break;
    case RESETUNRADMSGCOUNT:
      if (args.length() == 0) {
        EMChatManager.getInstance().resetAllUnreadMsgCount();
      } else {
        target = args.getString(0);
        conversation = EMChatManager.getInstance().getConversation(
            target);
        conversation.resetUnreadMsgCount();
      }
      emchatCallbackContext.success();
      break;
    case GETMSGCOUNT:
      target = args.getString(0);
      conversation = EMChatManager.getInstance().getConversation(target);
      emchatCallbackContext.success(conversation.getMsgCount());
      break;
    case CLEARCONVERSATION:
      target = args.getString(0);
      //清空和某个user的聊天记录(包括本地)，不删除conversation这个会话对象
      EMChatManager.getInstance().clearConversation(target);
      emchatCallbackContext.success();
      break;
    case DELETECONVERSATION:
      target = args.getString(0);
      // 删除和某个user的整个的聊天记录(包括本地)
      EMChatManager.getInstance().deleteConversation(target);
      emchatCallbackContext.success();
      break;
    case DELETEMESSAGE:
      target = args.getString(0);
      String msgId = args.getString(0);
      // 删除当前会话的某条聊天记录
      conversation = EMChatManager.getInstance().getConversation(target);
      conversation.removeMessage(msgId);
      emchatCallbackContext.success();
      break;
    case GETGROUPS:
      Boolean serverFlag = args.getBoolean(0);
      if (serverFlag) {
        EMGroupManager.getInstance().asyncGetGroupsFromServer(
            new EMValueCallBack<List<EMGroup>>() {
              @Override
              public void onSuccess(List<EMGroup> value) {
                emchatCallbackContext
                    .success(groupsToJson(value));
              }

              @Override
              public void onError(int error, String errorMsg) {
                emchatCallbackContext.error(errorMsg);
              }
            });
      } else {
        // 从本地加载群聊列表
        List<EMGroup> grouplist = EMGroupManager.getInstance()
            .getAllGroups();
        emchatCallbackContext.success(groupsToJson(grouplist));
      }

      break;
    case GETGROUP:
      target = args.getString(0);
      Boolean serverFlag1 = args.getBoolean(1);
      if (serverFlag1) {
        // 根据群聊ID从服务器获取群聊信息
        EMGroup group;
        try {
          group = EMGroupManager.getInstance().getGroupFromServer(
              target);
          emchatCallbackContext.success(groupToJson(group));
          // 保存获取下来的群聊信息
          EMGroupManager.getInstance()
              .createOrUpdateLocalGroup(group);
        } catch (EaseMobException e) {
          e.printStackTrace();
          emchatCallbackContext.success("获取群聊信息失败");
        }

      } else {
        // 根据群聊ID从本地获取群聊信息
        EMGroup group = EMGroupManager.getInstance().getGroup(target);
        // group.getMembers();//获取群成员
        // group.getOwner();//获取群主
        emchatCallbackContext.success(group.toString());
      }

      break;
    case GETCONTACTS:
      try {
        List<String> usernames = EMContactManager.getInstance()
            .getContactUserNames();// 需异步执行
        JSONArray mJSONArray = new JSONArray(usernames);
        emchatCallbackContext.success(mJSONArray);
      } catch (EaseMobException e) {
        emchatCallbackContext.error(e.toString());
      }
      break;
    case ADDCONTACT:
      try {
        target = args.getString(0);
        String reason;
        if (args.length() > 1) {
          reason = args.getString(1);
        } else {
          reason = "";
        }
        // 参数为要添加的好友的username和添加理由
        EMContactManager.getInstance().addContact(target, reason);// 需异步处理
        emchatCallbackContext.success("成功");
      } catch (EaseMobException e) {
        emchatCallbackContext.error(e.toString());
      }
      break;
    case DELETECONTACT:
      try {
        target = args.getString(0);
        EMContactManager.getInstance().deleteContact(target);// 需异步处理
        emchatCallbackContext.success("成功");
      } catch (EaseMobException e) {
        emchatCallbackContext.error(e.toString());
      }
      break;
    case SETTING:
      dealSetting(args);
      break;
    case GETALLCONVERSATIONS:
      dealGetConvarsations();
    default:
      return false;
    }
    return true;
    // return super.execute(action, args, callbackContext);
  }

  /**
   * 发送文本消息
   * 
   * @param content
   *            message content
   * @param isResend
   *            boolean resend
   */
  // private void sendText(String content) {

  // if (content.length() > 0) {
  // EMMessage message = EMMessage.createSendMessage(EMMessage.Type.TXT);
  // // 如果是群聊，设置chattype,默认是单聊
  // if (chatType == CHATTYPE_GROUP){
  // message.setChatType(ChatType.GroupChat);
  // }else if(chatType == CHATTYPE_CHATROOM){
  // message.setChatType(ChatType.ChatRoom);
  // }

  // TextMessageBody txtBody = new TextMessageBody(content);
  // // 设置消息body
  // message.addBody(txtBody);
  // // 设置要发给谁,用户username或者群聊groupid
  // message.setReceipt(toChatUsername);
  // // 把messgage加到conversation中
  // conversation.addMessage(message);
  // // 通知adapter有消息变动，adapter会根据加入的这条message显示消息和调用sdk的发送方法
  // adapter.refreshSelectLast();
  // mEditTextContent.setText("");

  // setResult(RESULT_OK);

  // }
  // }
  /**
   * 发送语音
   * 
   * @param filePath
   * @param fileName
   * @param length
   * @param isResend
   */
  private void sendVoice(EMConversation conversation, String chatType,
      String toChatUsername, String filePath, String fileName,
      String length, boolean isResend) {
    if (!(new File(filePath).exists())) {
      return;
    }
    try {
      final EMMessage message = EMMessage
          .createSendMessage(EMMessage.Type.VOICE);
      // 如果是群聊，设置chattype,默认是单聊
      if (chatType == "group") {
        message.setChatType(ChatType.GroupChat);
      } else if (chatType == "chatroom") {
        message.setChatType(ChatType.ChatRoom);
      }
      message.setReceipt(toChatUsername);
      int len = Integer.parseInt(length);
      VoiceMessageBody body = new VoiceMessageBody(new File(filePath),
          len);
      message.addBody(body);

      conversation.addMessage(message);
      // 发送消息
      EMChatManager.getInstance().sendMessage(message, new EMCallBack() {
        @Override
        public void onSuccess() {
          Log.d("main", "发送成功");
          emchatCallbackContext.success(messageToJson(message));
        }

        @Override
        public void onProgress(int progress, String status) {

        }

        @Override
        public void onError(int code, String errorMessage) {
          Log.d("main", "发送失败！");
          emchatCallbackContext.error(messageToJson(message));
        }
      });
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  /**
   * 发送图片
   * 
   * @param filePath
   */
  // private void sendPicture(final String filePath) {
  // String to = toChatUsername;
  // // create and add image message in view
  // final EMMessage message =
  // EMMessage.createSendMessage(EMMessage.Type.IMAGE);
  // // 如果是群聊，设置chattype,默认是单聊
  // if (chatType == CHATTYPE_GROUP){
  // message.setChatType(ChatType.GroupChat);
  // }else if(chatType == CHATTYPE_CHATROOM){
  // message.setChatType(ChatType.ChatRoom);
  // }

  // message.setReceipt(to);
  // ImageMessageBody body = new ImageMessageBody(new File(filePath));
  // // 默认超过100k的图片会压缩后发给对方，可以设置成发送原图
  // // body.setSendOriginalImage(true);
  // message.addBody(body);
  // conversation.addMessage(message);

  // listView.setAdapter(adapter);
  // adapter.refreshSelectLast();
  // setResult(RESULT_OK);
  // // more(more);
  // }

  /**
   * 发送视频消息
   */
  // private void sendVideo(final String filePath, final String thumbPath,
  // final int length) {
  // final File videoFile = new File(filePath);
  // if (!videoFile.exists()) {
  // return;
  // }
  // try {
  // EMMessage message = EMMessage.createSendMessage(EMMessage.Type.VIDEO);
  // // 如果是群聊，设置chattype,默认是单聊
  // if (chatType == CHATTYPE_GROUP){
  // message.setChatType(ChatType.GroupChat);
  // }else if(chatType == CHATTYPE_CHATROOM){
  // message.setChatType(ChatType.ChatRoom);
  // }
  // String to = toChatUsername;
  // message.setReceipt(to);
  // VideoMessageBody body = new VideoMessageBody(videoFile, thumbPath,
  // length, videoFile.length());
  // message.addBody(body);
  // conversation.addMessage(message);
  // listView.setAdapter(adapter);
  // adapter.refreshSelectLast();
  // setResult(RESULT_OK);
  // } catch (Exception e) {
  // e.printStackTrace();
  // }

  // }
  /**
   * Calls all pending callbacks after the deviceready event has been fired.
   */
  private static void deviceready() {
    deviceready = true;

    for (String js : eventQueue) {
      webView.sendJavascript(js);
    }

    eventQueue.clear();
  }

  /**
   * Fires the given event.
   * 
   * @param {String} event The Name of the event
   * @param {String} json A custom (JSON) string
   */
  public static void fireEvent(String event, String json) {
    String js = "setTimeout(easemob.on" + event + "(" + json + "),0)";
    if (deviceready == false) {
      eventQueue.add(js);
    } else {
      webView.sendJavascript(js);
    }
  }

  private void dealInit() {
    try {
      int pid = android.os.Process.myPid();
      String processAppName = getAppName(pid);
      // 如果app启用了远程的service，此application:onCreate会被调用2次
      // 为了防止环信SDK被初始化2次，加此判断会保证SDK被初始化1次
      // 默认的app会在以包名为默认的process name下运行，如果查到的process name不是app的process
      // name就立即返回
      if (processAppName == null
          || !processAppName.equalsIgnoreCase(cordova.getActivity()
              .getPackageName())) {
        Log.e(TAG, "enter the service process!");
        // 则此application::onCreate 是被service 调用的，直接返回
        return;
      }
      EMChat.getInstance().init(mainActivity);
      bindListener();
      // debug 模式开关
      EMChat.getInstance().setDebugMode(true);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  private void dealChat(JSONArray _args) {
    final JSONArray args = _args;
    cordova.getThreadPool().execute(new Runnable() {
      public void run() {
        String chatType, target, _contentType;
        JSONObject params, content, extend;
        Type contentType;
        final EMMessage message;
        try {
          params = args.getJSONObject(0);
          target = params.getString("target");
          EMConversation conversation = EMChatManager.getInstance()
              .getConversation(target);
          if (params.has("resend") && params.getBoolean("resend")) {
            String msgId = params.getString("msgId");
            message = conversation.getMessage(msgId);
            message.status = EMMessage.Status.CREATE;
          } else {
            chatType = params.getString("chatType");
            _contentType = params.getString("contentType");
            content = params.getJSONObject("content");
            contentType = EMMessage.Type.valueOf(_contentType
                .toUpperCase());
            // 获取到与聊天人的会话对象。参数username为聊天人的userid或者groupid，后文中的username皆是如此

            message = EMMessage.createSendMessage(contentType);
            // 如果是群聊，设置chattype,默认是单聊
            if (chatType.equals("group")) {
              message.setChatType(ChatType.GroupChat);
            }
            switch (contentType) {
            case VOICE:
              VoiceMessageBody voiceBody = new VoiceMessageBody(
                  new File(content.getString("filePath")),
                  content.getInt("len"));
              message.addBody(voiceBody);
              break;
            case IMAGE:
              String path;
              try {
                path = getRealPathFromURI(content
                    .getString("filePath"));
              } catch (Exception e) {
                emchatCallbackContext.error("发送失败！");
                return;
              }

              File file = new File(path);

              ImageMessageBody imageBody = new ImageMessageBody(
                  file);
              // 默认超过100k的图片会压缩后发给对方，可以设置成发送原图
              // body.setSendOriginalImage(true);
              message.addBody(imageBody);
              break;
            case LOCATION:
              LocationMessageBody locationBody = new LocationMessageBody(
                  content.getString("locationAddress"),
                  content.getDouble("latitude"), content
                      .getDouble("longitude"));
              message.addBody(locationBody);
              break;
            case FILE:
              NormalFileMessageBody fileBody = new NormalFileMessageBody(
                  new File(content.getString("filePath")));
              message.addBody(fileBody);
              break;
            case TXT:
            default:
              // 设置消息body
              TextMessageBody textBody = new TextMessageBody(
                  content.getString("text"));
              message.addBody(textBody);
              break;
            }
            if (params.has("extend")) {
              extend = params.getJSONObject("extend");
              message.setAttribute("extend", extend);
              // Iterator it = extend.keys();
              // while (it.hasNext()) {
              // String key = (String) it.next();
              // Object v = extend.get(key);
              // if (v instanceof Integer || v instanceof Long ||
              // v instanceof Float || v instanceof Double) {
              // int value = ((Number)v).intValue();
              // message.setAttribute(key, value);
              // } else if (v instanceof Boolean) {
              // boolean boolToUse = ((Boolean)v).booleanValue();
              // message.setAttribute(key, boolToUse);
              // } else {
              // String stringToUse = extend.getString(key);
              // message.setAttribute(key, stringToUse);
              // }

              // }
            }

            // 设置接收人
            message.setReceipt(target);
            // 把消息加入到此会话对象中
            conversation.addMessage(message);
          }

          // 发送消息
          EMChatManager.getInstance().sendMessage(message,
              new EMCallBack() {
                @Override
                public void onSuccess() {
                  Log.d("main", "发送成功");
                  emchatCallbackContext
                      .success(messageToJson(message));
                }

                @Override
                public void onProgress(int progress,
                    String status) {
                }

                @Override
                public void onError(int code,
                    String errorMessage) {
                  Log.d("main", "发送失败！");
                  JSONObject obj = messageToJson(message);
                  emchatCallbackContext.error(obj);
                }
              });
        } catch (JSONException e1) {
          // TODO Auto-generated catch block
          e1.printStackTrace();
          emchatCallbackContext.error("参数错误");
          return;
        } catch (IllegalArgumentException e) {
          emchatCallbackContext.error("CHAT类型错误");
        }
      }

    });

  }

  private void dealLogin(JSONArray args) {
    String user, psword;
    try {
      user = args.getString(0);
      psword = args.getString(1);
      EMChatManager.getInstance().login(user, psword, new EMCallBack() {// 回调
            @Override
            public void onSuccess() {
              cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                  EMGroupManager.getInstance()
                      .loadAllGroups();
                  EMChatManager.getInstance()
                      .loadAllConversations();
                  Log.d("main", "登陆聊天服务器成功！");
                  emchatCallbackContext.success("登陆聊天服务器成功！");
                }
              });
            }

            @Override
            public void onProgress(int progress, String status) {

            }

            @Override
            public void onError(int code, String message) {
              Log.d("main", "登陆聊天服务器失败！");
              emchatCallbackContext.error("登陆聊天服务器失败！");
            }
          });
    } catch (JSONException e) {
      e.printStackTrace();
      emchatCallbackContext.error("发送错误！");
    }

  }

  private void dealLogout() {
    // 此方法为异步方法
    EMChatManager.getInstance().logout(new EMCallBack() {

      @Override
      public void onSuccess() {
        // 如果不想收到回调，则执行解除监听事件
        EMChatManager.getInstance().unregisterEventListener(
            new EMEventListener() {

              @Override
              public void onEvent(EMNotifierEvent event) {
                // TODO Auto-generated method stub

              }
            });
        emchatCallbackContext.success("退出成功！");
      }

      @Override
      public void onProgress(int progress, String status) {
        // TODO Auto-generated method stub

      }

      @Override
      public void onError(int code, String message) {
        emchatCallbackContext.error("退出失败！");
      }
    });

  }

  private void dealGetMessages(JSONArray args) {
    final JSONArray _args = args;

    cordova.getThreadPool().execute(new Runnable() {
      public void run() {
        try {
          String chatType = _args.getString(0);
          String target = _args.getString(1);
          EMConversation conversation = EMChatManager.getInstance()
              .getConversation(target);
          List<EMMessage> messages;
          if (_args.length() < 3) {
            // 获取此会话的所有消息
            messages = conversation.getAllMessages();
          } else {
            final String startMsgId = _args.getString(2);
            if (chatType.equals("group")) {
              // 如果是群聊，调用下面此方法
              messages = conversation.loadMoreGroupMsgFromDB(
                  startMsgId, pagesize);
            } else {
              // sdk初始化加载的聊天记录为20条，到顶时需要去db里获取更多
              // 获取startMsgId之前的pagesize条消息，此方法获取的messages
              // sdk会自动存入到此会话中，app中无需再次把获取到的messages添加到会话中
              messages = conversation.loadMoreMsgFromDB(
                  startMsgId, pagesize);
            }
          }
          // 未读消息数清零
          conversation.resetUnreadMsgCount();
          JSONArray mJSONArray = new JSONArray();
          for (int i = 0; i < messages.size(); i++) {
            JSONObject message = messageToJson(messages.get(i));
            mJSONArray.put(message);
          }
          PluginResult pluginResult = new PluginResult(
              PluginResult.Status.OK, mJSONArray);
          emchatCallbackContext.sendPluginResult(pluginResult);
        } catch (JSONException e) {
          e.printStackTrace();
          emchatCallbackContext.error("获取聊天记录失败！");
        }
      }

    });

  }

  private void dealSetting(JSONArray args) {
    JSONObject params;
    try {
      params = args.getJSONObject(0);
      // 首先获取EMChatOptions
      EMChatOptions chatOptions = EMChatManager.getInstance()
          .getChatOptions();
      if (params.has("NotifyBySoundAndVibrate")) {
        // 设置是否启用新消息提醒(打开或者关闭消息声音和震动提示)
        chatOptions.setNotifyBySoundAndVibrate(params
            .getBoolean("NotifyBySoundAndVibrate")); // 默认为true
                                  // 开启新消息提醒
      }
      if (params.has("NoticeBySound")) {
        // 设置是否启用新消息声音提醒
        chatOptions
            .setNoticeBySound(params.getBoolean("NoticeBySound")); // 默认为true
                                        // 开启声音提醒

      }
      if (params.has("NoticedByVibrate")) {
        // 设置是否启用新消息震动提醒
        chatOptions.setNoticedByVibrate(params
            .getBoolean("NoticedByVibrate")); // 默认为true 开启新消息提醒
      }
      if (params.has("UseSpeaker")) {
        // 设置语音消息播放是否设置为扬声器播放
        chatOptions.setUseSpeaker(params.getBoolean("UseSpeaker")); // 默认为true
                                      // 开启新消息提醒
      }
      if (params.has("ShowNotificationInBackgroud")) {
        // 设置后台接收新消息时是否通通知栏提示
        chatOptions.setShowNotificationInBackgroud(params
            .getBoolean("ShowNotificationInBackgroud")); // 默认为true
                                    // 开启新消息提醒
      }
      emchatCallbackContext.success("设置成功");
    } catch (JSONException e) {
      e.printStackTrace();
      emchatCallbackContext.error("设置失败");
    }

  }

  private void bindListener() {
    noifier = new HXNotifier();
    noifier.init(cordova.getActivity().getApplicationContext());
    // EMChatOptions chatOptions = EMChatManager.getInstance()
    // .getChatOptions();
    // chatOptions.setOnNotificationClickListener(getOnNotificationClickListener());
    // 覆盖消息提醒设置
    // noifier.setNotificationInfoProvider(getNotificationListener());
    // 接收所有的event事件
    EMChatManager.getInstance().registerEventListener(
        new EMEventListener() {

          @Override
          public void onEvent(EMNotifierEvent event) {
            EMMessage message = null;
            Context appContext = cordova.getActivity()
                .getApplicationContext();
            if (event.getData() instanceof EMMessage) {
              message = (EMMessage) event.getData();
              EMLog.d(TAG,
                  "receive the event : " + event.getEvent()
                      + ",id : " + message.getMsgId());
            }

            switch (event.getEvent()) {
            case EventNewMessage:
              // 应用在后台，不需要刷新UI,通知栏提示新消息
              if (!EasyUtils.isAppRunningForeground(appContext)) {
                EMLog.d(TAG, "app is running in backgroud");
                noifier.onNewMsg(message);
              } else {
                String msg = messageToJson(message).toString();
                fireEvent("ReciveMessage", msg);
                EMLog.d(TAG, message.toString());
              }
              break;
            case EventOfflineMessage:
              @SuppressWarnings("unchecked")
              List<EMMessage> messages = (List<EMMessage>) event
                  .getData();
              if (!EasyUtils.isAppRunningForeground(appContext)) {
                EMLog.d(TAG, "received offline messages");
                noifier.onNewMesg(messages);
              } else {

                JSONArray mJSONArray = new JSONArray();
                for (int i = 0; i < messages.size(); i++) {
                  JSONObject _message = messageToJson(messages
                      .get(i));
                  mJSONArray.put(_message);
                }
                fireEvent("ReciveMessage",
                    mJSONArray.toString());
                EMLog.d(TAG, message.toString());
              }
              break;
            // below is just
            // giving a example
            // to show a cmd
            // toast, the app
            // should not follow
            // this
            // so be careful of
            // this
            case EventNewCMDMessage:
              break;
            case EventDeliveryAck:
              message.setDelivered(true);
              break;
            case EventReadAck:
              message.setAcked(true);
              break;
            // add other events
            // in case you are
            // interested in
            default:
              break;
            }
          };
        });
  }
  private void dealGetConvarsations() {
      Hashtable<String, EMConversation> conversations = EMChatManager.getInstance().getAllConversations();
      JSONArray mJSONArray = new JSONArray();
      for (int i = 0; i < conversations.size(); i++) {
        JSONObject conversation = conversationToJson(conversations.get(i));
        mJSONArray.put(conversation);
      }
      PluginResult pluginResult = new PluginResult(
          PluginResult.Status.OK, mJSONArray);
      emchatCallbackContext.sendPluginResult(pluginResult);
    }

  private JSONObject conversationToJson(EMConversation emConversation) {
    JSONObject msgJson = new JSONObject();
      try {
    msgJson.put("chatter", emConversation.getUserName())
          .put("isGroup", emConversation.getIsGroup())
          .put("unreadMessagesCount", emConversation.getUnreadMsgCount())
          .put("latestMessageFromOthers", messageToJson(emConversation.getLastMessage()));
    
  } catch (JSONException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
  return msgJson;
}

/**
   * 消息转为json格式
   * 
   * @param message
   *            消息
   * @return json格式的message
   */
  public static JSONObject messageToJson(EMMessage message) {

    JSONObject msgJson = new JSONObject();

    try {
      msgJson.put("direct", message.direct)
          .put("type", message.getType().toString())
          .put("status", message.status)
          .put("isAcked", message.isAcked)
          .put("progress", message.progress)
          .put("isDelivered", message.isDelivered)
          .put("msgTime", message.getMsgTime())
          .put("from", message.getFrom()).put("to", message.getTo())
          .put("msgId", message.getMsgId())
          .put("chatType", message.getChatType())
          .put("unRead", message.isUnread())
          .put("isListened", message.isListened());

      JSONObject body = new JSONObject();

      switch (message.getType()) {
      case VOICE:
        VoiceMessageBody voiceBody = (VoiceMessageBody) message
            .getBody();
        body.put("localUrl", voiceBody.getLocalUrl())
            .put("remoteUrl", voiceBody.getRemoteUrl())
            .put("name", voiceBody.getFileName())
            .put("duration", voiceBody.getLength());
        break;
      case IMAGE:
        ImageMessageBody imageBody = (ImageMessageBody) message
            .getBody();
          body.put("localUrl", imageBody.getLocalUrl())
              .put("remoteUrl", imageBody.getRemoteUrl())
              .put("thumbnailUrl", imageBody.getThumbnailUrl())
              .put("with", imageBody.getWidth())
              .put("height", imageBody.getHeight());
          

        break;
      case LOCATION:
        LocationMessageBody locationBody = (LocationMessageBody) message
            .getBody();
        body.put("address", locationBody.getAddress())
            .put("latitude", locationBody.getLatitude())
            .put("longitude", locationBody.getLongitude());
        break;
      case FILE:
        NormalFileMessageBody fileBody = (NormalFileMessageBody) message
            .getBody();
        body.put("name", fileBody.getFileName())
            .put("size", fileBody.getFileSize())
            .put("localUrl", fileBody.getLocalUrl())
            .put("remoteUrl", fileBody.getRemoteUrl());

        break;
      case TXT:
      default:
        TextMessageBody txtBody = (TextMessageBody) message.getBody();
        body.put("text", txtBody.getMessage());
        break;
      }
      try {
        msgJson.put("extend", message.getJSONObjectAttribute("extend"));
      } catch (EaseMobException e) {
      }
      msgJson.put("body", body);
    } catch (JSONException e) {
      e.printStackTrace();
    }
    return msgJson;

  }

  /**
   * 群聊转为json格式
   * 
   * @param group
   *            群聊信息
   * @return json格式的群聊信息
   */
  public static JSONObject groupToJson(EMGroup group) {

    JSONObject msgJson = new JSONObject();

    try {
      msgJson.put("description", group.getDescription())
          .put("id", group.getGroupId())
          .put("name", group.getGroupName())
          .put("memberCount", group.getAffiliationsCount());
    } catch (JSONException e) {
      e.printStackTrace();
    }

    return msgJson;

  }

  /**
   * 群聊转为jsonArray格式
   * 
   * @param groups
   *            群聊信息
   * @return json格式的群聊信息
   */
  public static JSONArray groupsToJson(List<EMGroup> groups) {

    JSONArray mJSONArray = new JSONArray();
    for (int i = 0; i < groups.size(); i++) {
      JSONObject _group = groupToJson(groups.get(i));
      mJSONArray.put(_group);
    }

    return mJSONArray;

  }

  /**
   * 自定义通知栏提示内容
   * 
   * @return
   */
  protected HXNotificationInfoProvider getNotificationListener() {
    // 可以覆盖默认的设置
    return new HXNotificationInfoProvider() {

      @Override
      public String getTitle(EMMessage message) {
        // 修改标题,这里使用默认
        return null;
      }

      @Override
      public int getSmallIcon(EMMessage message) {
        // 设置小图标，这里为默认
        return 0;
      }

      @Override
      public String getDisplayedText(EMMessage message) {
        // 设置状态栏的消息提示，可以根据message的类型做相应提示
        // String ticker = CommonUtils.getMessageDigest(message,
        // appContext);
        // if(message.getType() == Type.TXT){
        // ticker = ticker.replaceAll("\\[.{2,3}\\]", "[表情]");
        // }

        // return message.getFrom() + ": " + ticker;
        return null;
      }

      @Override
      public String getLatestText(EMMessage message, int fromUsersNum,
          int messageNum) {
        return null;
        // return fromUsersNum + "个基友，发来了" + messageNum + "条消息";
      }

      @Override
      public Intent getLaunchIntent(EMMessage message) {
        // 设置点击通知栏跳转事件
        // String msg = messageToJson(message).toString();
        // fireEvent("ClickNotification", msg);
        return null;
      }
    };
  }

  private String getRealPathFromURI(String uriStr) {
    if (uriStr.indexOf("file:") == 0) {
      return uriStr.substring(7);
    } else {
      Uri contentUri = Uri.parse(uriStr);
      Cursor cursor = cordova.getActivity().getContentResolver()
          .query(contentUri, null, null, null, null);
      if (cursor != null) {
        cursor.moveToFirst();
        int columnIndex = cursor.getColumnIndex("_data");
        String picturePath = cursor.getString(columnIndex);
        cursor.close();
        cursor = null;

        if (picturePath == null || picturePath.equals("null")) {
          throw new IllegalArgumentException("null");
        }
        return picturePath;
      } else {
        return contentUri.getPath();
      }
    }

  }

  private String getAppName(int pID) {
    String processName = null;
    ActivityManager am = (ActivityManager) cordova.getActivity()
        .getSystemService(android.content.Context.ACTIVITY_SERVICE);
    List l = am.getRunningAppProcesses();
    Iterator i = l.iterator();
    PackageManager pm = cordova.getActivity().getPackageManager();
    while (i.hasNext()) {
      ActivityManager.RunningAppProcessInfo info = (ActivityManager.RunningAppProcessInfo) (i
          .next());
      try {
        if (info.pid == pID) {
          CharSequence c = pm.getApplicationLabel(pm
              .getApplicationInfo(info.processName,
                  PackageManager.GET_META_DATA));
          // Log.d("Process", "Id: "+ info.pid +" ProcessName: "+
          // info.processName +"  Label: "+c.toString());
          // processName = c.toString();
          processName = info.processName;
          return processName;
        }
      } catch (Exception e) {
        // Log.d("Process", "Error>> :"+ e.toString());
      }
    }
    return processName;
  }
}
