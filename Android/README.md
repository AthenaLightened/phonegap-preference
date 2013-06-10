# PhoneGAP Preference Plugin

This plugin uses ```SharedPreferences``` to save the user preference.

## Versions

* phonegap 2.8.0
* Android Developer Tools, Build: v22.0.0-675183

## How to use

1. add ```xu.li.phonegap.plugin.Preference```

2. update ```config.xml```
```
<feature name="Preference">
        <param name="ios-package" value="xu.li.phonegap.plugin.Preference"/>
</feature>
```

3. get saved preference
```javascript
cordova.exec(function (preferenceHash) {
        // preferenceHash = {"key1": SOME_VALUE_OR_NULL, "key2": SOME_VALUE_OR_NULL}
}, null, "Preference", "getPreference", ["key1", "key2"]);
```

4. save preference
```javascript
var arguments = ["key1", VALUE_FOR_KEY1];
// or you can use this: var arguments = [{"key1": VALUE_FOR_KEY1}];
cordova.exec(function () {
        console.log("saved");
}, null, "Preference", "setPreference", arguments);
```
