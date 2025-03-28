# PlagiarismCheckerPlus

A Flutter package for detecting text similarity and potential plagiarism using Cosine Similarity and Jaccard Similarity algorithms. This package provides flexible options for algorithm selection, customizable similarity thresholds, and detailed analysis results.

<p align="center">
  <img src="assets/demo.jpg" width="45%" alt="Demo Screen">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/demo_result.jpg" width="45%" alt="Results Screen">
</p>

## Features

<br>🔍 **Multiple Algorithms**: Choose between Cosine Similarity, Jaccard Similarity, or use both
<br>🎚️ **Customizable Threshold**: Set your own similarity threshold for plagiarism detection
<br>📊 **Detailed Analysis**: Get comprehensive similarity scores and results
<br>🚀 **Easy Integration**: Simple API for quick implementation
<br>⚡ **Efficient Performance**: Optimized for both small and large text comparisons

## Installation

Add `plagiarism_checker_plus` to your `pubspec.yaml`:

```yaml
dependencies:
  plagiarism_checker_plus: ^1.0.3
```

Then, install the package:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:plagiarism_checker_plus/plagiarism_checker_plus.dart';

void main() {
  final checker = PlagiarismCheckerPlus(
    algorithm: Algorithm.both, // Uses both Cosine and Jaccard Similarity
    threshold: 0.5, // Default threshold for similarity
  );

  final text1 = "This is a sample text for testing similarity.";
  final text2 = "This is another sample text used for similarity testing.";

  final result = checker.check(text1, text2);
  print("Similarity Score: ${result.similarityScore}");
  print("Algorithm Used: ${result.algorithm}");
  print("Is Plagiarized: ${result.isPlagiarized}");
}
```

### Algorithm Selection

#### Using Cosine Similarity

```dart
final checker = PlagiarismCheckerPlus(
  algorithm: Algorithm.cosine,
  threshold: 0.5,
);
```

#### Using Jaccard Similarity

```dart
final checker = PlagiarismCheckerPlus(
  algorithm: Algorithm.jaccard,
  threshold: 0.4,
);
```

#### Using Both Algorithms

```dart
final checker = PlagiarismCheckerPlus(
  algorithm: Algorithm.both,
  threshold: 0.5,
);
```

## API Reference

### PlagiarismCheckerPlus

Main class for initializing the checker with desired settings.

#### Parameters

- `algorithm`: The algorithm to use (`Algorithm.cosine`, `Algorithm.jaccard`, or `Algorithm.both`)
- `threshold`: Similarity score threshold (0.0 to 1.0) for determining plagiarism

### PlagiarismResult

Result object returned by the check function.

#### Properties

- `score`: Similarity score between the two texts (0.0 to 1.0)
- `algorithm`: Algorithm(s) used in the calculation
- `isPlagiarized`: Boolean indicating if similarity meets/exceeds threshold

## How It Works

### Cosine Similarity

- Transforms text into vectors
- Calculates the cosine of the angle between vectors
- Effective for capturing semantic similarity

### Jaccard Similarity

- Measures similarity based on word intersection/union
- Ideal for direct word overlap comparison
- Handles varying text lengths well

## Limitations

- Currently optimized for English and Latin-alphabet languages
- Similarity scores may vary based on text complexity
- Large texts may require additional processing time

## Future Plans

- Support for additional similarity algorithms
- Enhanced multilingual support
- Detailed matching report with highlighted similarities
- Performance optimizations for large texts

## Contributing

Contributions are welcome! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

## License

This package is available under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Support

For bugs and feature requests, please [create an issue](https://github.com/SumanSharmaTech/plagiarism_checker_plus/issues) on GitHub.

---

## Example App

Check out the complete example app in the [`example`](example) directory:

```bash
cd example
flutter run
```

## Additional Resources

- [API Documentation](https://pub.dev/documentation/plagiarism_checker_plus)
- [Example Application](example/)
- [Change Log](CHANGELOG.md)
