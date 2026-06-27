import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sync_app/main.dart';

void main() {
  testWidgets('renders full-screen map and creates a local post', (
    tester,
  ) async {
    await tester.pumpWidget(const SyncApp());

    expect(find.text('shibuya'), findsOneWidget);
    expect(find.text('3 friends live nearby'), findsOneWidget);
    expect(find.textContaining('35.6595'), findsOneWidget);

    await tester.tap(find.text('Feed'));
    await tester.pumpAndSettle();

    expect(find.text('Near you'), findsOneWidget);
    expect(find.text('今の熱を投稿する'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Flutterで最初の投稿');
    await tester.tap(find.text('Post'));
    await tester.pump();

    expect(find.text('Flutterで最初の投稿'), findsOneWidget);
    expect(find.text('You'), findsOneWidget);
  });
}
