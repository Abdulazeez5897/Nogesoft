import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;


class DocumentPreview extends StatelessWidget {
  final String documentUrl;
  final String documentName;

  const DocumentPreview({
    Key? key,
    required this.documentUrl,
    required this.documentName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullScreenPreview(context, documentUrl),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDocumentIcon(),
            const SizedBox(height: 8),
            Text(
              'View Document',
              style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentIcon() {
    if (documentUrl.contains('.pdf')) {
      return SvgPicture.asset(
        'assets/svg_icons/document.svg',
        height: 60,
      );
    } else if (documentUrl.contains('.png') || documentUrl.contains('.jpg') || documentUrl.contains('.jpeg')) {
      return Image.network(
        documentUrl,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return SvgPicture.asset('assets/svg_icons/image.svg', height: 60);
        },
      );
    } else {
      return SvgPicture.asset(
        'assets/svg_icons/document.svg',
        height: 60,
      );
    }
  }

  void _openFullScreenPreview(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenDocumentViewer(url: url),
      ),
    );
  }
}



class FullScreenDocumentViewer extends StatefulWidget {
  final String url;

  const FullScreenDocumentViewer({Key? key, required this.url}) : super(key: key);

  @override
  _FullScreenDocumentViewerState createState() => _FullScreenDocumentViewerState();
}

class _FullScreenDocumentViewerState extends State<FullScreenDocumentViewer> {
  PdfController? pdfController;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      if (widget.url.endsWith('.pdf')) {
        final pdfBytes = await _fetchPdfData(widget.url);
        pdfController = PdfController(document: PdfDocument.openData(pdfBytes));
      }
    } catch (e) {
      setState(() => isError = true);
      print("Error loading PDF: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<Uint8List> _fetchPdfData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to load PDF");
    }
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Preview"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
          ? const Center(child: Text("Failed to load document"))
          : widget.url.endsWith('.pdf')
          ? PdfView(controller: pdfController!)
          : PhotoView(
        imageProvider: NetworkImage(widget.url),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
