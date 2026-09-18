import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futbolix_mobile/app/demo_store.dart';
import 'package:futbolix_mobile/app/futbolix_app.dart';
import 'package:futbolix_mobile/features/participants/presentation/teams_page.dart';

Future<void> openPreview(
  WidgetTester tester,
  DemoStore store, {
  double width = 393,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 852);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(FutbolixApp(store: store));
  await tester.pumpAndSettle();
}

Future<void> selectTab(WidgetTester tester, int index) async {
  await tester.tap(find.byKey(ValueKey('nav-$index')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('all five tabs render on a narrow Android screen', (
    tester,
  ) async {
    final store = DemoStore();
    await openPreview(tester, store, width: 360);
    expect(find.text('İyi günler,'), findsOneWidget);
    for (final tab in [1, 2, 3, 4, 0]) {
      await selectTab(tester, tab);
      expect(tester.takeException(), isNull);
    }
    expect(find.text('İyi günler,'), findsOneWidget);
  });

  testWidgets('following a team updates other tabs and Turkish search works', (
    tester,
  ) async {
    final store = DemoStore();
    await openPreview(tester, store);
    await selectTab(tester, 3);
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is FollowButton && widget.teamName == 'Beşiktaş',
      ),
    );
    await tester.pumpAndSettle();
    expect(store.follows('bjk'), isTrue);
    await tester.enterText(
      find.byKey(const ValueKey('team-search')),
      'besiktas',
    );
    await tester.pumpAndSettle();
    expect(find.text('Beşiktaş'), findsOneWidget);
    expect(find.text('Galatasaray'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('team-search')),
      'olmayan-takim',
    );
    await tester.pumpAndSettle();
    expect(find.text('Aramana uygun takım bulunamadı.'), findsOneWidget);
    await selectTab(tester, 4);
    expect(find.text('4 takım'), findsOneWidget);
    expect(store.followedTeams.length, 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets('favorite match filtering reflects a removed favorite', (
    tester,
  ) async {
    final store = DemoStore();
    await openPreview(tester, store);
    await selectTab(tester, 1);
    await tester.tap(find.byTooltip('Maçı favorilerden çıkar').first);
    await tester.pumpAndSettle();
    expect(store.isFavoriteMatch('derby'), isFalse);
    await tester.tap(find.text('Favoriler'));
    await tester.pumpAndSettle();
    expect(find.text('Galatasaray'), findsNothing);
    expect(find.text('Man City'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('news filter, detail sheet and read count work together', (
    tester,
  ) async {
    final store = DemoStore();
    await openPreview(tester, store);
    await selectTab(tester, 2);
    await tester.tap(find.text('Transfer'));
    await tester.pumpAndSettle();
    expect(
      find.text("Fenerbahçe'de sakatlık şoku: Tadic 3 hafta yok"),
      findsNothing,
    );
    await tester.tap(
      find
          .text(
            'Galatasaray, Ajax forması giyen genç stoper için resmi teklifini iletti',
          )
          .first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Haber detayı'), findsOneWidget);
    expect(store.readCount, 42);
    await tester.tap(find.byTooltip('Kapat'));
    await tester.pumpAndSettle();
    await selectTab(tester, 4);
    expect(find.text('42'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings can be changed and Android back returns to home', (
    tester,
  ) async {
    final store = DemoStore();
    await openPreview(tester, store);
    await selectTab(tester, 4);
    await tester.tap(find.text('Bildirim ayarları'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SwitchListTile, 'Gol bildirimleri'));
    await tester.pumpAndSettle();
    expect(store.goalNotifications, isFalse);
    await tester.tap(find.byTooltip('Kapat'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('İyi günler,'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
