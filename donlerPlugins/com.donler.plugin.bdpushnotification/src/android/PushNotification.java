package com.donler.plugin.bdpushnotification;

import java.util.ArrayList;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


import android.app.AlertDialog;
import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.res.Resources;
import android.preference.PreferenceManager;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushManager;
public class PushNotification extends CordovaPlugin
{
	protected static Boolean isInBackground = true;
	private   static Boolean deviceready = false;
	private   static ArrayList<String> eventQueue = new ArrayList<String>();
	private BroadcastReceiver receiver = null;
  private static CallbackContext pushCallbackContext = null;
  private   static CordovaWebView webView = null;
  public static final String ACTION_RESPONSE = "bccsclient.action.RESPONSE";
	public static final String RESPONSE_METHOD = "method";
	public static final String RESPONSE_CONTENT = "content";
	public static final String RESPONSE_ERRCODE = "errcode";

  @Override
  public void initialize (CordovaInterface cordova, CordovaWebView webView) {
      super.initialize(cordova, webView);

      PushNotification.webView = super.webView;
  }

	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException
	{
		if(action.equals("init"))
		{
			
			this.pushCallbackContext = callbackContext;
      IntentFilter intentFilter = new IntentFilter();
      intentFilter.addAction(PushConstants.ACTION_RECEIVE);
      if (this.receiver == null)
      {
          this.receiver = new BroadcastReceiver()
          {
              @Override
              public void onReceive(Context context, Intent intent)
              {
            		if (intent.getAction().equals(PushConstants.ACTION_RECEIVE))
            		{
            			sendPushInfo(context, intent);
            		}
              }
          };
          cordova.getActivity().registerReceiver(this.receiver, intentFilter);
      }

      PluginResult pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
      PushManager.startWork(cordova.getActivity().getApplicationContext(), PushConstants.LOGIN_TYPE_API_KEY, args.getString(0));
        return true;
		}else if (action.equals("getInfo")) {
        JSONObject r = new JSONObject();
        SharedPreferences sp = PreferenceManager
				.getDefaultSharedPreferences(cordova.getActivity());
		//appId = sp.getString("appid", "");
		/*channelId = sp.getString("channel_id", "");
		clientId = sp.getString("user_id", "");*/	
        r.put("appId", sp.getString("appid", ""));
        r.put("channelId",sp.getString("channel_id", ""));
        r.put("clientId", sp.getString("user_id", ""));
        callbackContext.success(r);
        return true;
    }
    else if (action.equalsIgnoreCase("deviceready")) {
        cordova.getThreadPool().execute( new Runnable() {
            public void run() {
                deviceready();
            }
        });
    }else if (action.equalsIgnoreCase("pause")) {
        isInBackground = true;
    }

    else if (action.equalsIgnoreCase("resume")) {
        isInBackground = false;
        cordova.getThreadPool().execute( new Runnable() {
          public void run() {
              deviceready();
          }
        });
    }
		return false;
	}
	
	private void sendPushInfo(Context context, Intent intent)
	{
		String content = "";
		JSONObject info = null;
		if (intent.getByteArrayExtra(PushConstants.EXTRA_CONTENT) != null)
		{
			content = new String(intent.getByteArrayExtra(PushConstants.EXTRA_CONTENT));
			try
			{
				info = (JSONObject)new JSONObject(content).get("response_params");
				info.put("deviceType", 3);
				
				SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(cordova.getActivity());
				Editor editor = sp.edit();
				editor.putString("appid", info.getString("appid"));
				editor.putString("channel_id", info.getString("channel_id"));
				editor.putString("user_id", info.getString("user_id"));

				editor.commit();
			}
			catch (JSONException e)
			{
				e.printStackTrace();
			}
		}
		if (this.pushCallbackContext != null) 
		{
	        PluginResult result = new PluginResult(PluginResult.Status.OK, info);
	        result.setKeepCallback(false);
	        this.pushCallbackContext.sendPluginResult(result);
		}
    if (this.receiver != null) {
        try {
            this.cordova.getActivity().unregisterReceiver(this.receiver);
            this.receiver = null;
        } catch (Exception e) {
            //
        }
    }
  }
  /**
   * Calls all pending callbacks after the deviceready event has been fired.
   */
  private static void deviceready () {
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
   * @param {String} json  A custom (JSON) string
   */
  public static void fireEvent (String event, String json) {
    String js     = "setTimeout('bdPushNotification.on" + event + "(" +json + ")',0)";
    if (deviceready == false) {
        eventQueue.add(js);
    } else {
        webView.sendJavascript(js);
    }
  }
  public static void fireEvent (String event, JSONObject json) {
    PluginResult result = new PluginResult(PluginResult.Status.OK, json);
    result.setKeepCallback(false);
    pushCallbackContext.sendPluginResult(result);
  }

}






