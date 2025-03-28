import 'package:flutter/material.dart';
import 'package:plagiarism_checker_plus/plagiarism_checker_plus.dart';

void main() {
  runApp(const PlagiarismCheckerPlusDemo());
}

class PlagiarismCheckerPlusDemo extends StatelessWidget {
  const PlagiarismCheckerPlusDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plagiarism Checker Plus Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _checker = PlagiarismCheckerPlus();
  final _text1Controller = TextEditingController();
  final _text2Controller = TextEditingController();

  // Default sample texts for quick testing
  final _sampleText1 = "The quick brown fox jumps over the lazy dog. "
      "This sentence contains every letter of the English alphabet at least once.";
  final _sampleText2 = "A quick brown fox jumps over the lazy dog. "
      "This sample sentence has all letters of the English alphabet.";

  Algorithm _selectedAlgorithm = Algorithm.average;
  double _threshold = 0.7;
  PlagiarismResult? _result;
  Map<String, double>? _detailedResults;

  @override
  void initState() {
    super.initState();
    // Pre-populate with sample texts for easy testing
    _text1Controller.text = _sampleText1;
    _text2Controller.text = _sampleText2;
  }

  @override
  void dispose() {
    _text1Controller.dispose();
    _text2Controller.dispose();
    super.dispose();
  }

  void _checkPlagiarism() {
    final text1 = _text1Controller.text;
    final text2 = _text2Controller.text;

    if (text1.isEmpty || text2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both texts to compare')),
      );
      return;
    }

    setState(() {
      _result = _checker.check(
        text1,
        text2,
        algorithm: _selectedAlgorithm,
        threshold: _threshold,
      );
      _detailedResults = _checker.getDetailedResults(text1, text2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plagiarism Checker Plus Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextInput(
              label: 'Original Text',
              controller: _text1Controller,
              hint: 'Enter or paste original text here...',
            ),
            const SizedBox(height: 16),
            _buildTextInput(
              label: 'Comparison Text',
              controller: _text2Controller,
              hint: 'Enter or paste text to compare...',
            ),
            const SizedBox(height: 24),
            _buildSettings(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _checkPlagiarism,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Check Plagiarism'),
            ),
            const SizedBox(height: 24),
            if (_result != null) _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
          ),
          minLines: 3,
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildSettings() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analysis Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Algorithm'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Algorithm>(
                        value: _selectedAlgorithm,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: Algorithm.values.map((algorithm) {
                          return DropdownMenuItem<Algorithm>(
                            value: algorithm,
                            child: Text(algorithm.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedAlgorithm = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Threshold: ${_threshold.toStringAsFixed(1)}'),
                      Slider(
                        value: _threshold,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: _threshold.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() => _threshold = value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Card(
      elevation: 3,
      color: _result!.isPlagiarized ? Colors.red.shade50 : Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Results',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: _result!.isPlagiarized
                    ? Colors.red.shade700
                    : Colors.green.shade700,
              ),
            ),
            const Divider(),
            _buildResultRow(
              'Similarity Score',
              '${(_result!.similarityScore * 100).toStringAsFixed(1)}%',
            ),
            _buildResultRow('Algorithm Used', _result!.algorithm),
            _buildResultRow(
              'Status',
              _result!.isPlagiarized
                  ? 'Potential Plagiarism Detected'
                  : 'Original Content',
            ),
            if (_detailedResults != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Detailed Algorithm Scores',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._detailedResults!.entries.map((entry) => _buildResultRow(
                    entry.key,
                    '${(entry.value * 100).toStringAsFixed(1)}%',
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: label == 'Status' && value.contains('Plagiarism')
                    ? Colors.red
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
