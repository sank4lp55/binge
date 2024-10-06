import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String _barcodeValue = 'No barcode scanned yet'; // Variable to store the scanned value

  // Function to initiate barcode scanning
  Future<void> _scanBarcode() async {
    try {
      // Use the barcode_scan2 package to scan the barcode
      var result = await BarcodeScanner.scan();

      // If the scan result is not null, update the barcode value
      if (result.rawContent.isNotEmpty) {
        setState(() {
          _barcodeValue = result.rawContent; // Update with the scanned value
        });
      }
    } catch (e) {
      setState(() {
        _barcodeValue = 'Failed to get the barcode: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Barcode Scanner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300], // Use the specified background color
        elevation: 0,

      ),
      body: Container(
        color: Colors.grey[300], // Set the background color
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Scanner Icon with animation
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.deepPurple,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 30),

                // Text instruction
                const Text(
                  'Tap the button below to start scanning!',
                  style: TextStyle(
                    color: Colors.black, // Change to black for better visibility
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Elevated Button with ripple effect
                ElevatedButton(
                  onPressed: _scanBarcode, // Call the scan function when button is pressed
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  ),
                  child: const Text(
                    'Start Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Display scanned barcode value
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Slightly transparent white for the container
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[400]!), // Border color
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Scanned Barcode Value:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Change to black for better visibility
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _barcodeValue, // Display the scanned barcode value
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Change to black for better visibility
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
