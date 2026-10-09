import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct ContentView: View {
    @Binding var document: MarkdownDocument
    // `-startInEditor YES` at launch opens the editor instead of the preview:
    // the README captures need both views, and nothing can click the button.
    @State private var showPreview = !UserDefaults.standard.bool(forKey: "startInEditor")

    var body: some View {
        Group {
            if showPreview {
                ScrollView {
                    MarkdownView(text: document.text)
                        .frame(maxWidth: maxReadingWidth, alignment: .leading)
                        .padding(.vertical, Spacing.xxl)
                        .padding(.horizontal, Spacing.xl)
                        .frame(maxWidth: .infinity)
                        .textSelection(.enabled)
                }
                .scrollContentBackground(.hidden)
                .background(Color(.textBackgroundColor))
            } else {
                TextEditor(text: $document.text)
                    .font(Typography.editor)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.vertical, Spacing.lg)
                    .background(Color(.textBackgroundColor))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showPreview)
        .frame(minWidth: 540, minHeight: 400)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showPreview.toggle()
                } label: {
                    // A ternary of literals is a String, which Label and help
                    // take verbatim: each branch must be a LocalizedStringKey.
                    Label(showPreview ? LocalizedStringKey("Éditer") : LocalizedStringKey("Aperçu"),
                          systemImage: showPreview ? "pencil" : "eye")
                }
                .keyboardShortcut("p", modifiers: [.command, .shift])
                .help(showPreview ? Text("Basculer vers l'éditeur (⇧⌘P)") : Text("Basculer vers l'aperçu (⇧⌘P)"))
            }
            ToolbarItem(placement: .automatic) {
                Button(action: exportPDF) {
                    Label("Exporter PDF", systemImage: "arrow.down.doc")
                }
                .keyboardShortcut("e", modifiers: [.command, .shift])
                .help("Exporter en PDF (⇧⌘E)")
            }
        }
    }

    private func exportPDF() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.pdf]
        panel.nameFieldStringValue = "document.pdf"
        panel.canCreateDirectories = true
        guard panel.runModal() == .OK, let url = panel.url else { return }
        PDFExporter.export(markdown: document.text, to: url)
    }
}
