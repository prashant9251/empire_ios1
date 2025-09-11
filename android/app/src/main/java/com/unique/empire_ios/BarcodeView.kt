package com.unique.empire_ios

import android.app.Activity
import android.media.MediaPlayer
import android.os.Bundle
import android.util.Log
import android.widget.ToggleButton
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import com.journeyapps.barcodescanner.BarcodeCallback
import com.journeyapps.barcodescanner.BarcodeResult
import com.journeyapps.barcodescanner.DecoratedBarcodeView
import com.journeyapps.barcodescanner.camera.CameraSettings


class BarcodeView : AppCompatActivity() {
    private lateinit var barcodeView: DecoratedBarcodeView
    private lateinit var torchButton: ToggleButton
    var torchOn:Boolean = false
    lateinit var mediaPlayer: MediaPlayer
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_barcode_view)

        // Initialize the DecoratedBarcodeView
        barcodeView = findViewById(R.id.barcode_scanner)
        torchButton = findViewById(R.id.torch_button)
        barcodeView.decodeContinuous(callback)
        // Customize camera settings
        val cameraSettings = barcodeView.barcodeView.cameraSettings
        cameraSettings.focusMode = CameraSettings.FocusMode.CONTINUOUS // Continuous focus
        cameraSettings.setExposureEnabled(true);
        barcodeView.barcodeView.cameraSettings = cameraSettings

        barcodeView.forceLayout()
        torchButton.setOnCheckedChangeListener { _, isChecked ->
            if (isChecked) {
                barcodeView.setTorchOn()
            } else {
                barcodeView.setTorchOff()
            }
        }
        // Start scanning
        barcodeView.resume()
    }
    private fun playSystemSound() {

        try {
            // Initialize the MediaPlayer with the MP3 file from the raw resource folder
            mediaPlayer = MediaPlayer.create(this, R.raw.barcode_beep)

            // Check if mediaPlayer was successfully created
            if (mediaPlayer == null) {
                Log.e("CustomBarcodeActivity", "MediaPlayer creation failed!")
                return
            }

            // Play the sound
            mediaPlayer?.start()

            // Release the MediaPlayer resources after the sound has finished playing
            mediaPlayer?.setOnCompletionListener {
                it.release()
            }
        } catch (e: Exception) {
            Log.e("CustomBarcodeActivity", "Error playing sound: ${e.message}")
        }
    }
    override fun onPause() {
        super.onPause()
        barcodeView.pause()
    }

    override fun onResume() {
        super.onResume()
        barcodeView.resume()
    }
    override fun onDestroy() {
        super.onDestroy()
        barcodeView.pause()
    }
    private val callback = object : BarcodeCallback {
        override fun barcodeResult(result: BarcodeResult) {
            playSystemSound()
            val scannedData = result.text
            val intent = intent
            intent.putExtra("scanned_result", scannedData)
            setResult(Activity.RESULT_OK, intent)
            finish() // Close ScanActivity and return result to MainActivity
        }

        override fun possibleResultPoints(resultPoints: List<com.google.zxing.ResultPoint>) {
            // Handle possible result points if necessary
        }
    }
}