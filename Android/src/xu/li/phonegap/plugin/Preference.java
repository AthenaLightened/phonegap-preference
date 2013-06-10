package xu.li.phonegap.plugin;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public class Preference extends CordovaPlugin {
	
	public static final String KEY_SEPARATOR = ".";
	
	@Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("getPreference")) {
            this.getPreference(args, callbackContext);
            return true;
        } else if (action.equals("setPreference")) {
            this.setPreference(args, callbackContext);        	
        	return true;
        }
        return false;
    }
	
	private void setPreference(JSONArray args, CallbackContext callbackContext) throws JSONException {
		SharedPreferences preference = getPreference();
		SharedPreferences.Editor editor = preference.edit();
		
		int numArgs = args.length();
	    if (numArgs > 1) {
	        // handle the format like "setPreference("key1", "value1")"
	    	String key = args.getString(0);
	    	Object value = args.get(1);
	    	this.setValue(editor, key, value);
	    } else if (numArgs == 1) {
	        // handle the format like "setPreference({"key1": "value1"})"
	    	JSONObject firstArgument = args.getJSONObject(0);
	    	Iterator<?> keys = firstArgument.keys();
	    	while (keys.hasNext()) {
	    		String key = (String)keys.next();
	    		this.setValue(editor, key, firstArgument.get(key));
	    	}
	    }
	    
	    editor.commit();
	    
	    // return back
	    callbackContext.success();
	}
	
	
	private void getPreference(JSONArray args, CallbackContext callbackContext) throws JSONException {
		// prepare all the keys
		ArrayList<String> keys = null;
		int numArgs = args.length();
		int i = 0;
		if (numArgs > 1) {
			// handle the format like "getPreference("key1", "key2")"
			keys = new ArrayList<String>(numArgs);
			for (i = 0; i < numArgs; i++) {
				keys.add(args.getString(i));
			}
		} else if (numArgs == 1) {
			// handle the format like "getPreference(["key1", "key2"])"
			if (args.get(0) instanceof JSONArray) {
				JSONArray firstArgument = args.getJSONArray(0);
				int len = firstArgument.length();
				keys = new ArrayList<String>(len);
				for (i = 0; i< len; ++i) {
					keys.add(firstArgument.getString(i));
				}
			} else {
				keys = new ArrayList<String>(1);
				keys.add(args.getString(0));
			}
		}
		
		// get all the values
		JSONObject values = new JSONObject();
		SharedPreferences preference = getPreference();
		Map<String, ?> allPreference = preference.getAll();
		for (String key : keys) {
			Object value = allPreference.get(key);
			if (value instanceof String) {
				String strValue = (String) value;
				if (strValue.startsWith("[") || strValue.startsWith("{")) {
					// check if it's a JSON string
					values.put(key, new JSONTokener(strValue).nextValue());
				} else {
					values.put(key, value);
				}
			} else {
				values.put(key, value);
			}
		}
		
		// return back
		callbackContext.success(values);
	}
	
	private SharedPreferences getPreference() {
		return PreferenceManager.getDefaultSharedPreferences(this.webView.getContext());
	}
	
	/**
	 * Ugly way of setting the value
	 * 
	 * I have little knowledge of java, don't know how to do this..
	 * 
	 * @param editor
	 * @param key
	 * @param value
	 * @throws JSONException 
	 */
	private void setValue(SharedPreferences.Editor editor, String key, Object value) throws JSONException {
		if (value instanceof Integer) {
			editor.putInt(key, ((Integer) value).intValue());
		} else if (value instanceof Boolean) {
			editor.putBoolean(key, ((Boolean) value).booleanValue());
		} else if (value instanceof Double) {
			editor.putFloat(key, ((Double) value).floatValue());
		} else if (value instanceof String) {
			editor.putString(key, (String) value);
		} else if (value instanceof JSONArray) {
			setValue(editor, key, value.toString());
		} else if (value instanceof JSONObject) {
			setValue(editor, key, value.toString());
		}
	}
}
