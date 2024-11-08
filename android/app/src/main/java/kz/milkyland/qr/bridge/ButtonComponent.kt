package kz.milkyland.qr.bridge

import android.util.Log
import android.view.LayoutInflater
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.widget.Toolbar
import androidx.fragment.app.Fragment
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import kz.milkyland.qr.R
import kz.milkyland.qr.databinding.ButtonComponentSubmitBinding
import dev.hotwire.navigation.destinations.HotwireDestination
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

class ButtonComponent(
    name: String,
    private val delegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(name, delegate) {

    private val submitButtonItemId = 37
    private var submitMenuItem: MenuItem? = null
    private val fragment: Fragment
        get() = delegate.destination.fragment
    private val toolbar: Toolbar?
        get() = fragment.view?.findViewById(R.id.toolbar)

    override fun onReceive(message: Message) {
        when (message.event) {
            "connect" -> handleConnectEvent(message)
            "submitEnabled" -> handleSubmitEnabled()
            "submitDisabled" -> handleSubmitDisabled()
            else -> Log.w("TurboDemo", "Unknown event for message: $message")
        }
    }

    private fun handleConnectEvent(message: Message) {
        val data = message.data<MessageData>() ?: return
        showToolbarButton(data)
    }

    private fun handleSubmitEnabled() {
        toggleSubmitButton(true)
    }

    private fun handleSubmitDisabled() {
        toggleSubmitButton(false)
    }

    private fun showToolbarButton(data: MessageData) {
        val menu = toolbar?.menu ?: return
        val inflater = LayoutInflater.from(fragment.requireContext())
        val binding = ButtonComponentSubmitBinding.inflate(inflater)
        val order = 999 // Show as the right-most button

        binding.buttonSubmit.apply {
            text = data.title
            setOnClickListener {
                performSubmit()
            }
        }

        menu.removeItem(submitButtonItemId)
        submitMenuItem = menu.add(Menu.NONE, submitButtonItemId, order, data.title).apply {
            actionView = binding.root
            setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
        }
    }

    private fun toggleSubmitButton(enable: Boolean) {
        val layout = submitMenuItem?.actionView ?: return

        ButtonComponentSubmitBinding.bind(layout).apply {
            buttonSubmit.isEnabled = enable
        }
    }

    private fun performSubmit(): Boolean {
        return replyTo("connect")
    }

    @Serializable
    data class MessageData(
        @SerialName("title") val title: String,
        @SerialName("image") val image: String,
        @SerialName("side") val side: String
    )
}