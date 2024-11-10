package kz.milkyland.qr.bridge

import android.util.Log
import androidx.fragment.app.Fragment
import com.google.mlkit.vision.barcode.common.Barcode
import com.google.mlkit.vision.codescanner.GmsBarcodeScannerOptions
import com.google.mlkit.vision.codescanner.GmsBarcodeScanning
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import dev.hotwire.navigation.destinations.HotwireDestination
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kz.milkyland.qr.MilkyLandApplication

class ScannerComponent(
    name: String,
    private val delegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(name, delegate) {

    private val fragment: Fragment
        get() = delegate.destination.fragment

    override fun onReceive(message: Message) {
        when (message.event) {
            "display" -> handleDisplayEvent(message)
            else -> Log.w("ScannerComponent", "Unknown event for message: $message")
        }
    }

    private fun handleDisplayEvent(message: Message) {
        val data = message.data<MessageData>() ?: return
        showScanner(data.title)
    }

    private fun showScanner(title: String) {
        val options = GmsBarcodeScannerOptions.Builder()
            .setBarcodeFormats(Barcode.FORMAT_QR_CODE, Barcode.FORMAT_AZTEC)
            .build()

        val scanner = GmsBarcodeScanning.getClient(MilkyLandApplication.appContext, options)
        scanner.startScan()
            .addOnSuccessListener { barcode ->
                val rawValue: String? = barcode.rawValue
                if (rawValue != null) {
                    onCodeScanned(rawValue)
                }
            }
            .addOnCanceledListener {
                // Task canceled
            }
            .addOnFailureListener { _ ->
                // Task failed with an exception
            }
    }

    private fun onCodeScanned(code: String) {
        replyTo("display", ResponseData(code))
    }

    @Serializable
    data class MessageData(
        @SerialName("title") val title: String
    )

    @Serializable
    data class ResponseData(
        @SerialName("code") val code: String
    )
}