import SwiftUI
import AppKit
import Markdown

/// Renders a Markdown document to a paginated PDF, on the user's default paper
/// size (A4 or US Letter, from the print settings).
///
/// Pages are filled block by block — a heading, a paragraph, a list, a code
/// block — so that a page break falls between blocks, not through a line. Only
/// a block taller than a whole page is cut, and it carries on at the top of
/// the next.
enum PDFExporter {
    private static let margin: CGFloat = 56
    /// The spacing MarkdownView puts between blocks.
    private static let blockSpacing: CGFloat = 14
    /// Room a heading wants below it on its page: about three lines of text.
    private static let headingKeep: CGFloat = 60

    @MainActor
    static func export(markdown: String, to url: URL) {
        let paper = NSPrintInfo.shared.paperSize
        let pageWidth = paper.width > 0 ? paper.width : 595
        let pageHeight = paper.height > 0 ? paper.height : 842
        let contentWidth = pageWidth - margin * 2
        let contentHeight = pageHeight - margin * 2

        var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        guard let pdf = CGContext(url as CFURL, mediaBox: &mediaBox, nil) else { return }

        var pageOpen = false
        var used: CGFloat = 0          // height already filled on the current page
        func newPage() {
            if pageOpen { pdf.endPDFPage() }
            pdf.beginPDFPage(nil)
            pageOpen = true
            used = 0
        }

        let document = Document(parsing: markdown)
        for block in document.blockChildren {
            let content = BlockView(block: block)
                .frame(width: contentWidth, alignment: .leading)
                // Dark text on white paper, whatever the screen's appearance.
                .environment(\.colorScheme, .light)
            let renderer = ImageRenderer(content: content)
            renderer.proposedSize = ProposedViewSize(width: contentWidth, height: nil)
            // A heading keeps a few lines of what follows on its page.
            let keepWithNext: CGFloat = block is Heading ? headingKeep : 0
            renderer.render { size, draw in
                let gap = used > 0 ? blockSpacing : 0
                if !pageOpen || (used > 0 && used + gap + size.height + keepWithNext > contentHeight) {
                    newPage()
                } else {
                    used += gap
                }
                var drawn: CGFloat = 0
                while true {
                    pdf.saveGState()
                    pdf.clip(to: CGRect(x: margin, y: margin, width: contentWidth, height: contentHeight))
                    // PDF space grows upwards: place the block's bottom so that
                    // its not-yet-drawn part starts `used` below the top margin.
                    pdf.translateBy(x: margin, y: pageHeight - margin - used + drawn - size.height)
                    draw(pdf)
                    pdf.restoreGState()
                    let shown = min(size.height - drawn, contentHeight - used)
                    drawn += shown
                    used += shown
                    if drawn >= size.height - 0.5 { break }
                    newPage()
                }
            }
        }
        if !pageOpen { newPage() }     // an empty document is one blank page
        pdf.endPDFPage()
        pdf.closePDF()
    }
}
