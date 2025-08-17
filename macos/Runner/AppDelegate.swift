// AppDelegate.swift
// 
// Main app delegate for the Findr macOS application
// 
// Provides the entry point for the Flutter application on macOS platform.
// 
// Author: Siddak Bath
// Created: [17/07/2025]
// Last Modified: [05/08/2025]
// Version: v1

import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
