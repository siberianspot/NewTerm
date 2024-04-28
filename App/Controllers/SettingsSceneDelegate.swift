//
//  SettingsSceneDelegate.swift
//  NewTerm (iOS)
//
//  Created by Adam Demasi on 9/4/21.
//

import UIKit
import SwiftUI

extension NSUserActivity {
	static let settingsScene = NSUserActivity(activityType: SettingsSceneDelegate.activityType)
}

class SettingsSceneDelegate: UIResponder, UIWindowSceneDelegate, IdentifiableSceneDelegate {

	static let activityType = "ws.hbang.Terminal.SettingsSceneActivity"

	var window: UIWindow?
	private var windowScene: UIWindowScene!

	private var windowSize: CGSize {
		get { windowScene.sizeRestrictions?.minimumSize ?? .zero }
		set {
			windowScene.sizeRestrictions?.minimumSize = newValue
			windowScene.sizeRestrictions?.maximumSize = newValue
		}
	}

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else {
			return
		}

		self.windowScene = windowScene

		window = UIWindow(windowScene: windowScene)
		window!.tintColor = .tint

#if targetEnvironment(macCatalyst)
		windowScene.title = .localize("SETTINGS_GENERAL", comment: "Settings toolbar item 'general' label")
#else
		windowScene.title = .localize("SETTINGS", comment: "Title of Settings page.")
#endif

#if targetEnvironment(macCatalyst)
		windowScene.titlebar?.toolbarStyle = .preference
		windowScene.titlebar?.separatorStyle = .line

		let toolbar = NSToolbar(identifier: "settings-toolbar")
		toolbar.delegate = self
		toolbar.displayMode = .iconAndLabel
		toolbar.selectedItemIdentifier = .general
		windowScene.titlebar?.toolbar = toolbar

		UIView.performWithoutAnimation {
			selectGeneralTab()
		}
#else
		window!.rootViewController = UIHostingController(rootView: SettingsView(windowScene: windowScene))
#endif

		window!.makeKeyAndVisible()
	}

}

#if targetEnvironment(macCatalyst)
private extension NSToolbarItem.Identifier {
	static let general     = NSToolbarItem.Identifier("general")
	static let interface   = NSToolbarItem.Identifier("interface")
	static let performance = NSToolbarItem.Identifier("performance")
	static let advanced    = NSToolbarItem.Identifier("advanced")
}

extension SettingsSceneDelegate: NSToolbarDelegate {

	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		[ .general, .interface, .performance, .advanced ]
	}

	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarDefaultItemIdentifiers(toolbar)
	}

	func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarDefaultItemIdentifiers(toolbar)
	}

	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {

		switch itemIdentifier {
		case .general:
			return makeToolbarItem(itemIdentifier: itemIdentifier,
														 label: .localize("SETTINGS_GENERAL", comment: "Settings toolbar item 'general' label"),
														 icon: "gear",
														 action: #selector(selectGeneralTab))

		case .interface:
			return makeToolbarItem(itemIdentifier: itemIdentifier,
														 label: .localize("SETTINGS_INTERFACE", comment: "Settings toolbar item 'interface' label"),
														 icon: "macwindow",
														 action: #selector(selectInterfaceTab))

		case .performance:
			return makeToolbarItem(itemIdentifier: itemIdentifier,
														 label: .localize("SETTINGS_PERFORMANCE", comment: "Settings toolbar item 'performance' label"),
														 icon: "hare",
														 action: #selector(selectPerformanceTab))

		case .advanced:
			return makeToolbarItem(itemIdentifier: itemIdentifier,
														 label: .localize("SETTINGS_ADVANCED", comment: "Settings toolbar item 'advanced' label"),
														 icon: "sparkles",
														 action: #selector(selectAdvancedTab))

		default:
			return nil
		}
	}

	private func makeToolbarItem(itemIdentifier: NSToolbarItem.Identifier, label: String, icon: String, action: Selector) -> NSToolbarItem {
		let configuration = UIImage.SymbolConfiguration(scale: .large)
		let item = NSToolbarItem(itemIdentifier: itemIdentifier)
		item.label = label
		item.image = UIImage(systemName: icon, withConfiguration: configuration)
		item.isNavigational = true
		item.target = self
		item.action = action
		return item
	}

	private func switchTab<Content: View>(rootView: Content, size: CGSize = CGSize(width: 600, height: 500), animated: Bool = true) {
		window?.rootViewController = UIHostingController(rootView: rootView)

		if animated {
			UIView.animate(withDuration: 0.3) {
				self.windowSize = size
			}
		} else {
			windowSize = size
		}

		if let toolbar = windowScene.titlebar?.toolbar,
			 let item = toolbar.items.first(where: { item in item.itemIdentifier == toolbar.selectedItemIdentifier }) {
			windowScene.title = item.label
		}
	}

	@objc private func selectGeneralTab() {
		switchTab(rootView: SettingsGeneralView(), size: CGSize(width: 600, height: 500))
	}

	@objc private func selectInterfaceTab() {
		switchTab(rootView: SettingsInterfaceView(), size: CGSize(width: 600, height: 500))
	}

	@objc private func selectPerformanceTab() {
		switchTab(rootView: SettingsPerformanceView(), size: CGSize(width: 600, height: 500))
	}

	@objc private func selectAdvancedTab() {
		switchTab(rootView: SettingsAdvancedView(), size: CGSize(width: 600, height: 500))
	}

}
#endif
