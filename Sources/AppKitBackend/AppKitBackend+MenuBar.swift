import AppKit
import SwiftCrossUI

extension AppKitBackend {
    // You may notice that multiple different base types are used in the
    // action selectors of the various menu items. This is because the
    // selectors get sent to the app's first responder at the time of
    // the command getting sent. If the first responder doesn't have a
    // method matching the selector, then AppKit automatically disables
    // the corresponding menu item.

    private var appMenu: NSMenu {
        // The first menu item is special and always takes on the name of the app.
        let appName = ProcessInfo.processInfo.processName

        let servicesMenu = NSMenuItem(title: "Services", action: nil)
        servicesMenu.submenu = NSMenu(title: "Services")
        NSApplication.shared.servicesMenu = servicesMenu.submenu

        return NSMenu(
            title: appName,
            items: [
                NSMenuItem(
                    title: "About \(appName)",
                    action: #selector(NSApplication.orderFrontStandardAboutPanel(_:))
                ),
                NSMenuItem.separator(),
                servicesMenu,
                NSMenuItem.separator(),
                NSMenuItem(
                    title: "Hide \(appName)",
                    action: #selector(NSApplication.hide(_:)),
                    keyEquivalent: ("h", .command)
                ),
                NSMenuItem(
                    title: "Hide Others",
                    action: #selector(NSApplication.hideOtherApplications(_:)),
                    keyEquivalent: ("h", [.option, .command])
                ),
                NSMenuItem(
                    title: "Show All",
                    action: #selector(NSApplication.unhideAllApplications(_:))
                ),
                NSMenuItem.separator(),
                NSMenuItem(
                    title: "Quit \(appName)",
                    action: #selector(NSApplication.terminate(_:)),
                    keyEquivalent: ("q", .command)
                ),
            ]
        )
    }

    private var fileMenu: NSMenu {
        NSMenu(
            title: "File",
            items: [
                NSMenuItem(
                    title: "Close",
                    action: #selector(NSWindow.performClose(_:)),
                    keyEquivalent: ("w", .command)
                )
            ]
        )
    }

    private var editMenu: NSMenu {
        NSMenu(
            title: "Edit",
            items: [
                // NB: We've failed to find which class (if any) `undo:` and `redo: are supposed
                // to come from, and the following Apple documentation article makes it sound
                // like they're just stringly-typed ObjC messages:
                // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UndoArchitecture/Articles/AppKitUndo.html
                //
                // The double parentheses are needed to silence compiler warnings.
                NSMenuItem(
                    title: "Undo",
                    action: Selector(("undo:")),
                    keyEquivalent: ("z", .command)
                ),
                NSMenuItem(
                    title: "Redo",
                    action: Selector(("redo:")),
                    keyEquivalent: ("z", [.command, .shift])
                ),
                NSMenuItem.separator(),
                NSMenuItem(
                    title: "Cut",
                    action: #selector(NSText.cut(_:)),
                    keyEquivalent: ("x", .command)
                ),
                NSMenuItem(
                    title: "Copy",
                    action: #selector(NSText.copy(_:)),
                    keyEquivalent: ("c", .command)
                ),
                NSMenuItem(
                    title: "Paste",
                    action: #selector(NSText.paste(_:)),
                    keyEquivalent: ("v", .command)
                ),
                NSMenuItem(
                    title: "Delete",
                    action: #selector(NSText.delete(_:))
                ),
                NSMenuItem(
                    title: "Select All",
                    action: #selector(NSText.selectAll(_:)),
                    keyEquivalent: ("a", .command)
                ),
            ]
        )
    }

    private var viewMenu: NSMenu {
        // AppKit adds the default menu items for us.
        NSMenu(title: "View")
    }

    private var windowMenu: NSMenu {
        let minimizeAllItem = NSMenuItem(
            title: "Minimize All",
            action: #selector(NSApplication.miniaturizeAll(_:))
        )
        minimizeAllItem.isAlternate = true

        // FIXME: These items should come first, but currently they're
        //   placed after Remove Window from Set
        let windowMenu = NSMenu(
            title: "Window",
            items: [
                NSMenuItem(
                    title: "Minimize",
                    action: #selector(NSWindow.miniaturize(_:)),
                    keyEquivalent: ("m", .command)
                ),
                minimizeAllItem,
                NSMenuItem(
                    title: "Zoom",
                    action: #selector(NSWindow.zoom(_:))
                )
            ]
        )
        NSApplication.shared.windowsMenu = windowMenu
        return windowMenu
    }

    private var helpMenu: NSMenu {
        let helpMenu = NSMenu(title: "Help")
        NSApplication.shared.helpMenu = helpMenu
        return helpMenu
    }

    public func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu]) {
        let menuBar = NSMenu()

        for menu in [appMenu, fileMenu, editMenu, viewMenu] {
            let menuItem = NSMenuItem()
            menuItem.submenu = menu
            menuBar.addItem(menuItem)
        }

        for submenu in submenus {
            let renderedSubmenu = Self.renderSubmenu(submenu)
            menuBar.addItem(renderedSubmenu)
        }

        for menu in [windowMenu, helpMenu] {
            let menuItem = NSMenuItem()
            menuItem.submenu = menu
            menuBar.addItem(menuItem)
        }

        NSApplication.shared.mainMenu = menuBar
    }
}

extension NSMenuItem {
    convenience init(
        title: String,
        action selector: Selector?,
        keyEquivalent: (String, NSEvent.ModifierFlags)? = nil
    ) {
        self.init(title: title, action: selector, keyEquivalent: keyEquivalent?.0 ?? "")
        if let modifiers = keyEquivalent?.1 {
            self.keyEquivalentModifierMask = modifiers
        }
    }
}

extension NSMenu {
    convenience init(title: String, items: [NSMenuItem]) {
        self.init(title: title)
        self.items = items
    }
}
