import 'package:flutter/material.dart';

void main() => runApp(const BmiCalculatorApp());

class BmiCalculatorApp extends StatelessWidget {
  const BmiCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
      ),
      home: const BmiCalculatorPage(),
    );
  }
}

enum UnitMode { metric, imperial }

class BmiCalculatorPage extends StatefulWidget {
  const BmiCalculatorPage({super.key});

  @override
  State<BmiCalculatorPage> createState() => _BmiCalculatorPageState();
}

class _BmiCalculatorPageState extends State<BmiCalculatorPage> {
  UnitMode mode = UnitMode.metric;

  final heightCm = TextEditingController();
  final weightKg = TextEditingController();
  final heightFt = TextEditingController();
  final heightIn = TextEditingController();
  final weightLb = TextEditingController();

  double? bmi;
  String? category;

  @override
  void dispose() {
    heightCm.dispose();
    weightKg.dispose();
    heightFt.dispose();
    heightIn.dispose();
    weightLb.dispose();
    super.dispose();
  }

  String getCategory(double value) {
    if (value < 18.5) return 'Below healthy range';
    if (value < 25) return 'Healthy range';
    if (value < 30) return 'Above healthy range';
    return 'High BMI range';
  }

  void clearResult() {
    if (bmi != null || category != null) {
      setState(() {
        bmi = null;
        category = null;
      });
    }
  }

  void calculate() {
    double meters;
    double kg;

    if (mode == UnitMode.metric) {
      final cm = double.tryParse(heightCm.text.trim());
      final w = double.tryParse(weightKg.text.trim());
      if (cm == null || w == null || cm <= 0 || w <= 0) {
        showError();
        return;
      }
      meters = cm / 100;
      kg = w;
    } else {
      final ft = double.tryParse(heightFt.text.trim());
      final inch = double.tryParse(heightIn.text.trim());
      final lb = double.tryParse(weightLb.text.trim());
      if (ft == null ||
          inch == null ||
          lb == null ||
          ft < 0 ||
          inch < 0 ||
          lb <= 0 ||
          (ft == 0 && inch == 0)) {
        showError();
        return;
      }
      meters = ((ft * 12) + inch) * 0.0254;
      kg = lb * 0.45359237;
    }

    final value = kg / (meters * meters);
    setState(() {
      bmi = value;
      category = getCategory(value);
    });
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enter a valid height and weight.')),
    );
  }

  Widget field(TextEditingController controller, String label, String suffix) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => clearResult(),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BMI Calculator Pro',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.monitor_weight_outlined,
                      size: 58,
                      color: scheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Check your BMI',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: scheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'For adults 18+. BMI is a screening tool, not a diagnosis.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SegmentedButton<UnitMode>(
                segments: const [
                  ButtonSegment(
                    value: UnitMode.metric,
                    label: Text('Metric'),
                    icon: Icon(Icons.straighten),
                  ),
                  ButtonSegment(
                    value: UnitMode.imperial,
                    label: Text('Imperial'),
                    icon: Icon(Icons.swap_horiz),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (selection) {
                  setState(() {
                    mode = selection.first;
                    bmi = null;
                    category = null;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (mode == UnitMode.metric) ...[
                field(heightCm, 'Height', 'cm'),
                const SizedBox(height: 12),
                field(weightKg, 'Weight', 'kg'),
              ] else ...[
                Row(
                  children: [
                    Expanded(child: field(heightFt, 'Height', 'ft')),
                    const SizedBox(width: 12),
                    Expanded(child: field(heightIn, 'Height', 'in')),
                  ],
                ),
                const SizedBox(height: 12),
                field(weightLb, 'Weight', 'lb'),
              ],
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate_outlined),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Calculate BMI',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              if (bmi == null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: scheme.outlineVariant),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Your BMI result will appear here.',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ResultCard(bmi: bmi!, category: category!),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Adult BMI ranges are general screening ranges. BMI does not '
                  'measure body composition or overall health and should not be '
                  'used as a diagnosis.',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final double bmi;
  final String category;

  const ResultCard({super.key, required this.bmi, required this.category});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(
            'Your BMI',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            bmi.toStringAsFixed(1),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Adult reference ranges',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const RangeRow('Below 18.5', 'Below healthy range'),
          const RangeRow('18.5–24.9', 'Healthy range'),
          const RangeRow('25.0–29.9', 'Above healthy range'),
          const RangeRow('30.0+', 'High BMI range'),
        ],
      ),
    );
  }
}

class RangeRow extends StatelessWidget {
  final String left;
  final String right;

  const RangeRow(this.left, this.right, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 105,
            child: Text(left, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          Expanded(child: Text(right)),
        ],
      ),
    );
  }
}
