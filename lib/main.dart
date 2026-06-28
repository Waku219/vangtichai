import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: false,
      ),
      home: const VangtiChaiHomePage(),
    );
  }
}

class VangtiChaiHomePage extends StatefulWidget {
  const VangtiChaiHomePage({super.key});

  @override
  State<VangtiChaiHomePage> createState() => _VangtiChaiHomePageState();
}

class _VangtiChaiHomePageState extends State<VangtiChaiHomePage> {
  String _amountText = '';

  static const List<int> _noteValues = [500, 100, 50, 20, 10, 5, 2, 1];

  void _onDigitPressed(String digit) {
    setState(() {
      _amountText += digit;
    });
  }

  void _onClearPressed() {
    setState(() {
      _amountText = '';
    });
  }

  int get _amount {
    if (_amountText.isEmpty) return 0;
    return int.tryParse(_amountText) ?? 0;
  }

  Map<int, int> get _changeBreakdown {
    int remaining = _amount;
    final Map<int, int> result = {};
    for (final note in _noteValues) {
      result[note] = remaining ~/ note;
      remaining = remaining % note;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VangtiChai')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isTablet = constraints.maxWidth >= 600;
            final bool isLandscape =
                constraints.maxWidth > constraints.maxHeight;

            final double labelFontSize = isTablet ? 28 : 18;
            final double noteFontSize = isTablet ? 22 : 16;
            final double buttonFontSize = isTablet ? 26 : 18;
            final double spacing = isTablet ? 16 : 8;

            return Padding(
              padding: EdgeInsets.all(spacing),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing),
                    child: Center(
                      child: Text(
                        'Taka: $_amountText',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: isLandscape
                        ? _buildLandscapeBody(
                        noteFontSize, buttonFontSize, spacing)
                        : _buildPortraitBody(
                        noteFontSize, buttonFontSize, spacing),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitBody(
      double noteFontSize, double buttonFontSize, double spacing) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildNoteColumn(_noteValues, _changeBreakdown, noteFontSize),
        ),
        Expanded(
          flex: 3,
          child: _buildKeypad(
            rows: const [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
              ['0', 'CLEAR'],
            ],
            buttonFontSize: buttonFontSize,
            spacing: spacing,
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeBody(
      double noteFontSize, double buttonFontSize, double spacing) {
    final breakdown = _changeBreakdown;
    final firstHalf = _noteValues.sublist(0, 4); // 500,100,50,20
    final secondHalf = _noteValues.sublist(4); // 10,5,2,1

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                  child:
                  _buildNoteColumn(firstHalf, breakdown, noteFontSize)),
              Expanded(
                  child:
                  _buildNoteColumn(secondHalf, breakdown, noteFontSize)),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: _buildKeypad(
            rows: const [
              ['1', '2', '3', '4'],
              ['5', '6', '7', '8'],
              ['9', '0', 'CLEAR'],
            ],
            buttonFontSize: buttonFontSize,
            spacing: spacing,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteColumn(
      List<int> notes, Map<int, int> breakdown, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: notes.map((note) {
        return Text(
          '$note: ${breakdown[note]}',
          style: TextStyle(fontSize: fontSize),
        );
      }).toList(),
    );
  }

  Widget _buildKeypad({
    required List<List<String>> rows,
    required double buttonFontSize,
    required double spacing,
  }) {
    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing / 2),
            child: Row(
              children: row.map((label) {
                final bool isClear = label == 'CLEAR';
                return Expanded(
                  flex: isClear ? 2 : 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isClear ? Colors.grey[300] : Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        if (isClear) {
                          _onClearPressed();
                        } else {
                          _onDigitPressed(label);
                        }
                      },
                      child: Text(
                        label,
                        style: TextStyle(fontSize: buttonFontSize),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}