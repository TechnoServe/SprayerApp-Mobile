import 'package:sprayer_app/database/locations.dart';

class LocationModel {
  static List<String> provinces = [], districts = [], adminitrativesPosts = [];

  static List<String> getProvinces() {
    provinces.clear();
    if (locations.keys.isNotEmpty) {
      for (var i = 0; i < locations.keys.length; i++) {
        provinces.add(locations.keys.elementAt(i));
      }
    }
    return provinces;
  }

  static List<String> getDistricts(String provinces) {
    districts.clear();
    if (locations[provinces] != null) {
      for (var i = 0; i < locations[provinces].keys.length; i++) {
        districts.add(locations[provinces].keys.elementAt(i));
      }
    }
    return districts;
  }

  static List<String> getAdministrativePosts(
      String provinces, String districts) {
    adminitrativesPosts.clear();
    if (locations[provinces] != null) {
      if (locations[provinces][districts] != null) {
        for (var i = 0; i < locations[provinces][districts].length; i++) {
          adminitrativesPosts.add(locations[provinces][districts].elementAt(i));
        }
      }
    }
    return adminitrativesPosts;
  }
}
