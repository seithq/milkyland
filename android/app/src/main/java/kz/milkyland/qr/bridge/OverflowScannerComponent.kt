package kz.milkyland.qr.bridge

import android.util.Log
import androidx.appcompat.widget.Toolbar
import androidx.fragment.app.Fragment
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import kz.milkyland.qr.R
import dev.hotwire.navigation.destinations.HotwireDestination
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

class OverflowScannerComponent(
    name: String,
    private val delegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(name, delegate) {

    private val fragment: Fragment
        get() = delegate.destination.fragment
    private val toolbar: Toolbar?
        get() = fragment.view?.findViewById(R.id.toolbar)

    override fun onReceive(message: Message) {
        when (message.event) {
            "connect" -> handleConnectEvent(message)
            else -> Log.w("OverflowScannerComponent", "Unknown event for message: $message")
        }
    }

    private fun handleConnectEvent(message: Message) {
        val data = message.data<MessageData>() ?: return
        showOverflowMenuItem(data)
    }

    private fun showOverflowMenuItem(data: MessageData) {
        val toolbar = toolbar ?: return

        toolbar.menu.findItem(R.id.scanner)?.apply {
            isVisible = true
            title = data.title
        }

        toolbar.setOnMenuItemClickListener {
            when (it.itemId) {
                R.id.scanner -> {
                    performClick()
                    true
                }
                else -> false
            }
        }
    }

    private fun performClick() {
        replyTo("connect")
    }

    @Serializable
    data class MessageData(
        @SerialName("title") val title: String
    )
}