package kz.milkyland.qr.configuration

import kz.milkyland.qr.BuildConfig

//val startLocation = if (BuildConfig.DEBUG) "http://10.0.2.2:3000" else "https://qr.milkyland.kz"
val startLocation = if (BuildConfig.DEBUG) "https://85e7-2-132-108-37.ngrok-free.app" else "https://qr.milkyland.kz"

val configurationURL = "$startLocation/configurations/android.json"
val homeURL = "$startLocation/feed"