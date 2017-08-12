# HTMLWithImagesToPDF

## Goals

This project has two goals:

1. Showing how to convert an HTML page with images into a PDF document, using one of these three methods:
	1. `UIMarkupTextPrintFormatter`
	2. `viewPrintFormatter()` of either `WKWebView` or `UIWebView`
	3. `UIPrintInteractionController`, the PDF can then be obtain by pinching in the preview presenter by the print controller, it opens up the PDF and it can then be saved by the user. That's a UI only solution...
2. Showing that there is clearly a bug (iOS 10) when using `UIMarkupTextPrintFormatter` to convert an HTML containing images.

## The bug

1. Run the application.
2. Click the `Create PDF` button, and then choose the `UIMarkupTextPrintFormatter` option.
3. A PDF is generated from the `index.html` file and loaded into both a `WKWebView` (recommended by Apple with iOS 8+) and a `UIWebView`.
4. No images show up. Why? Is this a problem with my code?
5. Click on `Load HTML` and choose `index-img.html`. The HTML code is loaded into both web views. The HTML code is not the same as the one we used to generate our PDF (but the `img` tags are the same).
6. All images show up, good. At least there's no problem with the HTML code.
7. Click on `Create PDF` and then `UIMarkupTextPrintFormatter` once more.
8. Yep, the PDF, created with `UIMarkupTextPrintFormatter` shows up **with** images.

This tells me two things:

1. `UIMarkupTextPrintFormatter` **supports** `img` tags. This can also be confirmed by the fact that `Print PDF` > `UIMarkupTextPrintFormatter` shows a PDF with images.
2. It somehow relies on the web view (or another WebKit class, the cache maybe) to render these images.

## Note

The `Create PDF` > `WebView.viewPrintFormatter()` action creates a PDF from what each web view is **currently** displaying, that can either be nothing, one of the HTML loaded beforehand or a PDF loaded from a previous execution.

The `Create PDF` > `WebView.viewPrintFormatter()` action always creates the PDF from the `index.html` file.

## iOS 11

This bug may have been corrected with iOS 11...

## Ideal solution

A non-UI, macOS **&** iOS solution would be perfect but I haven't found anything of the sort...