import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/models/user.dart';

void main() {
  group('User Model (Endterm Profile)', () {
    test('User object stores profile data correctly', () {
      final user = User(
        firstName: 'Miras',
        lastName: 'Developer',
        role: 'Premium Member',
        profileImageUrl: 'assets/profile.png',
        points: 150,
        darkMode: true,
      );

      expect(user.firstName, 'Miras');
      expect(user.points, 150);
      expect(user.role, 'Premium Member');
    });
  });
}
