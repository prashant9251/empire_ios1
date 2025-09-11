package com.unique.empire_ios;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.webkit.JavascriptInterface;

import androidx.core.content.FileProvider;

import java.io.File;
import java.io.FileOutputStream;

public class WebAppInterfaceUniq {
    Context mContext;

    WebAppInterfaceUniq(Context context) {
        mContext = context;
    }
    @JavascriptInterface
    public void closeWebView() {
        if (mContext instanceof Activity) {
            ((Activity) mContext).finish();
        }
    }
    @JavascriptInterface
    public void shareText(String text,String mo) {
        WebViewJavaUniq.shareText=text;
        String url = "whatsapp://send?&text="+WebViewJavaUniq.shareText;
        mContext.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
    }
    @JavascriptInterface
    public void dialNo(String mo) {
        String callMobileNo = mo;
        mContext.startActivity(new Intent(Intent.ACTION_DIAL, Uri.parse("tel:"+callMobileNo)));
    }

    @JavascriptInterface
    public void sendShareTextToApp(String msg,String mo) {
        WebViewJavaUniq.shareText=msg;
    }


    @JavascriptInterface
    public void bulkPdfStartCreateShare(String list) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                ((WebViewJavaUniq) mContext).bulkPdfStartCreateShare(list);
            }
        });
    }

    @JavascriptInterface
    public void downloadExcel(String base64Data,String fileName) {
        try {
            String base64String = base64Data.contains(",") ? base64Data.split(",")[1] : base64Data;
            byte[] decodedBytes = android.util.Base64.decode(base64String, android.util.Base64.DEFAULT);

            File file = new File(mContext.getExternalCacheDir(), fileName+".xlsx");
            FileOutputStream fos = new FileOutputStream(file);
            fos.write(decodedBytes);
            fos.close();

            Uri fileUri = FileProvider.getUriForFile(mContext, mContext.getPackageName() + ".provider", file);

            Intent shareIntent = new Intent(Intent.ACTION_SEND);
            shareIntent.setType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            shareIntent.putExtra(Intent.EXTRA_STREAM, fileUri);
            shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

            mContext.startActivity(Intent.createChooser(shareIntent, "Share File"));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
