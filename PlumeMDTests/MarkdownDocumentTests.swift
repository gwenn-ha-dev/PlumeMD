import XCTest
import UniformTypeIdentifiers
@testable import PlumeMD

/// PlumeMD promises that your files stay yours, on disk, in Markdown. That
/// promise is one encode and one decode wide. If either drifts, the app does
/// not crash — it quietly rewrites the user's document, which is the one
/// failure a document editor cannot afford.
final class MarkdownDocumentTests: XCTestCase {

    private func roundTrip(_ text: String) -> String? {
        MarkdownDocument.text(from: MarkdownDocument(text: text).data)
    }

    func testTextSurvivesTheRoundTripUnchanged() {
        let samples = [
            "",
            "# Titre\n\nUn paragraphe.\n",
            "accents: éèêëàçùûôî — ligatures: œæ",
            "emoji: 🇫🇷 👩‍👩‍👧‍👦 🏳️‍🌈",
            "CRLF\r\nand\rlone CR",
            "tabs\tand   trailing spaces   \n\n\n",
            "combining: e\u{0301} vs precomposed: \u{00e9}",
            String(repeating: "ligne\n", count: 5_000),
        ]
        for text in samples {
            XCTAssertEqual(roundTrip(text), text, "altered: \(text.prefix(40))…")
        }
    }

    func testAnEmptyFileOpensAsAnEmptyDocument() {
        // Not nil: an empty .md is a legitimate file and must not refuse to open.
        XCTAssertEqual(MarkdownDocument.text(from: Data()), "")
    }

    func testBytesThatAreNotUTF8AreRefused() {
        // Returning nil is what makes init(configuration:) throw. Substituting
        // characters instead would open the file and corrupt it on the next save.
        let invalid = Data([0xFF, 0xFE, 0x41, 0x80, 0x42])
        XCTAssertNil(MarkdownDocument.text(from: invalid))
    }

    func testTheDocumentStillClaimsMarkdownFiles() {
        // Losing either type means .md files stop opening with a double-click,
        // with nothing in the app to say why.
        XCTAssertTrue(MarkdownDocument.readableContentTypes.contains(.markdown))
        XCTAssertTrue(MarkdownDocument.readableContentTypes.contains(.plainText))
        XCTAssertTrue(MarkdownDocument.writableContentTypes.contains(.markdown))
    }
}
