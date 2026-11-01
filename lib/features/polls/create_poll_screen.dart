import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  DateTime? _selectedDeadline;
  bool _isSubmitting = false;
  String? _createdPollId;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null && mounted) {
        setState(() {
          _selectedDeadline = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _createPoll() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a deadline')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final state = AppScope.of(context);
      final pollId = await state.createPoll(
        question: _questionController.text.trim(),
        deadline: _selectedDeadline!,
      );

      setState(() {
        _createdPollId = pollId;
        _isSubmitting = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating poll: $e')),
        );
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Poll'),
        elevation: 0,
        backgroundColor: HlTokens.sea,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_createdPollId != null) ...[
                HlCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: HlTokens.foam,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: HlTokens.sea,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Poll Created Successfully',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Eyebrow('POLL ID'),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: HlTokens.foam,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: HlTokens.sea),
                        ),
                        child: Text(
                          _createdPollId!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: HlTokens.sea,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Question: ${_questionController.text}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: HlTokens.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Deadline: ${_formatDeadline(_selectedDeadline!)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: HlTokens.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HlTokens.sea,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ] else ...[
                HlCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Eyebrow('POLL QUESTION'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _questionController,
                        decoration: InputDecoration(
                          hintText: 'What snack should we get for Friday?',
                          filled: true,
                          fillColor: HlTokens.foam,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a question';
                          }
                          return null;
                        },
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                HlCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Eyebrow('DEADLINE'),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectDeadline,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: HlTokens.foam,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: HlTokens.sea,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedDeadline == null
                                      ? 'Select deadline'
                                      : _formatDeadline(_selectedDeadline!),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedDeadline == null
                                        ? HlTokens.inkSoft
                                        : HlTokens.ink,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: HlTokens.inkSoft,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _createPoll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HlTokens.sea,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: HlTokens.inkSoft,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Poll',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDeadline(DateTime deadline) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = deadline.hour > 12 ? deadline.hour - 12 : deadline.hour;
    final period = deadline.hour >= 12 ? 'PM' : 'AM';
    final minute = deadline.minute.toString().padLeft(2, '0');
    return '${months[deadline.month]} ${deadline.day}, ${deadline.year} at $hour:$minute $period';
  }
}
