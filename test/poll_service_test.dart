import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/services/services.dart';

void main() {
  group('PollService', () {
    late PollService pollService;

    setUp(() {
      pollService = PollService();
    });

    test('createPoll returns a poll with unique id', () {
      final question = 'What snack should we get?';
      final deadline = DateTime.now().add(const Duration(days: 1));

      final poll = pollService.createPoll(
        question: question,
        deadline: deadline,
      );

      expect(poll.id, isNotEmpty);
      expect(poll.question, equals(question));
      expect(poll.deadline, equals(deadline));
      expect(poll.options, isEmpty);
      expect(poll.votes, isEmpty);
    });

    test('createPoll generates sequential ids', () {
      final deadline = DateTime.now().add(const Duration(days: 1));

      final poll1 = pollService.createPoll(
        question: 'Question 1',
        deadline: deadline,
      );
      final poll2 = pollService.createPoll(
        question: 'Question 2',
        deadline: deadline,
      );

      expect(poll1.id, equals('poll_1'));
      expect(poll2.id, equals('poll_2'));
    });

    test('getPoll returns created poll', () {
      final question = 'Test question';
      final deadline = DateTime.now().add(const Duration(days: 1));

      final created = pollService.createPoll(
        question: question,
        deadline: deadline,
      );

      final retrieved = pollService.getPoll(created.id);

      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals(created.id));
      expect(retrieved.question, equals(question));
      expect(retrieved.deadline, equals(deadline));
    });

    test('getPoll returns null for non-existent poll', () {
      final poll = pollService.getPoll('non_existent_id');
      expect(poll, isNull);
    });

    test('getAllPolls returns all created polls', () {
      final deadline = DateTime.now().add(const Duration(days: 1));

      pollService.createPoll(question: 'Q1', deadline: deadline);
      pollService.createPoll(question: 'Q2', deadline: deadline);
      pollService.createPoll(question: 'Q3', deadline: deadline);

      final allPolls = pollService.getAllPolls();

      expect(allPolls.length, equals(3));
      expect(allPolls[0].question, equals('Q1'));
      expect(allPolls[1].question, equals('Q2'));
      expect(allPolls[2].question, equals('Q3'));
    });

    test('poll store maintains state across calls', () {
      final deadline = DateTime.now().add(const Duration(days: 1));

      final poll1 = pollService.createPoll(
        question: 'First poll',
        deadline: deadline,
      );

      expect(pollService.getAllPolls().length, equals(1));

      final poll2 = pollService.createPoll(
        question: 'Second poll',
        deadline: deadline,
      );

      final allPolls = pollService.getAllPolls();
      expect(allPolls.length, equals(2));
      expect(allPolls.any((p) => p.id == poll1.id), isTrue);
      expect(allPolls.any((p) => p.id == poll2.id), isTrue);
    });
  });
}
