import 'package:my_diet_diary/DataObjects/FoodEntry.dart';
import 'package:openfoodfacts/model/ProductResult.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/LanguageHelper.dart';
import 'package:openfoodfacts/utils/ProductFields.dart';
import 'package:openfoodfacts/utils/ProductQueryConfigurations.dart';

class OpenFoodFactsHelper{

  Future<String> getFoodFromBarcode (String barcode) async {
    ProductQueryConfiguration configurations = ProductQueryConfiguration(
        barcode,
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: [ProductField.NAME,
          ProductField.GENERIC_NAME]);

    ProductResult result = await OpenFoodAPIClient.getProduct(configurations);

    if(result.status != 1 || result == null) {
      return "Error retreiving the product";
    }else{
      return result.product.productName;
    }

  }

}