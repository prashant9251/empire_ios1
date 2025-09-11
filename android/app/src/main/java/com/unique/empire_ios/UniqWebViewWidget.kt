package com.unique.empire_ios

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.os.Build
import android.print.PrintAttributes
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import com.crazecoder.openfile.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.io.File

class UniqWebViewWidget internal  constructor(context:Context,id:Int,messenger: BinaryMessenger):PlatformView,MethodChannel.MethodCallHandler{
    private  var context:Context=context;
    private  var view:View=LayoutInflater.from(context).inflate(R.layout.activity_web_view_screen,null)
    private val webView: WebView = view.findViewById(R.id.webViewScreenUniq)

    private  val methodChannel:MethodChannel= MethodChannel(messenger,"plugin/uniq_webview_$id")
    override fun getView(): View {
        return  view;
    }

    init {
        methodChannel.setMethodCallHandler(this)
        webView.settings.javaScriptEnabled = true
        webView.settings.domStorageEnabled = true
        webView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        webView.settings.setSupportZoom(true)
        webView.settings.allowContentAccess = true
        webView.settings.allowFileAccess = true
        webView.settings.databaseEnabled = true
        webView.webChromeClient = WebChromeClient()
        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {

//                if (url != null) {
//                    if (url.contains("NTAB")) {
//                        methodChannel.invokeMethod("shouldOverrideUrlLoading",url)
//                        return super.shouldOverrideUrlLoading(view, url)
//                    }
//                }
                return super.shouldOverrideUrlLoading(view, url)
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method){
            "loadUrl"->loadUrl(call,result)
            else->result.notImplemented()
        }
    }

    private fun loadUrl(call: MethodCall, result: MethodChannel.Result) {
        var url:String=call.arguments as String
        webView.loadUrl(url)
        result.success(null)
    }

    override fun dispose() {

    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
    }

    override fun onInputConnectionLocked() {
        super.onInputConnectionLocked()
    }

    override fun onInputConnectionUnlocked() {
        super.onInputConnectionUnlocked()
    }

    private val touchListener:View.OnTouchListener=object :View.OnTouchListener{
        override fun onTouch(p0: View?, p1: MotionEvent?): Boolean {
            return  true
        }
    }

    // private fun createPdf(call: MethodCall, result: MethodChannel.Result) {
    //     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
    //         val attributes = PrintAttributes.Builder()
    //             .setMediaSize(PrintAttributes.MediaSize.ISO_A4)
    //             .setResolution(PrintAttributes.Resolution("pdf", "pdf", 600, 600))
    //             .setMinMargins(PrintAttributes.Margins.NO_MARGINS).build()

    //         val printer = PdfPrinter(attributes)
    //         val adapter = webView.createPrintDocumentAdapter(HtmlToPdfConverter.temporaryDocumentName)
    //         val path = context.filesDir
    //         var title=webView.title;
    //         printer.print(adapter, path, "${title}.pdf", object : PdfPrinter.Callback {
    //             override fun onSuccess(filePath: String) {
    //                 val uri = FileProvider.getUriForFile(context, context.packageName + ".provider", File(filePath))

    //                 val intent = Intent(Intent.ACTION_VIEW)
    //                 intent.setDataAndType(uri, "application/pdf") // Change the MIME type as needed for different file types
    //                 intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    //                 intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

    //                 try {
    //                     context.startActivity(intent)
    //                 } catch (e: ActivityNotFoundException) {
    //                     // Handle case where no application is available to open the file
    //                 }
    //             }

    //             override fun onFailure() {

    //             }
    //         })
        // }
        // result.success(null)
    // }
}