import '../plagiarism_checker_plus.dart';

/// Enum representing the available similarity algorithms.
///
///  [cosine] Uses the Cosine Similarity algorithm.
///  [jaccard] Uses the Jaccard Similarity algorithm.
///  [tfidf] Uses the TF-IDF (Term Frequency-Inverse Document Frequency) algorithm.
///  [average] Uses the average of all available algorithms.

/// Enum representing the available similarity algorithms.
enum Algorithm {
  /// Uses the Cosine Similarity algorithm.
  ///
  /// Measures the cosine of the angle between two vectors in a multi-dimensional space,
  /// providing a similarity score based on the orientation rather than magnitude.
  cosine,

  /// Uses the Jaccard Similarity algorithm.
  ///
  /// Calculates similarity based on the size of the intersection divided by the size of the
  /// union of two sets, commonly used for comparing document similarity.
  jaccard,

  /// Uses the TF-IDF (Term Frequency-Inverse Document Frequency) algorithm.
  ///
  /// Evaluates how important a word is to a document in a collection by considering both
  /// term frequency and inverse document frequency.
  tfidf,

  /// Uses the average of all available algorithms.
  ///
  /// Combines results from Cosine, Jaccard, and TF-IDF algorithms to produce a more
  /// balanced similarity score.
  average
}

/// Class representing the result of a plagiarism check.
class PlagiarismResult {
  /// The similarity score between the two texts.
  final double similarityScore;

  /// The algorithm used to calculate the similarity score.
  final String algorithm;

  /// Boolean indicating if the similarity meets or exceeds the threshold.
  final bool isPlagiarized;

  /// Creates a [PlagiarismResult] instance with the specified [similarityScore], [algorithm], and [isPlagiarized].
  PlagiarismResult({
    required this.similarityScore,
    required this.algorithm,
    required this.isPlagiarized,
  });
}

/// Class for checking plagiarism between two texts using various similarity algorithms.
class PlagiarismChecker {
  final TextProcessor _textProcessor;
  final TextPreprocessor _textPreprocessor;
  late final SimilarityAlgorithm _cosineSimilarity;
  late final SimilarityAlgorithm _jaccardSimilarity;
  late final SimilarityAlgorithm _tfidfSimilarity;

  /// Creates a [PlagiarismChecker] instance with the specified [TextProcessor] and [TextPreprocessor].
  ///
  /// If no [textProcessor] or [textPreprocessor] is provided, default implementations are used.
  PlagiarismChecker(
      {TextProcessor? textProcessor, TextPreprocessor? textPreprocessor})
      : _textProcessor = textProcessor ?? SimpleTextProcessor(),
        _textPreprocessor = textPreprocessor ?? AdvancedTextPreprocessor() {
    _cosineSimilarity = CosineSimilarity(_textProcessor);
    _jaccardSimilarity = JaccardSimilarity(_textProcessor);
    _tfidfSimilarity = TfIdfSimilarity(_textPreprocessor);
  }

  /// Checks plagiarism between [text1] and [text2] using the specified algorithm and options.
  ///
  /// [algorithm] specifies the similarity algorithm to use (default is [Algorithm.average]).
  /// [threshold] specifies the similarity threshold for considering plagiarism (default is 0.7).
  /// [caseSensitive] specifies whether the comparison should be case-sensitive (default is false).
  /// [customStopWords] allows specifying a custom list of stop words.
  ///
  /// Returns a [PlagiarismResult] containing the similarity score, algorithm used, and plagiarism status.
  PlagiarismResult checkPlagiarism(String text1, String text2,
      {Algorithm algorithm = Algorithm.average,
      double threshold = 0.7,
      bool caseSensitive = false,
      List<String>? customStopWords}) {
    double similarityScore;
    String algorithmUsed;

    switch (algorithm) {
      case Algorithm.cosine:
        similarityScore = _cosineSimilarity.calculate(text1, text2);
        algorithmUsed = 'Cosine Similarity';
        break;
      case Algorithm.jaccard:
        similarityScore = _jaccardSimilarity.calculate(text1, text2);
        algorithmUsed = 'Jaccard Similarity';
        break;
      case Algorithm.tfidf:
        similarityScore = _tfidfSimilarity.calculate(text1, text2);
        algorithmUsed = 'TF-IDF Similarity';
        break;
      case Algorithm.average:
        similarityScore = (_cosineSimilarity.calculate(text1, text2) +
                _jaccardSimilarity.calculate(text1, text2) +
                _tfidfSimilarity.calculate(text1, text2)) /
            3;
        algorithmUsed = 'Average Similarity';
        break;
    }

    bool isPlagiarized = similarityScore >= threshold;

    return PlagiarismResult(
      similarityScore: double.parse(similarityScore.toStringAsFixed(2)),
      algorithm: algorithmUsed,
      isPlagiarized: isPlagiarized,
    );
  }

  /// Provides detailed similarity scores for each algorithm.
  ///
  /// [text1] and [text2] are the texts to compare.
  ///
  /// Returns a [Map] containing the similarity scores for each algorithm.
  Map<String, double> getDetailedResults(String text1, String text2) {
    final cosineScore = double.parse(
        _cosineSimilarity.calculate(text1, text2).toStringAsFixed(2));
    final jaccardScore = double.parse(
        _jaccardSimilarity.calculate(text1, text2).toStringAsFixed(2));
    final tfidfScore = double.parse(
        _tfidfSimilarity.calculate(text1, text2).toStringAsFixed(2));
    final averageScore = double.parse(
        ((cosineScore + jaccardScore + tfidfScore) / 3).toStringAsFixed(2));

    return {
      'Cosine Similarity': cosineScore,
      'Jaccard Similarity': jaccardScore,
      'TF-IDF Similarity': tfidfScore,
      'Average Similarity': averageScore,
    };
  }
}
