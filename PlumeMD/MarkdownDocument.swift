import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let markdown = UTType(importedAs: "net.daringfireball.markdown")
}

struct MarkdownDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.markdown, .plainText] }
    static var writableContentTypes: [UTType] { [.markdown, .plainText] }

    var text: String

    init(text: String = "") {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = Self.text(from: data)
        else { throw CocoaError(.fileReadCorruptFile) }
        self.text = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }

    // MARK: - The bytes on disk
    //
    // Split out of the two FileDocument methods above so they can be tested:
    // ReadConfiguration and WriteConfiguration have no public initialiser, so
    // the round trip a document app lives or dies by was otherwise unreachable
    // from a test.

    /// What gets written to the file.
    var data: Data { Data(text.utf8) }

    /// What a file's bytes mean, or nil when they are not UTF-8 — in which case
    /// the document refuses to open rather than substituting characters.
    static func text(from data: Data) -> String? {
        String(data: data, encoding: .utf8)
    }
}
