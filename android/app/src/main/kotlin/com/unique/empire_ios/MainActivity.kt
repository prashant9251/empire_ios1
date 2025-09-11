package com.unique.empire_ios

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.print.PdfPrinter
import android.print.PrintAttributes
import android.print.PrintJob
import android.print.PrintManager
import android.telephony.PhoneNumberUtils
import android.util.Log
import android.view.View
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.FrameLayout
import android.widget.Toast
import android.widget.Toolbar
import androidx.activity.result.ActivityResultLauncher
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import com.journeyapps.barcodescanner.CaptureActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale


import java.util.concurrent.CompletableFuture

class MainActivity: FlutterFragmentActivity() {
    companion object {
        lateinit var flutterEngineInstance: FlutterEngine
        private const val REQUEST_CODE_SCAN = 1
    }

    private lateinit var scanResultLauncher: ActivityResultLauncher<Intent>

    private  val  channelName="shareAndroid"
    private  lateinit var channel: MethodChannel
    private lateinit var webView: WebView

    override fun onStart() {
        super.onStart()
        window.decorView.visibility= View.VISIBLE
    }

    override fun onStop() {
        super.onStop()
        window.decorView.visibility=View.GONE
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine){
        super.configureFlutterEngine(flutterEngine)
        channel =MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channelName)
        flutterEngineInstance = flutterEngine
        flutterEngine.platformViewsController.registry.registerViewFactory(
            "plugin/uniq_webview",
            UniqWebViewFectory(flutterEngine.dartExecutor.binaryMessenger)
        )
        channel.setMethodCallHandler{call,result ->
            if (call.method=="share"){
                val arg=call.arguments() as Map<String,String>?
                //val Name=arg["name"]
                if(arg!=null){
                val path = arg["path"]
                val mobile = arg["mobile"]
                sendToWhatsapp(path,mobile)}
                result.success("hello prashant")
            }else if (call.method == "createPdfFromWebView") {
                val arg = call.arguments as Map<String, String>?
                if (arg != null) {
                    val html = arg["html"]
                    val url = arg["url"]
                    val path = arg["filePathToSave"]

                    createPdfFromHtml(html, url).thenAccept { filePath ->
                        // Send the filePath back to Flutter
                        result.success(filePath)
                    }.exceptionally { throwable ->
                        // Handle the failure and send an error back to Flutter
                        result.error("PDF_GENERATION_FAILED", "Failed to generate PDF", throwable.message)
                        null
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "Arguments missing", null)
                }
            }else if (call.method=="showLoadingAndroid"){
                showLoading()
            }else if (call.method=="dismissLoadingAndroid"){
                dismissLoading()
            }else if (call.method=="openUrl"){
                val arg=call.arguments() as Map<String,String>?
                //val Name=arg["name"]
                if(arg!=null){
                    val url = arg["url"].toString()
                    var UrlLinkUser= arg["UrlLinkUser"].toString()
                    val intent = Intent(this, WebViewJavaUniq::class.java)
                    val bundle = Bundle()
                    for ((key, value) in call.arguments as Map<String, Any>) {
                        when (value) {
                            is String -> bundle.putString(key, value)
                            is Int -> bundle.putInt(key, value)
                            is Boolean -> bundle.putBoolean(key, value)
                            // Add other types as needed
                        }
                    }
                    intent.putExtras(bundle)
                    intent.putExtra("url", url)
                    intent.putExtra("UrlLinkUser", UrlLinkUser)
                    this.startActivity(intent)
                    result.success(null)
                }
            }else if (call.method=="startScane"){
                scanResult = result
                scanStart()
            }
        }
    }


    fun scanStart() {
        val intent = Intent(this, BarcodeView::class.java)
        startActivityForResult(intent, REQUEST_CODE_SCAN)
    }
    public var scanResult: MethodChannel.Result? = null
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
         if (requestCode == REQUEST_CODE_SCAN && resultCode == RESULT_OK) {
            val scannedResult = data?.getStringExtra("scanned_result")
            Toast.makeText(this, "Scanned: $scannedResult", Toast.LENGTH_SHORT).show()
            scanResult?.success(scannedResult)
        } else {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    fun sendToWhatsapp(path: String?, mobileNo: String?) {
//         val data=Uri.fromFile(File(path))
        val data = FileProvider.getUriForFile(applicationContext, applicationContext.packageName + ".provider", File(path))
        applicationContext.grantUriPermission(applicationContext.packageName, data, Intent.FLAG_GRANT_READ_URI_PERMISSION)
        val sendIntent = Intent("android.intent.action.SEND")
//      sendIntent.setComponent(new ComponentName("com.whatsapp", "com.whatsapp.ContactPicker"));
        sendIntent.putExtra("jid", PhoneNumberUtils.stripSeparators(mobileNo) + "@s.whatsapp.net") //phone number without "+" prefix
        sendIntent.putExtra(Intent.EXTRA_STREAM, data)
        sendIntent.type = "Application/pdf"
        sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        startActivity(sendIntent)
    }

    fun createPdfFromHtml(content: String?, url: String?): CompletableFuture<String> {
        val future = CompletableFuture<String>()
        val webView: WebView = WebView(this)
        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView, url: String) {
                super.onPageFinished(view, url)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    val attributes = PrintAttributes.Builder()
                        .setMediaSize(PrintAttributes.MediaSize.ISO_A4)
                        .setResolution(PrintAttributes.Resolution("pdf", "pdf", 600, 600))
                        .setMinMargins(PrintAttributes.Margins.NO_MARGINS)
                        .build()

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        var name = webView.title
                        val currentTimeMillis = System.currentTimeMillis()
                        val currentDate = Date(currentTimeMillis)
                        val sdf = SimpleDateFormat("dd-MM-yy HH:mm", Locale.getDefault())
                        val formattedDateTime = sdf.format(currentDate)

                        name = name!!.replace("[;\\/:*?\"<>|&']".toRegex(), " ")
                        name += " (PDF GENERATED ON $formattedDateTime) "

                        val fileName = "$name.pdf"
                        val printer = PdfPrinter(attributes)
                        val adapter = webView.createPrintDocumentAdapter(name)
                        val path = applicationContext.filesDir

                        printer.print(adapter, path, fileName, object : PdfPrinter.Callback {
                            override fun onSuccess(filePath: String) {
                                var filePath = filePath
                                if (!filePath.contains(".pdf")) {
                                    filePath = "$filePath.pdf"
                                }
                                // Complete the future with the filePath
                                future.complete(filePath)
                            }

                            override fun onFailure() {
                                Log.e("bulk pdf creating onFailure", "onFailure: ")
                                // Complete the future with an empty string or an error
                                future.completeExceptionally(Throwable("Failed to generate PDF"))
                            }
                        })
                    }
                }
            }
        }
        webView.loadDataWithBaseURL(url, content.toString(), "text/html", "UTF-8", null)
        return future
    }

    fun showLoading(){
//        mProgressDialog.setTitle("Createing pdf")
//        mProgressDialog.setMessage("please wait")
//        mProgressDialog.show()
    }
    fun dismissLoading(){
//        mProgressDialog.dismiss()
    }

    fun printWebPage(webview: WebView) {
        // on below line we are initializing
        // print button pressed variable to true.
        // on below line we are initializing
        // our print manager variable.
        val printManager:PrintManager =
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
                this
                    .getSystemService(Context.PRINT_SERVICE) as PrintManager
            } else {
                TODO("VERSION.SDK_INT < KITKAT")
            }

        // on below line we are creating a variable for job name
        val jobName = " webpage" + "123"
        // on below line we are initializing our print adapter.
        val printAdapter =
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                // on below line we are creating
                // our print document adapter.
                webview.createPrintDocumentAdapter(jobName)
            } else {
                TODO("VERSION.SDK_INT < LOLLIPOP")
            }
        // on below line we are checking id
        // print manager is not null
        assert(printManager != null)

        // on below line we are initializing
        // our print job with print manager
        var printJob: PrintJob
        printJob = printManager.print(
            jobName, printAdapter,
            // on below line we are calling
            // build method for print attributes.
            PrintAttributes.Builder().build()
        )
    }
}

class CustomScannerActivity : CaptureActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        val cameraManager = zxingScannerView.cameraManager
//        cameraManager.setAutofocusInterval(2000L) // Set autofocus interval in milliseconds
    }
    
}



class WebViewManager(private val context: Context) {
    private lateinit var webView: WebView

    @SuppressLint("SetJavaScriptEnabled")
  public  fun openUrl(url: String, arg: Map<String, String>) {
        var UrlLinkUser = arg["UrlLinkUser"].toString()
        var finalurl =url+ UrlLinkUser
        val layout = FrameLayout(context)
        layout.fitsSystemWindows = true
        (context as Activity).setContentView(layout)

        val toolbar = Toolbar(context)
        toolbar.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT)
        toolbar.setBackgroundColor(android.graphics.Color.parseColor("#FF5722"))
        toolbar.title = "UNIQUE"
        layout.addView(toolbar)

        webView = WebView(context)
        webView.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT)
        webView.settings.javaScriptEnabled = true
        webView.settings.domStorageEnabled = true
        webView.settings.setSupportZoom(true)
        webView.settings.allowContentAccess = true
        webView.settings.allowFileAccess = true
        webView.settings.databaseEnabled = true
        webView.webChromeClient = WebChromeClient()
        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                (context as Activity).finish()
            }
            override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
                // Handle href click event here
                if (url != null) {
                    if (url.toString().indexOf("NTAB")>-1) {
                        var finalurl =url+ UrlLinkUser
                        openUrl(finalurl,arg)
                    }
                }
                return true
            }
        }
        layout.addView(webView)

        webView.loadUrl(finalurl)


        toolbar.setNavigationOnClickListener {
            if (webView.canGoBack()) {
                webView.goBack()
            } else {
                (context as Activity).finish()
            }
        }
    }

    fun onBackPressed(): Boolean {
        return if (webView.canGoBack()) {
            webView.goBack()
            true
        } else {
            (context as Activity).finish()
           false
        }
    }
}

