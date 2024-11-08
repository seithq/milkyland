package kz.milkyland.qr.bridge

import android.util.Log
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.widget.Toolbar
import androidx.fragment.app.Fragment
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import kz.milkyland.qr.R
import dev.hotwire.navigation.destinations.HotwireDestination
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

class DropdownComponent(
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
            else -> Log.w("TurboDemo", "Unknown event for message: $message")
        }
    }

    private fun handleConnectEvent(message: Message) {
        val data = message.data<MessageData>() ?: return
        showToolbarButton(data)
    }

    private fun showToolbarButton(data: MessageData) {
        val menu = toolbar?.menu ?: return

        for (item in data.items) {
            val order = item.index.toInt()

            menu.removeItem(order)
            menu.add(Menu.NONE, order, order, item.title).apply {
                setOnMenuItemClickListener(fun(item: MenuItem): Boolean {
                    performSubmit(item.order.toString())
                    return true
                })
            }
        }
    }

    private fun performSubmit(index: String): Boolean {
        return replyTo("connect", ResponseData(index = index))
    }

    @Serializable
    data class MessageData(
        @SerialName("title") val title: String,
        @SerialName("side") val side: String,
        @SerialName("items") val items: List<DropdownItem>,
    )

    @Serializable
    data class DropdownItem(
        @SerialName("title") val title: String,
        @SerialName("image") val image: String,
        @SerialName("index") val index: String
    )

    @Serializable
    data class ResponseData(
        @SerialName("index") val index: String
    )
}