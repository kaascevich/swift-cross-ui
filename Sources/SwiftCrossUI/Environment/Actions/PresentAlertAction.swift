/// Presents an alert to the user. Returns once an action has been selected and
/// the corresponding action handler has been run. Returns the index of the
/// selected action. By default, the alert will have a single button labelled
/// `OK`. All buttons will dismiss the alert even if you provide your own
/// actions.
@MainActor
public struct PresentAlertAction {
    let environment: EnvironmentValues

    @discardableResult
    public func callAsFunction(
        _ title: String,
        @AlertActionsBuilder actions: () -> [AlertAction] = { [.default] }
    ) async -> Int {
        let actions = actions()

        func presentAlert<Backend: AppBackend>(backend: Backend) async -> Int {
            await withCheckedContinuation { continuation in
                backend.runInMainThread {
                    let alert = backend.createAlert()
                    backend.updateAlert(
                        alert,
                        title: title,
                        actionLabels: actions.map(\.label),
                        environment: environment
                    )
                    let window: Backend.Window? =
                        if let window = environment.window {
                            .some(window as! Backend.Window)
                        } else {
                            nil
                        }
                    backend.showAlert(alert, window: window) { actionIndex in
                        actions[actionIndex].action()
                        continuation.resume(returning: actionIndex)
                    }
                }
            }
        }

        return await presentAlert(backend: environment.backend)
    }
}

extension EnvironmentValues {
    /// Presents an alert for the current window, or the entire app if accessed
    /// outside of a scene's view graph (in which case the backend can decide
    /// whether to make it an app modal, a standalone window, or a modal for a
    /// window of its choosing).
    @MainActor
    public var presentAlert: PresentAlertAction {
        return PresentAlertAction(
            environment: self
        )
    }
}
