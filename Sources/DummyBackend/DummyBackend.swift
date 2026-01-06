import Foundation
import SwiftCrossUI

public final class DummyBackend: AppBackend {
    public class BreadthFirstWidgetIterator: IteratorProtocol {
        var queue: [Widget]

        init(for widget: Widget) {
            queue = [widget]
        }

        public func next() -> Widget? {
            guard let next = queue.first else {
                return nil
            }
            queue.removeFirst()
            queue.append(contentsOf: next.getChildren())
            return next
        }
    }
    
    public var defaultTableRowContentHeight = 10
    public var defaultTableCellVerticalPadding = 10
    public var defaultPaddingAmount = 10
    public var scrollBarWidth = 8
    public var requiresToggleSwitchSpacer = false
    public var requiresImageUpdateOnScaleFactorChange = false
    public var menuImplementationStyle = MenuImplementationStyle.dynamicPopover
    public var deviceClass = DeviceClass.desktop
    public var canRevealFiles = false

    public var incomingURLHandler: ((URL) -> Void)?
    public var currentlyActivatedWindow: Window?
    public var rootEnvironmentChangeHandler: (() -> Void)?

    public init() {}

    public func runMainLoop(_ callback: @escaping @MainActor () -> Void) {
        callback()
    }

    public func createWindow(withDefaultSize defaultSize: SIMD2<Int>?) -> Window {
        Window(defaultSize: defaultSize)
    }

    public func setTitle(ofWindow window: Window, to title: String) {
        window.title = title
    }

    public func setResizability(ofWindow window: Window, to resizable: Bool) {
        window.resizable = resizable
    }

    public func setChild(ofWindow window: Window, to child: Widget) {
        window.content = child
    }

    public func size(ofWindow window: Window) -> SIMD2<Int> {
        window.size
    }

    public func isWindowProgrammaticallyResizable(_ window: Window) -> Bool {
        true
    }

    public func setSize(ofWindow window: Window, to newSize: SIMD2<Int>) {
        window.size = newSize
    }

    public func setMinimumSize(ofWindow window: Window, to minimumSize: SIMD2<Int>) {
        window.minimumSize = minimumSize
    }

    public func setResizeHandler(ofWindow window: Window, to action: @escaping (SIMD2<Int>) -> Void)
    {
        window.resizeHandler = action
    }

    public func show(window: Window) {
        window.isShown = true
        currentlyActivatedWindow = window
    }

    public func activate(window: Window) {
        currentlyActivatedWindow = window
    }

    public func runInMainThread(action: @escaping @MainActor () -> Void) {
        DispatchQueue.main.async {
            action()
        }
    }

    public func computeRootEnvironment(defaultEnvironment: EnvironmentValues) -> EnvironmentValues {
        defaultEnvironment
    }

    public func setRootEnvironmentChangeHandler(to action: @escaping () -> Void) {
        rootEnvironmentChangeHandler = action
    }

    public func computeWindowEnvironment(
        window: Window,
        rootEnvironment: EnvironmentValues
    ) -> EnvironmentValues {
        rootEnvironment
    }

    public func setWindowEnvironmentChangeHandler(
        of window: Window,
        to action: @escaping () -> Void
    ) {
        window.environmentChangeHandler = action
    }

    public func setIncomingURLHandler(to action: @escaping (URL) -> Void) {
        incomingURLHandler = action
    }

    public func show(widget: Widget) {
        widget.isShown = true
    }

    public func tag(widget: Widget, as tag: String) {
        widget.tag = tag
    }

    public func createContainer() -> Widget {
        Container()
    }

    public func removeAllChildren(of container: Widget) {
        (container as! Container).children = []
    }

    public func addChild(_ child: Widget, to container: Widget) {
        (container as! Container).children.append((child, .zero))
    }

    public func setPosition(ofChildAt index: Int, in container: Widget, to position: SIMD2<Int>) {
        (container as! Container).children[index].position = position
    }

    public func removeChild(_ child: Widget, from container: Widget) {
        let container = container as! Container
        let index = container.children.firstIndex { (widget, position) in
            widget === child
        }
        if let index {
            container.children.remove(at: index)
        }
    }

    public func createColorableRectangle() -> Widget {
        Rectangle()
    }

    public func setColor(ofColorableRectangle widget: Widget, to color: Color) {
        (widget as! Rectangle).color = color
    }

    public func setCornerRadius(of widget: Widget, to radius: Int) {
        widget.cornerRadius = radius
    }

    public func naturalSize(of widget: Widget) -> SIMD2<Int> {
        widget.naturalSize
    }

    public func setSize(of widget: Widget, to size: SIMD2<Int>) {
        widget.size = size
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        ScrollContainer(child: child)
    }

    public func updateScrollContainer(_ scrollView: Widget, environment: EnvironmentValues) {}

    public func setScrollBarPresence(
        ofScrollContainer scrollView: Widget,
        hasVerticalScrollBar: Bool,
        hasHorizontalScrollBar: Bool
    ) {
        let scrollContainer = scrollView as! ScrollContainer
        scrollContainer.hasVerticalScrollBar = hasVerticalScrollBar
        scrollContainer.hasHorizontalScrollBar = hasHorizontalScrollBar
    }

    public func createSelectableListView() -> Widget {
        SelectableListView()
    }

    public func baseItemPadding(ofSelectableListView listView: Widget) -> EdgeInsets {
        EdgeInsets(top: 0, bottom: 0, leading: 0, trailing: 0)
    }

    public func minimumRowSize(ofSelectableListView listView: Widget) -> SIMD2<Int> {
        .zero
    }

    public func setItems(
        ofSelectableListView listView: Widget,
        to items: [Widget],
        withRowHeights rowHeights: [Int]
    ) {
        let selectableListView = listView as! SelectableListView
        selectableListView.items = items
        selectableListView.rowHeights = rowHeights
    }

    public func setSelectionHandler(
        forSelectableListView listView: Widget,
        to action: @escaping (Int) -> Void
    ) {
        (listView as! SelectableListView).selectionHandler = action
    }

    public func setSelectedItem(ofSelectableListView listView: Widget, toItemAt index: Int?) {
        (listView as! SelectableListView).selectedIndex = index
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        SplitView(leadingChild: leadingChild, trailingChild: trailingChild)
    }

    public func setResizeHandler(ofSplitView splitView: Widget, to action: @escaping () -> Void) {
        (splitView as! SplitView).sidebarResizeHandler = action
    }

    public func sidebarWidth(ofSplitView splitView: Widget) -> Int {
        (splitView as! SplitView).sidebarWidth
    }

    public func setSidebarWidthBounds(
        ofSplitView splitView: Widget,
        minimum minimumWidth: Int,
        maximum maximumWidth: Int
    ) {
        let splitView = splitView as! SplitView
        splitView.minimumSidebarWidth = minimumWidth
        splitView.maximumSidebarWidth = maximumWidth
    }

    public func size(
        of text: String,
        whenDisplayedIn widget: Widget,
        proposedWidth: Int?,
        proposedHeight: Int?,
        environment: EnvironmentValues
    ) -> SIMD2<Int> {
        let resolvedFont = environment.resolvedFont
        let lineHeight = Int(resolvedFont.lineHeight)
        let characterHeight = Int(resolvedFont.pointSize)
        let characterWidth = characterHeight * 2 / 3

        guard let proposedWidth else {
            return SIMD2(
                characterWidth * text.count,
                lineHeight
            )
        }

        let charactersPerLine = max(1, proposedWidth / characterWidth)
        var lineCount = (text.count + charactersPerLine - 1) / charactersPerLine
        if let proposedHeight {
            lineCount = min(max(1, proposedHeight / lineHeight), lineCount)
        }

        return SIMD2(
            characterWidth * min(charactersPerLine, text.count),
            lineHeight * lineCount
        )
    }

    public func createTextView() -> Widget {
        TextView()
    }

    public func updateTextView(
        _ textView: Widget,
        content: String,
        environment: EnvironmentValues
    ) {
        let textView = textView as! TextView
        textView.content = content
        textView.color = environment.suggestedForegroundColor
        textView.font = environment.resolvedFont
        textView.isSelectable = environment.isTextSelectionEnabled
    }

    public func createImageView() -> Widget {
        ImageView()
    }

    public func updateImageView(
        _ imageView: Widget,
        rgbaData: [UInt8],
        width: Int,
        height: Int,
        targetWidth: Int,
        targetHeight: Int,
        dataHasChanged: Bool,
        environment: EnvironmentValues
    ) {
        let imageView = imageView as! ImageView
        imageView.rgbaData = rgbaData
        imageView.pixelWidth = width
        imageView.pixelHeight = height
    }

    public func createTable() -> Widget {
        Table()
    }

    public func setRowCount(ofTable table: Widget, to rows: Int) {
        (table as! Table).rowCount = rows
    }

    public func setColumnLabels(
        ofTable table: Widget,
        to labels: [String],
        environment: EnvironmentValues
    ) {
        (table as! Table).columnLabels = labels
    }

    public func setCells(
        ofTable table: Widget,
        to cells: [Widget],
        withRowHeights rowHeights: [Int]
    ) {
        let table = table as! Table
        table.cells = cells
        table.rowHeights = rowHeights
    }

    public func createButton() -> Widget {
        Button()
    }

    public func updateButton(
        _ button: Widget,
        label: String,
        environment: EnvironmentValues,
        action: @escaping () -> Void
    ) {
        let button = button as! Button
        button.label = label
        button.action = action
        button.isEnabled = environment.isEnabled
        button.font = environment.resolvedFont
    }

    public func updateButton(
        _ button: Widget,
        label: String,
        menu: Menu,
        environment: EnvironmentValues
    ) {
        let button = button as! Button
        button.label = label
        button.menu = menu
        button.isEnabled = environment.isEnabled
        button.font = environment.resolvedFont
    }

    public func createToggle() -> Widget {
        ToggleButton()
    }

    public func updateToggle(
        _ toggle: Widget,
        label: String,
        environment: EnvironmentValues,
        onChange: @escaping (Bool) -> Void
    ) {
        let toggle = toggle as! ToggleButton
        toggle.label = label
        toggle.toggleHandler = onChange
        toggle.isEnabled = environment.isEnabled
        toggle.font = environment.resolvedFont
    }

    public func setState(ofToggle toggle: Widget, to state: Bool) {
        (toggle as! ToggleButton).state = state
    }

    public func createSwitch() -> Widget {
        ToggleSwitch()
    }

    public func updateSwitch(
        _ switchWidget: Widget,
        environment: EnvironmentValues,
        onChange: @escaping (Bool) -> Void
    ) {
        let switchWidget = switchWidget as! ToggleSwitch
        switchWidget.toggleHandler = onChange
        switchWidget.isEnabled = environment.isEnabled
    }

    public func setState(ofSwitch switchWidget: Widget, to state: Bool) {
        (switchWidget as! ToggleSwitch).state = state
    }

    public func createCheckbox() -> Widget {
        Checkbox()
    }

    public func updateCheckbox(
        _ checkboxWidget: Widget,
        environment: EnvironmentValues,
        onChange: @escaping (Bool) -> Void
    ) {
        let checkboxWidget = checkboxWidget as! Checkbox
        checkboxWidget.toggleHandler = onChange
        checkboxWidget.isEnabled = environment.isEnabled
    }

    public func setState(ofCheckbox checkboxWidget: Widget, to state: Bool) {
        (checkboxWidget as! Checkbox).state = state
    }

    public func createSlider() -> Widget {
        Slider()
    }

    public func updateSlider(
        _ slider: Widget,
        minimum: Double,
        maximum: Double,
        decimalPlaces: Int,
        environment: EnvironmentValues,
        onChange: @escaping (Double) -> Void
    ) {
        let slider = slider as! Slider
        slider.minimumValue = minimum
        slider.maximumValue = maximum
        slider.decimalPlaces = decimalPlaces
        slider.changeHandler = onChange
        slider.isEnabled = environment.isEnabled
    }

    public func setValue(ofSlider slider: Widget, to value: Double) {
        (slider as! Slider).value = value
    }

    public func createTextField() -> Widget {
        TextField()
    }

    public func updateTextField(
        _ textField: Widget,
        placeholder: String,
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    ) {
        let textField = textField as! TextField
        textField.placeholder = placeholder
        textField.font = environment.resolvedFont
        textField.changeHandler = onChange
        textField.submitHandler = onSubmit
        textField.isEnabled = environment.isEnabled
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        (textField as! TextField).value = content
    }

    public func getContent(ofTextField textField: Widget) -> String {
        (textField as! TextField).value
    }

     public func createTextEditor() -> Widget {
         TextEditor()
     }

     public func updateTextEditor(
        _ textEditor: Widget,
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void
     ) {
         let textEditor = textEditor as! TextEditor
         textEditor.font = environment.resolvedFont
         textEditor.changeHandler = onChange
         textEditor.isEnabled = environment.isEnabled
     }

     public func setContent(ofTextEditor textEditor: Widget, to content: String) {
         (textEditor as! TextEditor).value = content
     }

     public func getContent(ofTextEditor textEditor: Widget) -> String {
         (textEditor as! TextEditor).value
     }

     public func createPicker() -> Widget {
         Picker()
     }

     public func updatePicker(
        _ picker: Widget,
        options: [String],
        environment: EnvironmentValues,
        onChange: @escaping (Int?) -> Void
     ) {
         let picker = picker as! Picker
         picker.options = options
         picker.changeHandler = onChange
         picker.font = environment.resolvedFont
         picker.isEnabled = environment.isEnabled
     }

     public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
         (picker as! Picker).selectedOption = selectedOption
     }

     public func createProgressSpinner() -> Widget {
         ProgressSpinner()
     }

     public func createProgressBar() -> Widget {
         ProgressBar()
     }

     public func updateProgressBar(
        _ progressBar: Widget,
        progressFraction: Double?,
        environment: EnvironmentValues
     ) {
         let progressBar = progressBar as! ProgressBar
         progressBar.fraction = progressFraction
     }

     public func createPopoverMenu() -> Menu {
         Menu()
     }

     public func updatePopoverMenu(
        _ menu: Menu,
        content: ResolvedMenu,
        environment: EnvironmentValues
     ) {
         menu.content = content
         menu.isEnabled = environment.isEnabled
     }

     public func showPopoverMenu(
        _ menu: Menu,
        at position: SIMD2<Int>,
        relativeTo widget: Widget,
        closeHandler handleClose: @escaping () -> Void
     ) {
         menu.revealed = .init(position: position, widget: widget, closeHandler: handleClose)
     }

     public func createAlert() -> Alert {
         Alert()
     }

     public func updateAlert(
        _ alert: Alert,
        title: String,
        actionLabels: [String],
        environment: EnvironmentValues
     ) {
         alert.title = title
         alert.actionLabels = actionLabels
     }

     public func showAlert(
        _ alert: Alert,
        window: Window?,
        responseHandler handleResponse: @escaping (Int) -> Void
     ) {
         alert.shown = .init(window: window, responseHandler: handleResponse)
     }

     public func dismissAlert(_ alert: Alert, window: Window?) {
         alert.shown = nil
     }

     public func createSheet(content: Widget) -> Sheet {
         Sheet()
     }

     public func updateSheet(
        _ sheet: Sheet,
        window: Window,
        environment: EnvironmentValues,
        size: SIMD2<Int>,
        onDismiss: @escaping () -> Void,
        cornerRadius: Double?,
        detents: [PresentationDetent],
        dragIndicatorVisibility: Visibility,
        backgroundColor: Color?,
        interactiveDismissDisabled: Bool
     ) {
//         sheet.window = window
         sheet.size = size
         sheet.dismissHandler = onDismiss
         sheet.cornerRadius = cornerRadius
         sheet.detents = detents
         sheet.dragIndicatorVisibility = dragIndicatorVisibility
         sheet.backgroundColor = backgroundColor
         sheet.interactiveDismissDisabled = interactiveDismissDisabled
     }

     public func presentSheet(_ sheet: Sheet, window: Window, parentSheet: Sheet?) {
         if let parentSheet {
             parentSheet.nestedSheet = sheet
         } else {
             window.sheet = sheet
         }
     }

     public func dismissSheet(_ sheet: Sheet, window: Window, parentSheet: Sheet?) {
         if let parentSheet {
             parentSheet.nestedSheet = nil
         } else {
             window.sheet = nil
         }
     }

     public func size(ofSheet sheet: Sheet) -> SIMD2<Int> {
         sheet.size
     }

    // public func showOpenDialog(fileDialogOptions: SwiftCrossUI.FileDialogOptions, openDialogOptions: SwiftCrossUI.OpenDialogOptions, window: Window?, resultHandler handleResult: @escaping (SwiftCrossUI.DialogResult<[URL]>) -> Void) {

    // }

    // public func showSaveDialog(fileDialogOptions: SwiftCrossUI.FileDialogOptions, saveDialogOptions: SwiftCrossUI.SaveDialogOptions, window: Window?, resultHandler handleResult: @escaping (SwiftCrossUI.DialogResult<URL>) -> Void) {

    // }

    // public func createTapGestureTarget(wrapping child: Widget, gesture: SwiftCrossUI.TapGesture) -> Widget {

    // }

    // public func updateTapGestureTarget(_ tapGestureTarget: Widget, gesture: SwiftCrossUI.TapGesture, environment: SwiftCrossUI.EnvironmentValues, action: @escaping () -> Void) {

    // }

    // public func createHoverTarget(wrapping child: Widget) -> Widget {

    // }

    // public func updateHoverTarget(_ hoverTarget: Widget, environment: SwiftCrossUI.EnvironmentValues, action: @escaping (Bool) -> Void) {

    // }

    // public func createPathWidget() -> Widget {

    // }

    // public func createPath() -> Path {

    // }

    // public func updatePath(_ path: Path, _ source: SwiftCrossUI.Path, bounds: SwiftCrossUI.Path.Rect, pointsChanged: Bool, environment: SwiftCrossUI.EnvironmentValues) {

    // }

    // public func renderPath(_ path: Path, container: Widget, strokeColor: SwiftCrossUI.Color, fillColor: SwiftCrossUI.Color, overrideStrokeStyle: SwiftCrossUI.StrokeStyle?) {

    // }

     public func createWebView() -> Widget {
         WebView()
     }

     public func updateWebView(
        _ webView: Widget,
        environment: SwiftCrossUI.EnvironmentValues,
        onNavigate: @escaping (URL) -> Void
     ) {
         (webView as! WebView).navigationHandler = onNavigate
     }

     public func navigateWebView(_ webView: Widget, to url: URL) {
         (webView as! WebView).url = url
     }
}
