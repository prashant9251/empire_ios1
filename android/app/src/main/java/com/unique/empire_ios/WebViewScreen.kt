package com.unique.empire_ios

import android.os.Bundle
import com.journeyapps.barcodescanner.CaptureActivity

class CustomScannerActivityWeb : CaptureActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        val cameraManager = zxingScannerView.cameraManager
//        cameraManager.setAutofocusInterval(2000L) // Set autofocus interval in milliseconds
    }

}