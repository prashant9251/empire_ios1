package com.unique.empire_ios;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.print.PdfPrinter;
import android.print.PrintAttributes;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.CookieManager;
import android.webkit.JsResult;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebStorage;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.SearchView;
import androidx.appcompat.widget.Toolbar;
import androidx.core.content.ContextCompat;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import org.json.JSONArray;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class WebViewJavaUniq extends AppCompatActivity {

    private Toolbar toolbar;
    private FloatingActionButton fabWhatsapp;
    private FloatingActionButton fabPdf;
    private FloatingActionButton fabEmail;
    public static FloatingActionButton fabMsg;
    private Myf Myf;
    private String lastUpdatetime;
    private String UrlLinkUser;
    private String url;
    public static  String mobileNo;
    public static String shareMobileNo = "";

    private String partyEmail;
    private WebView webView;
    private Map<String, String> arg;
    public  MenuItem action_scanBarcode;
    private ProgressDialog progressDialog;
    public static String shareText="";
    private String databaseID="";
    private int minimumFontSize=8;
    public static  String CHANNEL = "androidToFlutterChannel";
    public static MethodChannel methodChannel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_web_view_screen);
        FlutterEngine flutterEngine = MainActivity.flutterEngineInstance;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(ContextCompat.getColor(this, R.color.uniqColor));
        }
        progressDialog = new ProgressDialog(this);
        progressDialog.setMessage("Please wait...");
        progressDialog.setCancelable(true);
        progressDialog.show();
        Myf =new Myf(WebViewJavaUniq.this);
        iniVar();
        loadWebViewSettingsWithSettings();
    }
    public void bulkPdfStartCreateShare(String list) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // Your method logic here
                FlutterEngine flutterEngine = MainActivity.flutterEngineInstance;
                WebViewJavaUniq.methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), WebViewJavaUniq.CHANNEL);
                WebViewJavaUniq.methodChannel.invokeMethod("bulkPdfStartCreateShare", list, new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object result) {
//                        Log.d("YourActivity", "Method call success");
                        Toast.makeText(WebViewJavaUniq.this, "Please go back & wait for pdf building", Toast.LENGTH_SHORT).show();
                    }
                    @Override
                    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
//                        Log.e("YourActivity", "Method call error: " + errorMessage);
                    }

                    @Override
                    public void notImplemented() {
//                        Log.e("YourActivity", "Method not implemented");
                    }
                });
            }
        });
    }

    private void iniVar() {
        fabPdf = findViewById(R.id.fabPdf);
        fabPdf.setOnClickListener(v -> createPdf(""));
        fabWhatsapp = findViewById(R.id.fabWhatsapp);
        fabWhatsapp.setOnClickListener(v -> createPdf("whatsapp"));
        fabWhatsapp.hide();
        fabEmail = findViewById(R.id.fabEmail);
        fabEmail.setOnClickListener(v -> createPdf("email"));
        fabEmail.hide();
        fabMsg = findViewById(R.id.fabMsg);
        fabMsg.setOnClickListener(v -> {
            if(mobileNo!=null && mobileNo!="" && mobileNo != "null" ){
             shareMobileNo = "91" + mobileNo;
             Toast.makeText(this,  shareMobileNo, Toast.LENGTH_SHORT).show();
            }
            String url = "whatsapp://send/?phone=" + shareMobileNo + "&text=" + shareText;
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
        });
        fabMsg.hide();
        toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);
        getSupportActionBar().setSubtitle(lastUpdatetime);
        toolbar.setNavigationOnClickListener(v -> onBackPressed());
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.right_menu, menu);
        action_scanBarcode= menu.findItem(R.id.action_scanBarcode);
        action_scanBarcode.setVisible(false);
        if(url.indexOf("PCSSTOCK_FRMReport")>-1){
            action_scanBarcode.setVisible(true);
        }
        MenuItem searchItem = menu.findItem(R.id.action_searchWebview);
        SearchView searchView = (SearchView) searchItem.getActionView();
        searchView.setSubmitButtonEnabled(true);
        searchView.setQueryHint("Search By Anything...");
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                webView.findNext(true);
                return true;
            }
            @Override
            public boolean onQueryTextChange(String newText) {
                webView.findAllAsync(newText);
                return true;
            }
        });
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_hideUnhide:
                webView.loadUrl("javascript:showhideUnhide();");
                return true;
            case R.id.action_select:
                webView.loadUrl("javascript:selectBoxReport();");
                return true;
            case R.id.action_downloadExcel:
                webView.loadUrl("javascript:downloadExcel();");
                return true;
            case R.id.action_print:
                Myf.printCurrentPage(webView);
                return true;
            case R.id.action_viewPdfDownload:
                createPdf("view");
                return true;
            case R.id.action_troubleshoot:
                clearAllCache();
                finishAffinity();
                return true;
            case R.id.action_scanBarcode:
                scanStartWeb();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private String convertListToJson(List<String> list) {
        JSONArray jsonArray = new JSONArray();
        for (String item : list) {
            jsonArray.put(item);
        }
        return jsonArray.toString();
    }
    private void clearAllCache() {
       // webView.clearCache(true);
        Myf.setValInSavedPref(databaseID,"localTimeInMili","");
        Myf.setValInSavedPref(databaseID,"lastUpdatetime","");
        clearCookies();
        webView.clearFormData();
        WebStorage.getInstance().deleteAllData();
    }

    private void clearCookies() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            CookieManager.getInstance().removeAllCookies(new ValueCallback<Boolean>() {
                @Override
                public void onReceiveValue(Boolean aBoolean) {
                }
            });
        } else {
            CookieManager.getInstance().removeAllCookie();
        }
    }

    private void scanStartWeb() {
        IntentIntegrator integrator = new IntentIntegrator(this);
        integrator.setDesiredBarcodeFormats(IntentIntegrator.ALL_CODE_TYPES);
        integrator.setPrompt("Scan a barcode");
        integrator.setCameraId(0);
        integrator.setOrientationLocked(true);
        integrator.setBeepEnabled(true);
        integrator.setCaptureActivity(CustomScannerActivityWeb.class);
        integrator.setTorchEnabled(true);
        integrator.initiateScan();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if (result != null) {
            if (result.getContents() == null) {
                Toast.makeText(this, "Scan canceled", Toast.LENGTH_SHORT).show();
            } else {
                String scannedResult = result.getContents();
                Toast.makeText(this, "Scanned result: " + scannedResult, Toast.LENGTH_SHORT).show();
                webView.loadUrl("javascript:loadBarCode('" + scannedResult + "');");
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    private void loadWebViewSettingsWithSettings() {

        url = getIntent().getStringExtra("url");
        UrlLinkUser = getIntent().getStringExtra("UrlLinkUser");
        int initialScale = 100;
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            url = extras.getString("url");
            UrlLinkUser = extras.getString("UrlLinkUser");
            initialScale = extras.getInt("initialScale");
            lastUpdatetime = extras.getString("lastUpdatetime");
            databaseID= extras.getString("databaseID");
            minimumFontSize=extras.getInt("minimumFontSize");
            Log.d("TAG", "loadWebViewSettingsWithSettings: =" + lastUpdatetime);
        }
        String finalurl = url + UrlLinkUser;
        mobileNo = Myf.getUrlParams(finalurl, "mobileNo");
        if (mobileNo != null && !mobileNo.equals("") && !mobileNo.equals("null"))
            fabWhatsapp.show();
        partyEmail = Myf.getUrlParams(finalurl, "partyEmail");
        if (partyEmail != null && !partyEmail.equals("") && !partyEmail.equals("null"))
            fabEmail.show();
        if(url.indexOf("OUTSTANDING_AJXREPORT")>-1)fabMsg.show();

//        Log.d("webviewScreen-", "partyEmail: " + partyEmail);
        webView = findViewById(R.id.webViewScreenUniq);
        webView.setInitialScale(initialScale);
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        webView.addJavascriptInterface(new WebAppInterfaceUniq(this), "Android");
        webSettings.setSupportZoom(true);
        webSettings.setMinimumFontSize(minimumFontSize);
        webSettings.setDefaultFontSize(16);
        webSettings.setDefaultFixedFontSize(16);
        webSettings.setMinimumLogicalFontSize(minimumFontSize);
        webSettings.setUseWideViewPort(false);
        webSettings.setTextZoom(100);
        webSettings.setBuiltInZoomControls(true);
        webSettings.setDisplayZoomControls(false);
        webSettings.setCursiveFontFamily("cursive");
        webSettings.setFantasyFontFamily("fantasy");
        webSettings.setFixedFontFamily("monospace");
        webSettings.setSansSerifFontFamily("sans-serif");
        webSettings.setSerifFontFamily("sans-serif");
        webSettings.setStandardFontFamily("sans-serif");

        webSettings.setAllowContentAccess(true);
        webSettings.setAllowFileAccess(true);
        webSettings.setDatabaseEnabled(true);
        webSettings.setFixedFontFamily("sans-serif");
        webSettings.setStandardFontFamily("sans-serif");
        webSettings.setSansSerifFontFamily("sans-serif");
        webSettings.setSerifFontFamily("sans-serif");
        webSettings.setCursiveFontFamily("sans-serif");
        webSettings.setFantasyFontFamily("sans-serif");
        webView.setWebChromeClient(new WebChromeClient(){
            @Override
            public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
                new AlertDialog.Builder(view.getContext(), R.style.CustomAlertDialog)
                        .setTitle("Alert")
                        .setMessage(message)
                        .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                result.confirm();
                            }
                        })
                        .setCancelable(false)
                        .create()
                        .show();
                return true; // Indicate that we've handled the alert
            }
        });
        webView.setWebViewClient(new WebViewClient() {


            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                progressDialog.dismiss();
            }

            @Override
            public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
                super.onReceivedError(view, request, error);
                progressDialog.dismiss();
               // Toast.makeText(WebViewJavaUniq.this, error.getDescription(), Toast.LENGTH_SHORT).show();
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url != null) {
                    if (url.contains("NTAB")) {
                        Intent intent = new Intent(webView.getContext(), WebViewJavaUniq.class);
                        intent.putExtra("url", url);
                        intent.putExtra("UrlLinkUser", UrlLinkUser);
                        Bundle bundle = new Bundle();
                        if (extras != null) {
                            for (String key : extras.keySet()) {
                                Object value = extras.get(key);
                                if (value instanceof String) {
                                    bundle.putString(key, (String) value);
                                } else if (value instanceof Integer) {
                                    bundle.putInt(key, (Integer) value);
                                } else if (value instanceof Boolean) {
                                    bundle.putBoolean(key, (Boolean) value);
                                }
                                // Add other types as needed
                            }
                        }
                        bundle.putString("url", url);
                        bundle.putString("UrlLinkUser", UrlLinkUser);
                        intent.putExtras(bundle);
                        webView.getContext().startActivity(intent);
                        return true;
                    }
                }
                return super.shouldOverrideUrlLoading(view, url);
            }
        });
        webView.loadUrl(finalurl);
    }

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            finish();
            super.onBackPressed();
        }
    }

    private void createPdf(String sendType) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            ProgressDialog progressDialog = new ProgressDialog(this);
            progressDialog.setMessage("Creating pdf...");
            progressDialog.setCancelable(false);
            progressDialog.show();
            String name = webView.getTitle();
            long currentTimeMillis = System.currentTimeMillis();
            Date currentDate = new Date(currentTimeMillis);
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yy HH:mm", Locale.getDefault());
            String formattedDateTime = sdf.format(currentDate);
            name = name.replaceAll("[;\\/:*?\"<>|&']", " ");
            name += " (PDF GENERATED ON " + formattedDateTime + ") ";
            String fileName = name + ".pdf";
            PrintAttributes attributes = new PrintAttributes.Builder()
                    .setMediaSize(PrintAttributes.MediaSize.ISO_A4)
                    .setResolution(new PrintAttributes.Resolution("pdf", "pdf", 600, 600))
                    .setMinMargins(PrintAttributes.Margins.NO_MARGINS)
                    .build();

            PdfPrinter printer = new PdfPrinter(attributes);
            WebView webViewToPrint = webView;
            android.print.PrintDocumentAdapter adapter = webViewToPrint.createPrintDocumentAdapter(name);
            File path = getApplicationContext().getFilesDir();
           if (mobileNo != null && !mobileNo.isEmpty() && mobileNo != "null") {
                Toast.makeText(this, mobileNo, Toast.LENGTH_SHORT).show();
            }
            printer.print(adapter, path, fileName, new PdfPrinter.Callback() {
                @Override
                public void onSuccess(@NonNull String filePath) {
                    progressDialog.dismiss();
                    if(!filePath.contains(".pdf")) {
                        filePath = filePath + ".pdf";
                    }
                    List<String> fileList = new ArrayList<>();
                    File f = new File(filePath);
                    fileList.add(filePath);
                    if (sendType.indexOf("whatsapp") > -1) {
//                        Log.d("TAG", "sendToWhatsapp: "+mobileNo);
                        
                        Myf.sendToWhatsapp(f, "91" + mobileNo, fileName, fileList);

                    } else if (sendType.indexOf("email") > -1) {
                        Myf.sendToEmail(f, partyEmail, fileName, fileList);
                    } else if (sendType.indexOf("view") > -1) {
                        Myf.sendToView(f);
                    } else {
                        Myf.sendFile(f, fileName);
                    }
                }
                @Override
                public void onFailure() {
                    progressDialog.dismiss();
                }
            });
        }
    }
    public String getMobileNo() {
        return mobileNo;
    }

}




