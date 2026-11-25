import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('shows public project data and its detail', (tester) async {
    var requests = 0;
    final apiClient = ApiClient(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/projects/');
        expect(request.headers['Authorization'], isNull);
        requests++;
        return http.Response(
          jsonEncode([
            {
              'id': '683b9349-1bc4-41b9-917b-e35ca603f50a',
              'title': 'MyPortfolio',
              'description': 'Aplikasi portofolio pribadi',
              'tech_stack': 'Flutter, Django',
              'project_url': 'https://example.com/',
              'project_image_url': null,
            },
          ]),
          200,
        );
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: apiClient));
    expect(find.text('Callysta Arviana'), findsOneWidget);

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar Proyek'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'MyPortfolio'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Proyek'), findsOneWidget);
    expect(find.text('Aplikasi portofolio pribadi'), findsOneWidget);
    expect(find.text('Flutter, Django'), findsOneWidget);
    expect(find.text('https://example.com/'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(requests, 1);
  });

  testWidgets('guards both entries and creates a project with a token', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calls = <String>[];
    final apiClient = ApiClient(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        calls.add(request.url.path);
        switch (request.url.path) {
          case '/api/v1/auth/token/':
            expect(jsonDecode(request.body), {
              'username': 'owner',
              'password': 'test-password',
            });
            return http.Response('{"token":"test-token"}', 200);
          case '/api/v1/projects/':
            expect(request.headers['Authorization'], 'Token test-token');
            final data = jsonDecode(request.body) as Map<String, dynamic>;
            expect(data, {
              'title': 'Proyek Tutorial',
              'description': 'Aplikasi portofolio pribadi',
              'tech_stack': 'Flutter, Django',
              'project_url': 'https://example.com/',
              'project_image_url': '',
            });
            return http.Response(jsonEncode({...data, 'id': 'server-id'}), 201);
          case '/api/v1/auth/logout/':
            expect(request.headers['Authorization'], 'Token test-token');
            return http.Response('', 204);
          default:
            throw StateError('Unexpected request ${request.url}');
        }
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: apiClient));

    final drawer = find.byTooltip('Open navigation menu');
    await tester.tap(drawer);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsNothing);
    expect(calls, isEmpty);

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    final loginFields = find.byType(TextFormField);
    await tester.enterText(loginFields.at(0), 'owner');
    await tester.enterText(loginFields.at(1), 'test-password');
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);

    final fields = find.byType(TextFormField);
    final save = find.widgetWithText(ElevatedButton, 'Save');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(calls, ['/api/v1/auth/token/']);

    await tester.ensureVisible(fields.at(0));
    await tester.enterText(fields.at(0), 'Proyek Tutorial');
    await tester.ensureVisible(fields.at(1));
    await tester.enterText(fields.at(1), 'Aplikasi portofolio pribadi');
    await tester.ensureVisible(fields.at(2));
    await tester.enterText(fields.at(2), 'Flutter, Django');
    await tester.ensureVisible(fields.at(3));
    await tester.enterText(fields.at(3), 'https://example.com/');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Proyek Tutorial'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Proyek Tutorial'), findsNothing);

    await tester.tap(drawer);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Berhasil logout.'), findsOneWidget);
    expect(calls, [
      '/api/v1/auth/token/',
      '/api/v1/projects/',
      '/api/v1/auth/logout/',
    ]);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
