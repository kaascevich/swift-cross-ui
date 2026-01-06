import Foundation
import SwiftCrossUI

extension DummyBackend {
    public class Window {
        static let defaultSize = SIMD2<Int>(400, 200)
        
        public var size: SIMD2<Int>
        public var minimumSize: SIMD2<Int> = .zero
        public var title = "Window"
        public var resizable = true
        public var content: Widget?
        public var resizeHandler: ((SIMD2<Int>) -> Void)?
        public var sheet: Sheet?

        public var environmentChangeHandler: (() -> Void)?
        public var isShown = false
        
        public init(defaultSize: SIMD2<Int>?) {
            size = defaultSize ?? Self.defaultSize
        }
    }
    
    public class Widget {
        public var tag: String?
        public var isShown = false
        public var cornerRadius = 0
        public var size = SIMD2<Int>.zero
        public var naturalSize: SIMD2<Int> {
            SIMD2<Int>.zero
        }
        
        public func getChildren() -> [Widget] {
            []
        }
        
        /// Finds the first widget of type `T` in the hierarchy defined by this
        /// widget (including the widget itself).
        public func firstWidget<T: Widget>(ofType type: T.Type) -> T? {
            let iterator = BreadthFirstWidgetIterator(for: self)
            while let child = iterator.next() {
                if let child = child as? T {
                    return child
                }
            }
            return nil
        }
    }
    
    public class Button: Widget {
        public var label = ""
        public var font: Font.Resolved?
        public var action: (() -> Void)?
        public var menu: Menu?
        public var isEnabled = true
    }
    
    public class ToggleButton: Widget {
        public var label = ""
        public var font: Font.Resolved?
        public var toggleHandler: ((Bool) -> Void)?
        public var state = false
        public var isEnabled = true
    }
    
    public class ToggleSwitch: Widget {
        public var toggleHandler: ((Bool) -> Void)?
        public var state = false
        public var isEnabled = true
        
        override public var naturalSize: SIMD2<Int> {
            SIMD2(20, 10)
        }
    }
    
    public class Checkbox: Widget {
        public var toggleHandler: ((Bool) -> Void)?
        public var state = false
        public var isEnabled = true
        
        override public var naturalSize: SIMD2<Int> {
            SIMD2(10, 10)
        }
    }
    
    public class Slider: Widget {
        public var value: Double = 0
        public var minimumValue: Double = 0
        public var maximumValue: Double = 100
        public var decimalPlaces = 1
        public var changeHandler: ((Double) -> Void)?
        public var isEnabled = true
        
        override public var naturalSize: SIMD2<Int> {
            SIMD2(20, 10)
        }
    }
    
    public class TextField: Widget {
        public var value = ""
        public var placeholder = ""
        public var font: Font.Resolved?
        public var changeHandler: ((String) -> Void)?
        public var submitHandler: (() -> Void)?
        public var isEnabled = true
    }
    
    public class TextEditor: Widget {
        public var value = ""
        public var font: Font.Resolved?
        public var changeHandler: ((String) -> Void)?
        public var isEnabled = true
    }

    public class Picker: Widget {
        public var options: [String] = []
        public var selectedOption: Int?
        public var font: Font.Resolved?
        public var changeHandler: ((Int?) -> Void)?
        public var isEnabled = true
    }

    public class TextView: Widget {
        public var content: String = ""
        public var font: Font.Resolved?
        public var color = Color.black
        public var isSelectable = false
    }
    
    public class ImageView: Widget {
        public var rgbaData: [UInt8] = []
        public var pixelWidth = 0
        public var pixelHeight = 0
    }
    
    public class ProgressSpinner: Widget {}

    public class ProgressBar: Widget {
        public var fraction: Double?
    }

    public class Table: Widget {
        public var rowCount = 0
        public var columnLabels: [String] = []
        public var cells: [Widget] = []
        public var rowHeights: [Int] = []
        
        public override func getChildren() -> [Widget] {
            cells
        }
    }
    
    public class Container: Widget {
        public var children: [(widget: Widget, position: SIMD2<Int>)] = []
        
        public override func getChildren() -> [Widget] {
            children.map(\.widget)
        }
    }
    
    public class ScrollContainer: Widget {
        public var child: Widget
        public var hasVerticalScrollBar = false
        public var hasHorizontalScrollBar = false
        
        public init(child: Widget) {
            self.child = child
        }
        
        public override func getChildren() -> [Widget] {
            [child]
        }
    }
    
    public class SelectableListView: Widget {
        public var items: [Widget] = []
        public var rowHeights: [Int] = []
        public var selectionHandler: ((Int) -> Void)?
        public var selectedIndex: Int?
        
        public override func getChildren() -> [Widget] {
            items
        }
    }
    
    public class Rectangle: Widget {
        public var color = Color.clear
    }
    
    public class SplitView: Widget {
        public var leadingChild: Widget
        public var trailingChild: Widget
        
        public var sidebarResizeHandler: (() -> Void)?
        
        private var _sidebarWidth = 100
        
        public var sidebarWidth: Int {
            get {
                _sidebarWidth
            }
            set {
                var width = newValue
                if let minimumSidebarWidth {
                    width = max(minimumSidebarWidth, width)
                }
                if let maximumSidebarWidth {
                    width = min(maximumSidebarWidth, width)
                }
                width = max(0, min(size.x, width))
                _sidebarWidth = width
            }
        }
        
        public var minimumSidebarWidth: Int? {
            didSet {
                if let minimumSidebarWidth {
                    sidebarWidth = max(minimumSidebarWidth, sidebarWidth)
                }
            }
        }
        
        public var maximumSidebarWidth: Int? {
            didSet {
                if let maximumSidebarWidth {
                    sidebarWidth = min(maximumSidebarWidth, sidebarWidth)
                }
            }
        }
        
        override public var size: SIMD2<Int> {
            didSet {
                if sidebarWidth > size.x {
                    sidebarWidth = size.x
                }
            }
        }
        
        public init(leadingChild: Widget, trailingChild: Widget) {
            self.leadingChild = leadingChild
            self.trailingChild = trailingChild
        }
        
        public override func getChildren() -> [Widget] {
            [leadingChild, trailingChild]
        }
    }

    public class WebView: Widget {
        public var url: URL?
        public var navigationHandler: ((URL) -> Void)?

        public func navigate(to url: URL) {
            self.url = url
            navigationHandler?(url)
        }
    }

    public class Menu {
        public var content = ResolvedMenu(items: [])
        public var isEnabled = true

        public var revealed: Revealed?
        public class Revealed {
            public var position: SIMD2<Int>
            public var widget: Widget
            public var closeHandler: () -> Void

            public init(position: SIMD2<Int>, widget: Widget, closeHandler: @escaping () -> Void) {
                self.position = position
                self.widget = widget
                self.closeHandler = closeHandler
            }
        }
    }
    
    public class Alert {
        public var title = "Alert"
        public var actionLabels: [String] = []

        public var shown: Shown?
        public class Shown {
            public var window: Window?
            public var responseHandler: (Int) -> Void

            public init(window: Window? = nil, responseHandler: @escaping (Int) -> Void) {
                self.window = window
                self.responseHandler = responseHandler
            }
        }
    }
    
    public class Path {}

    public class Sheet {
        public var nestedSheet: Sheet?
        public var size = SIMD2<Int>.zero
        public var dismissHandler: (() -> Void)?
        public var cornerRadius: Double?
        public var detents: [SwiftCrossUI.PresentationDetent] = []
        public var dragIndicatorVisibility = SwiftCrossUI.Visibility.automatic
        public var backgroundColor: SwiftCrossUI.Color?
        public var interactiveDismissDisabled = false
    }
}
