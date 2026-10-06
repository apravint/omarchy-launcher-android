package com.apravint.omarchylauncher;

import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebSettings;
import android.webkit.JavascriptInterface;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.drawable.Drawable;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.util.Base64;
import java.io.ByteArrayOutputStream;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

public class MainActivity extends Activity {

    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        webView = new WebView(this);
        setContentView(webView);

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setAllowFileAccess(true);

        webView.addJavascriptInterface(new WebAppInterface(), "AndroidLauncher");
        webView.setWebViewClient(new WebViewClient());
        webView.loadUrl("file:///android_asset/web/index.html");
    }

    @Override
    public void onBackPressed() {
        // Prevent launcher from exiting on back press
    }

    public class WebAppInterface {

        @JavascriptInterface
        public String getInstalledApps() {
            JSONArray appList = new JSONArray();
            try {
                PackageManager pm = getPackageManager();
                Intent mainIntent = new Intent(Intent.ACTION_MAIN, null);
                mainIntent.addCategory(Intent.CATEGORY_LAUNCHER);

                List<ResolveInfo> pkgAppsList = pm.queryIntentActivities(mainIntent, 0);
                for (ResolveInfo ri : pkgAppsList) {
                    if (ri.activityInfo != null) {
                        String label = ri.loadLabel(pm).toString();
                        String packageName = ri.activityInfo.packageName;

                        JSONObject appObj = new JSONObject();
                        appObj.put("name", label);
                        appObj.put("packageName", packageName);
                        appObj.put("icon", getAppIconBase64(pm, ri));
                        appList.put(appObj);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return appList.toString();
        }

        @JavascriptInterface
        public boolean launchApp(String packageName) {
            try {
                PackageManager pm = getPackageManager();
                Intent launchIntent = pm.getLaunchIntentForPackage(packageName);
                if (launchIntent != null) {
                    startActivity(launchIntent);
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return false;
        }

        private String getAppIconBase64(PackageManager pm, ResolveInfo ri) {
            try {
                Drawable icon = ri.loadIcon(pm);
                int width = icon.getIntrinsicWidth() > 0 ? icon.getIntrinsicWidth() : 96;
                int height = icon.getIntrinsicHeight() > 0 ? icon.getIntrinsicHeight() : 96;

                Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
                Canvas canvas = new Canvas(bitmap);
                icon.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
                icon.draw(canvas);

                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.PNG, 80, outputStream);
                byte[] byteArray = outputStream.toByteArray();
                return "data:image/png;base64," + Base64.encodeToString(byteArray, Base64.NO_WRAP);
            } catch (Exception e) {
                return "";
            }
        }
    }
}
