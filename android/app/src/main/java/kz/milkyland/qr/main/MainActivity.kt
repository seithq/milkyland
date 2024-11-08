package kz.milkyland.qr.main

import android.os.Bundle
import dev.hotwire.navigation.activities.HotwireActivity
import dev.hotwire.navigation.navigator.NavigatorConfiguration
import kz.milkyland.qr.R
import kz.milkyland.qr.configuration.homeURL

class MainActivity : HotwireActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    override fun navigatorConfigurations() = listOf(
        NavigatorConfiguration(
            name = "main",
            startLocation = homeURL,
            navigatorHostId = R.id.main_nav_host
        )
    )
}