package kz.milkyland.qr

import android.app.Application
import dev.hotwire.core.config.Hotwire
import dev.hotwire.core.bridge.BridgeComponentFactory
import dev.hotwire.core.bridge.KotlinXJsonConverter
import dev.hotwire.core.turbo.config.PathConfiguration
import dev.hotwire.navigation.config.defaultFragmentDestination
import dev.hotwire.navigation.config.registerBridgeComponents
import dev.hotwire.navigation.config.registerFragmentDestinations
import dev.hotwire.navigation.config.registerRouteDecisionHandlers
import dev.hotwire.navigation.routing.AppNavigationRouteDecisionHandler
import dev.hotwire.navigation.routing.BrowserTabRouteDecisionHandler
import kz.milkyland.qr.configuration.configurationURL
import kz.milkyland.qr.features.web.WebFragment
import kz.milkyland.qr.features.web.WebHomeFragment
import kz.milkyland.qr.features.web.WebModalFragment
import kz.milkyland.qr.features.web.WebBottomSheetFragment
import kz.milkyland.qr.bridge.FormComponent
import kz.milkyland.qr.bridge.ButtonComponent
import kz.milkyland.qr.bridge.DropdownComponent

class MilkyLandApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        configureApp()
    }

    private fun configureApp() {
        // Loads the path configuration
        Hotwire.loadPathConfiguration(
            context = this,
            location = PathConfiguration.Location(
                assetFilePath = "json/configuration.json",
                remoteFileUrl = configurationURL
            )
        )

        // Set the default fragment destination
        Hotwire.defaultFragmentDestination = WebFragment::class

        // Register fragment destinations
        Hotwire.registerFragmentDestinations(
            WebFragment::class,
            WebHomeFragment::class,
            WebModalFragment::class,
            WebBottomSheetFragment::class
        )

        // Register bridge components
        Hotwire.registerBridgeComponents(
            BridgeComponentFactory("form", ::FormComponent),
            BridgeComponentFactory("button", ::ButtonComponent),
            BridgeComponentFactory("dropdown", ::DropdownComponent),
        )

        // Register route decision handlers
        Hotwire.registerRouteDecisionHandlers(
            AppNavigationRouteDecisionHandler(),
            BrowserTabRouteDecisionHandler()
        )

        // Set configuration options
        Hotwire.config.debugLoggingEnabled = BuildConfig.DEBUG
        Hotwire.config.webViewDebuggingEnabled = BuildConfig.DEBUG
        Hotwire.config.jsonConverter = KotlinXJsonConverter()
        Hotwire.config.userAgent = "Hotwire MilkyLand; ${Hotwire.config.userAgentSubstring()}"
    }
}