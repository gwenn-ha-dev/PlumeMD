import XCTest
import CoreGraphics
@testable import PlumeMD

/// The PDF export used to draw the whole document on one page as tall as the
/// text. These tests hold it to paper: pages of the user's paper size, as many
/// as the text needs.
@MainActor
final class PDFExporterTests: XCTestCase {

    private func export(_ markdown: String) throws -> CGPDFDocument {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("pdf")
        defer { try? FileManager.default.removeItem(at: url) }
        PDFExporter.export(markdown: markdown, to: url)
        return try XCTUnwrap(CGPDFDocument(url as CFURL), "no PDF written")
    }

    func testAShortDocumentIsOnePageOfPaper() throws {
        let pdf = try export("# Title\n\nOne paragraph.\n")
        XCTAssertEqual(pdf.numberOfPages, 1)
        let box = try XCTUnwrap(pdf.page(at: 1)).getBoxRect(.mediaBox)
        let paper = NSPrintInfo.shared.paperSize
        XCTAssertEqual(box.width, paper.width, accuracy: 1)
        XCTAssertEqual(box.height, paper.height, accuracy: 1)
    }

    func testALongDocumentRunsOverSeveralPages() throws {
        let paragraph = "A paragraph long enough to wrap over a few lines of the page, "
            + "so that sixty of them cannot possibly fit on a single sheet of paper.\n\n"
        let pdf = try export("# Long\n\n" + String(repeating: paragraph, count: 60))
        XCTAssertGreaterThan(pdf.numberOfPages, 2)
    }

    func testAnEmptyDocumentStillMakesAPage() throws {
        XCTAssertEqual(try export("").numberOfPages, 1)
    }
}
