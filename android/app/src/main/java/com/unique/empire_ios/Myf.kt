package com.unique.empire_ios

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
import android.os.Build
import android.print.PdfPrinter
import android.print.PrintAttributes
import android.print.PrintDocumentAdapter
import android.print.PrintManager
import android.telephony.PhoneNumberUtils
import android.util.Log
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.content.FileProvider
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.CompletableFuture


class Myf(private val activity: Activity) {
   public fun getValFromSavedPref(databaseID: String, key: String): String {
        var pref: SharedPreferences = activity.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val valFromPrefs = pref.getString("flutter.$key$databaseID", "") ?: ""
        return nullC(valFromPrefs)
    }
    fun setValInSavedPref(databaseID: String, key: String, value: String) {
        val pref: SharedPreferences = activity.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val editor = pref.edit()
        editor.putString("flutter.$key$databaseID", value)
        editor.apply()
    }
   public fun nullC(value: String?): String {
        return value ?: ""
    }
   public  fun getUrlParams(url: String,key: String): String {
        val WebViewLoadUri: Uri = Uri.parse(url)
        var value: String? = null
        try {
            return WebViewLoadUri.getQueryParameter("$key").toString()
        } catch (e: Exception) {
            // Handle exception
            return  ""
        }
    }

    fun sendFile(f: File, fileName: String) {
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = "application/pdf"
        val uri = FileProvider.getUriForFile(activity, activity.getPackageName() + ".provider", f)
            activity.grantUriPermission(
                activity.getPackageName(),
            uri,
            Intent.FLAG_GRANT_READ_URI_PERMISSION
        )
        shareIntent.putExtra(Intent.EXTRA_STREAM, uri)
        shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            activity.startActivity(Intent.createChooser(shareIntent, fileName))
    }

    fun sendToWhatsapp(
        f: File,
        mobileNo: String?,
        fileName: String?,
        extraFileListForShare: List<String>
    ) {
        if (extraFileListForShare.size > 0) {
            val uris = getListOfUriFile(extraFileListForShare)
            val sendIntent = Intent(Intent.ACTION_SEND_MULTIPLE)
            sendIntent.type = "*/*"
            sendIntent.putExtra(
                "jid",
                PhoneNumberUtils.stripSeparators(mobileNo) + "@s.whatsapp.net"
            ) //phone number without "+" prefix
            sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            sendIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
//            sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            //      getContext().startActivity(sendIntent);
            activity.startActivity(sendIntent)
            return
        }
        val data =
            FileProvider.getUriForFile(activity, activity.getPackageName() + ".provider", f)
        // getContext().grantUriPermission(getContext().getPackageName(), data, Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        Log.d("---new_f", f.toString())
        val sendIntent = Intent("android.intent.action.SEND")
        //              intentsharepdf.putExtra(Intent.EXTRA_EMAIL, new String[]{Email});
        val resInfoList: List<ResolveInfo> = activity.getPackageManager()
            .queryIntentActivities(sendIntent, PackageManager.MATCH_DEFAULT_ONLY)
        for (resolveInfo in resInfoList) {
            val packageName = resolveInfo.activityInfo.packageName
            activity.grantUriPermission(
                packageName,
                data,
                Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
        }
        sendIntent.putExtra(
            "jid",
            PhoneNumberUtils.stripSeparators(mobileNo) + "@s.whatsapp.net"
        ) //phone number without "+" prefix
        sendIntent.putExtra(Intent.EXTRA_STREAM, data)
        sendIntent.type = "Application/pdf"
        sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        activity.startActivity(sendIntent)
    }
    fun getListOfUriFile(extraFileListForShare: List<String>): java.util.ArrayList<Uri> {
        val uris = java.util.ArrayList<Uri>()
        for (npath in extraFileListForShare) {
            val file = File(npath)
            if (file.exists()) {
                val uri: Uri = resolveUriPermission(file)
                uris.add(uri)
            } else {
                Toast.makeText(activity, "File not found: $npath", Toast.LENGTH_SHORT).show()
            }
        }
        return uris
    }
    fun resolveUriPermission(f: File?): Uri {
        val data = FileProvider.getUriForFile(
            activity, activity.getPackageName() + ".provider",
            f!!
        )
        activity.grantUriPermission(
            activity.getPackageName(),
            data,
            Intent.FLAG_GRANT_READ_URI_PERMISSION
        )
        return data
    }
    fun sendToView(f: File?) {
        val data = FileProvider.getUriForFile(
            activity, activity.getPackageName() + ".provider",
            f!!
        )
        val intent = Intent(Intent.ACTION_VIEW)
        intent.setDataAndType(data, "application/pdf")
        val resInfoList: List<ResolveInfo> = activity.getPackageManager()
            .queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
        for (resolveInfo in resInfoList) {
            val packageName = resolveInfo.activityInfo.packageName
            activity.grantUriPermission(
                packageName,
                data,
                Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
        }
        try {
            activity.startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            // If no suitable PDF viewer app is found, display an error message
            Toast.makeText(activity, "No PDF viewer app installed", Toast.LENGTH_LONG).show()
        }
    }

    fun sendToEmail(
        f: File?,
        email: String,
        fileName: String?,
        extraFileListForShare: List<String>
    ) {
        if (extraFileListForShare.size > 0) {
            val uris = getListOfUriFile(extraFileListForShare)
            val intentsharepdf = Intent(Intent.ACTION_SEND_MULTIPLE)
            intentsharepdf.type = "*/*"
            intentsharepdf.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
            intentsharepdf.type = "vnd.android.cursor.dir/email"
            intentsharepdf.putExtra(Intent.EXTRA_EMAIL, arrayOf(email))
            intentsharepdf.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            activity.startActivity(Intent.createChooser(intentsharepdf, fileName))
            return
        }
        val data = FileProvider.getUriForFile(
            activity, activity.getPackageName() + ".provider",
            f!!
        )
        val intentsharepdf = Intent(Intent.ACTION_SEND)
        val resInfoList: List<ResolveInfo> = activity.getPackageManager()
            .queryIntentActivities(intentsharepdf, PackageManager.MATCH_DEFAULT_ONLY)
        for (resolveInfo in resInfoList) {
            val packageName = resolveInfo.activityInfo.packageName
            activity.grantUriPermission(
                packageName,
                data,
                Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
        }
        intentsharepdf.type = "application/pdf"
        intentsharepdf.type = "vnd.android.cursor.dir/email"
        intentsharepdf.putExtra(Intent.EXTRA_EMAIL, arrayOf(email))
        intentsharepdf.putExtra(Intent.EXTRA_STREAM, data)
        intentsharepdf.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        activity.startActivity(Intent.createChooser(intentsharepdf, fileName))
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    fun printCurrentPage(webview: WebView) {
        // Get a PrintManager instance
        val printManager =
            activity.getSystemService(Context.PRINT_SERVICE) as PrintManager
        if (printManager != null) {
            val jobName: String =  "Document"

            // Get a printCurrentPage adapter instance
            val printAdapter: PrintDocumentAdapter = webview.createPrintDocumentAdapter(jobName)

            // Create a printCurrentPage job with name and adapter instance
            printManager.print(
                jobName, printAdapter,
                PrintAttributes.Builder().build()
            )
        } else {
//                Log.e(InAppWebView.LOG_TAG, "No PrintManager available")
        }

    }

    fun createPdfFromHtml(context: Context,content: String?, url: String?): CompletableFuture<String> {
        val future = CompletableFuture<String>()
        val webView: WebView = WebView(context)
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
                        val path = context.filesDir

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
}


