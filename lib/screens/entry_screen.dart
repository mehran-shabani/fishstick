import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../models/blood_sugar_entry.dart';
import '../database/database_helper.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bloodSugarController = TextEditingController();
  bool _isFasting = true;
  bool _isLoading = true;
  BloodSugarEntry? _todayEntry;
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadTodayEntry();
  }

  Future<void> _loadTodayEntry() async {
    setState(() => _isLoading = true);
    final entry = await _db.getTodayEntry();
    if (entry != null) {
      setState(() {
        _todayEntry = entry;
        _bloodSugarController.text = entry.bloodSugar.toString();
        _isFasting = entry.isFasting;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bloodSugar = double.parse(_bloodSugarController.text);
    final entry = BloodSugarEntry.fromToday(
      bloodSugar: bloodSugar,
      isFasting: _isFasting,
    );

    await _db.insertOrUpdateEntry(entry);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('قند خون با موفقیت ثبت شد'),
          backgroundColor: Colors.green,
        ),
      );
      _loadTodayEntry();
    }
  }

  @override
  void dispose() {
    _bloodSugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jalali = Jalali.now();
    final persianDate = jalali.formatter.wN + ' ' + jalali.formatter.d + ' ' + 
                       jalali.formatter.mN + ' ' + jalali.formatter.yyyy;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Date Card
            Card(
              elevation: 3,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 40,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      persianDate,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_todayEntry != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'ثبت شده',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Blood Sugar Input
                  TextFormField(
                    controller: _bloodSugarController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'میزان قند خون (mg/dL)',
                      hintText: 'مثال: 95',
                      prefixIcon: const Icon(Icons.water_drop),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'لطفا مقدار قند خون را وارد کنید';
                      }
                      final number = double.tryParse(value);
                      if (number == null) {
                        return 'لطفا یک عدد معتبر وارد کنید';
                      }
                      if (number <= 0 || number > 600) {
                        return 'مقدار قند خون باید بین 1 تا 600 باشد';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  // Fasting Status
                  const Text(
                    'وضعیت ناشتایی:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isFasting = true),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _isFasting
                                  ? Colors.blue
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isFasting
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.free_breakfast,
                                  color: _isFasting
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'ناشتا',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _isFasting
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isFasting = false),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: !_isFasting
                                  ? Colors.orange
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: !_isFasting
                                    ? Colors.orange.shade700
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restaurant,
                                  color: !_isFasting
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'غیر ناشتا',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !_isFasting
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Submit Button
                  ElevatedButton(
                    onPressed: _saveEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'ثبت قند خون',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Info Card
                  Card(
                    color: Colors.amber.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.amber.shade700,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'راهنما',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '• قند خون طبیعی ناشتا: 70-100 mg/dL',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '• قند خون طبیعی غیر ناشتا: کمتر از 140 mg/dL',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '• هر روز فقط یک بار می‌توانید ثبت کنید',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
