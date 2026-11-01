import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class PollCreateScreen extends StatefulWidget {
  const PollCreateScreen({super.key});

  @override
  State<PollCreateScreen> createState() => _PollCreateScreenState();
}

class _PollCreateScreenState extends State<PollCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  DateTime? _selectedDeadline;
  String? _createdPollId;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 17, minute: 0),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitPoll() {
    if (_formKey.currentState!.validate() && _selectedDeadline != null) {
      final state = AppScope.of(context);
      final pollId = state.createPoll(
        question: _questionController.text.trim(),
        deadline: _selectedDeadline!,
      );

      setState(() {
        _createdPollId = pollId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_createdPollId != null) {
      return _ConfirmationView(pollId: _createdPollId!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Poll'),
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
              HlCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('POLL QUESTION'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _questionController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., What snacks should we get for Friday?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a question';
                        }
                        return null;
                      },
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
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _selectDeadline,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: HlTokens.line),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: HlTokens.sea),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _selectedDeadline != null
                                    ? _formatDeadline(_selectedDeadline!)
                                    : 'Select deadline',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedDeadline != null
                                      ? HlTokens.ink
                                      : HlTokens.inkSoft,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedDeadline == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8, left: 12),
                        child: Text(
                          'Deadline is required',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _selectedDeadline != null ? _submitPoll : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: HlTokens.sea,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Poll',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDeadline(DateTime deadline) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[deadline.month - 1];
    final day = deadline.day;
    final hour = deadline.hour > 12 ? deadline.hour - 12 : deadline.hour;
    final minute = deadline.minute.toString().padLeft(2, '0');
    final period = deadline.hour >= 12 ? 'PM' : 'AM';
    return '$month $day at $hour:$minute $period';
  }
}

class _ConfirmationView extends StatelessWidget {
  const _ConfirmationView({required this.pollId});
  final String pollId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final poll = state.getPoll(pollId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Poll Created'),
        backgroundColor: HlTokens.sea,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: HlTokens.foam,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: HlTokens.sea,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Poll Created Successfully!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            HlCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow('POLL ID'),
                  const SizedBox(height: 8),
                  Text(
                    pollId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HlTokens.sea,
                    ),
                  ),
                  if (poll != null) ...[
                    const SizedBox(height: 16),
                    const Eyebrow('QUESTION'),
                    const SizedBox(height: 8),
                    Text(
                      poll.question,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    const Eyebrow('DEADLINE'),
                    const SizedBox(height: 8),
                    Text(
                      poll.deadline.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HlTokens.sea,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
