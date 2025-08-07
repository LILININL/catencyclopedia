import 'package:flutter_test/flutter_test.dart';
import 'package:catencyclopedia/core/utils/date_formatter.dart';

void main() {
  group('AppDateUtils', () {
    group('formatTimeAgo', () {
      test('should return "เมื่อสักครู่" for very recent time', () {
        // Arrange
        final now = DateTime.now();
        final recent = now.subtract(const Duration(seconds: 30));

        // Act
        final result = AppDateUtils.formatTimeAgo(recent);

        // Assert
        expect(result, 'เมื่อสักครู่');
      });

      test('should return minutes ago for recent time', () {
        // Arrange
        final now = DateTime.now();
        final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));

        // Act
        final result = AppDateUtils.formatTimeAgo(fiveMinutesAgo);

        // Assert
        expect(result, '5 นาทีที่แล้ว');
      });

      test('should return hours ago for time within a day', () {
        // Arrange
        final now = DateTime.now();
        final twoHoursAgo = now.subtract(const Duration(hours: 2));

        // Act
        final result = AppDateUtils.formatTimeAgo(twoHoursAgo);

        // Assert
        expect(result, '2 ชั่วโมงที่แล้ว');
      });

      test('should return days ago for time within a week', () {
        // Arrange
        final now = DateTime.now();
        final threeDaysAgo = now.subtract(const Duration(days: 3));

        // Act
        final result = AppDateUtils.formatTimeAgo(threeDaysAgo);

        // Assert
        expect(result, '3 วันที่แล้ว');
      });

      test('should return formatted date for time over a week', () {
        // Arrange
        final now = DateTime.now();
        final twoWeeksAgo = now.subtract(const Duration(days: 14));

        // Act
        final result = AppDateUtils.formatTimeAgo(twoWeeksAgo);

        // Assert
        expect(result, contains('/'));
        expect(result, contains(twoWeeksAgo.day.toString()));
        expect(result, contains(twoWeeksAgo.month.toString()));
        expect(result, contains(twoWeeksAgo.year.toString()));
      });
    });

    group('formatDate', () {
      test('should format date correctly in Thai format', () {
        // Arrange
        final testDate = DateTime(2024, 1, 15);

        // Act
        final result = AppDateUtils.formatDate(testDate);

        // Assert
        expect(result, '15 มกราคม 2567');
      });

      test('should format December date correctly', () {
        // Arrange
        final testDate = DateTime(2024, 12, 25);

        // Act
        final result = AppDateUtils.formatDate(testDate);

        // Assert
        expect(result, '25 ธันวาคม 2567');
      });
    });
  });
}
