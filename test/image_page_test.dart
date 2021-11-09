import 'package:flutter_test/flutter_test.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/ui/views/photo_details/image_page.dart';

void main() {
  testWidgets('Image Page Test', (WidgetTester tester) async {
    final image = ImageEntity.fromMap({
      ImageEntity.keyImage: 'xxx',
    });
    await tester.pumpWidget(ImagePage(image: image));
    await tester.pumpAndSettle();
  });
}
