// AppDelegate.swift
// 
// Main app delegate for the Findr iOS application
// 
// Provides the entry point for the Flutter application on iOS platform.
// 
// Author: Siddak Bath
// Created: [17/07/2025]
// Last Modified: [05/08/2025]
// Version: v1

import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
