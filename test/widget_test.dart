import 'package:flutter_test/flutter_test.dart';
import 'package:dudareceitas/main.dart';

void main() {
  testWidgets('Verifica a tela inicial do aplicativo',
          (WidgetTester tester) async {
        await tester.pumpWidget(const DudaReceitas());

        expect(find.text('Duda Receitas'), findsOneWidget);
        expect(find.text('Receitas'), findsOneWidget);
        expect(find.text('Buscar receitas'), findsOneWidget);
        expect(find.text('Explorar'), findsOneWidget);
        expect(find.text('Favoritos'), findsOneWidget);
      });

  testWidgets('Verifica a tela de favoritos vazia',
          (WidgetTester tester) async {
        await tester.pumpWidget(const DudaReceitas());

        await tester.tap(find.text('Favoritos'));
        await tester.pump();

        expect(find.text('Nenhum favorito'), findsOneWidget);
        expect(find.text('Explorar receitas'), findsOneWidget);
      });
}