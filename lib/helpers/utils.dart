import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/models/categorymodels.dart';
import 'package:canabs/models/categorylevel.dart';
import 'package:canabs/models/onboardingcontent.dart';
import 'package:canabs/models/subcategory.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Utils {
  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();

  static List<OnboardingContent> getOnboarding() {
    return [
      OnboardingContent(
          message: 'Anon Signing in AAU Navigation Made Easy', img: 'onboard1'),
      OnboardingContent(
          message: 'You can not See Friends Real-Time Location On The Go',
          img: 'onboard2'),
      OnboardingContent(
          message: 'You can not Chat With Other Users Through The Custom Chat',
          img: 'onboard3'),
      OnboardingContent(
          message: 'To use those feature login at any time ', img: 'onboard4'),
    ];
  }

  static List<Category> getMockedCategories() {
    return [
      Category(
          color: AppColors.FACULTYS_color,
          name: "Faculties",
          imgName: "physicalscienceimg",
          icon: const Icon(Icons.class__rounded),
          subCategories: [
            SubCategory(
                color: AppColors.FACULTYS_color,
                name: "Life Science",
                imgName: "lifescience",
                icon: const Icon(Icons.class__rounded),
                destination: const LatLng(6.733945, 6.08392),
                departments: [
                  CategoryDepartment(
                    name: "Biochemistry",
                    imgName: "lifescience",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Micro-Biology",
                    imgName: "lifescience",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Zoology",
                    imgName: "lifescience",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Botany",
                    imgName: "lifescience",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Human Nutrition and Dietetics",
                    imgName: "lifescience",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Plant Science and Biotechnology",
                    imgName: "lifescience",
                    isSelected: false,
                  ),
                ]),
            SubCategory(
                name: "Engineering",
                imgName: "engineeringimg1",
                icon: const Icon(Icons.class__rounded),
                color: AppColors.FACULTYS_color,
                destination: const LatLng(6.740485, 6.079156),
                departments: [
                  CategoryDepartment(
                    name: "Civil Engineering",
                    imgName: "engineeringimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Industrial & Production Engineering",
                    imgName: "engineeringimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Electrical Electronic and Computer Engineering",
                    imgName: "engineeringimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Mechanical Engineering",
                    imgName: "engineeringimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Agricultural and Bio-resources Engineering",
                    imgName: "engineeringimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Materials and Metallurgical Engineering",
                    imgName: "engineeringimg2",
                    isSelected: false,
                  ),
                ]),
            SubCategory(
                name: "Physical Science",
                imgName: "physicalscienceimg",
                icon: const Icon(Icons.class__rounded),
                color: AppColors.FACULTYS_color,
                destination: const LatLng(6.733249, 6.081892),
                departments: [
                  CategoryDepartment(
                    name: "Computer Science",
                    imgName: "physicalscienceimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Physics and Geophysics",
                    imgName: "physicalscienceimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Mathematics and Statistics",
                    imgName: "physicalscienceimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Chemistry",
                    imgName: "physicalscienceimg",
                    isSelected: false,
                  ),
                ]),
            SubCategory(
                name: "Management",
                imgName: "managementimg",
                icon: const Icon(Icons.class__rounded),
                color: AppColors.FACULTYS_color,
                destination: const LatLng(6.7335, 6.07371),
                departments: [
                  CategoryDepartment(
                    name: "Accounting",
                    imgName: "managementimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Banking and Finance",
                    imgName: "managementimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Buisness administration",
                    imgName: "managementimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Public administration",
                    imgName: "managementimg",
                    isSelected: false,
                  ),
                ]),
            SubCategory(
                name: "Law",
                imgName: "lawimg",
                icon: const Icon(Icons.class__rounded),
                color: AppColors.FACULTYS_color,
                destination: const LatLng(6.731233, 6.077045),
                departments: [
                  CategoryDepartment(
                    name: "Commercial and Industrial Law",
                    imgName: "lawimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Private and PropertyLaw",
                    imgName: "lawimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Public Law",
                    imgName: "lawimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Jurisprudence and Internatonal Law",
                    imgName: "lawimg",
                    isSelected: false,
                  ),
                ]),
            SubCategory(
                name: "Environmental Sciences",
                imgName: "environmentalimg",
                icon: const Icon(Icons.class__rounded),
                color: AppColors.FACULTYS_color,
                destination: const LatLng(6.732865, 6.082964),
                departments: [
                  CategoryDepartment(
                    name: "Building",
                    imgName: "environmentalimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Architecture",
                    imgName: "environmentalimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Fine and Applied Arts",
                    imgName: "environmentalimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Geography and Environmental Management",
                    imgName: "environmentalimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Visual and Creative design",
                    imgName: "environmentalimg",
                    isSelected: false,
                  ),
                ]),
            SubCategory(
                name: "Art",
                imgName: "artimg2",
                icon: const Icon(Icons.class__rounded),
                color: AppColors.FACULTYS_color,
                destination: const LatLng(6.731061, 6.075325),
                departments: [
                  CategoryDepartment(
                    name: "Theatre and Media Arts",
                    imgName: "artimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "History and international studies",
                    imgName: "artimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Modern Languages",
                    imgName: "artimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Religious Management and cultural studies",
                    imgName: "artimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "French",
                    imgName: "artimg2",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "English",
                    imgName: "artimg2",
                    isSelected: false,
                  ),
                ]),
            SubCategory(
                name: "Education",
                imgName: "educationimg",
                icon: const Icon(Icons.class__rounded),
                color: AppColors.FACULTYS_color,
                destination: const LatLng(6.736296, 6.08528),
                departments: [
                  CategoryDepartment(
                    name: "Business Education",
                    imgName: "educationimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Curriculum and Instructions",
                    imgName: "educationimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Guidance and Counselling",
                    imgName: "educationimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Physical and Health Education",
                    imgName: "educationimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Library and Information Science",
                    imgName: "educationimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Vocational Technical Education",
                    imgName: "educationimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Human Kinetics and Health Education",
                    imgName: "educationimg",
                    isSelected: false,
                  ),
                ]),
            SubCategory(
                name: "Mass Communication",
                imgName: "masscom",
                icon: const Icon(Icons.class__rounded),
                color: AppColors.FACULTYS_color,
                destination: const LatLng(6.737558, 6.084544),
                departments: [
                  CategoryDepartment(
                    name: "Business Education",
                    imgName: "masscom",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Curriculum and Instructions",
                    imgName: "masscom",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Guidance and Counselling",
                    imgName: "masscom",
                    isSelected: false,
                  ),
                ]),
            SubCategory(
                name: "Socail Science",
                imgName: "socialscienceimg",
                icon: const Icon(Icons.class__rounded),
                color: AppColors.FACULTYS_color,
                destination: const LatLng(6.731744, 6.083872),
                departments: [
                  CategoryDepartment(
                    name: "Economics",
                    imgName: "socialscienceimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Political sciences",
                    imgName: "socialscienceimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Psychology",
                    imgName: "socialscienceimg",
                    isSelected: false,
                  ),
                  CategoryDepartment(
                    name: "Sociology",
                    imgName: "socialscienceimg",
                    isSelected: false,
                  ),
                ]),
          ]),
      Category(
          color: AppColors.HOSTELS_color,
          name: "Hostels",
          imgName: "kudirathostel",
          icon: const Icon(Icons.hotel_rounded),
          subCategories: [
            SubCategory(
              color: AppColors.HOSTELS_color,
              name: "Igbinedion Hostel",
              imgName: "kudirathostel",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.740762, 6.077863),
            ),
            SubCategory(
              color: AppColors.HOSTELS_color,
              name: "kudirat Hostel",
              imgName: "kudirathostel",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.739716, 6.077151),
            ),
            SubCategory(
              color: AppColors.HOSTELS_color,
              name: "Emotan Hostel",
              imgName: "kudirathostel",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.737832, 6.078004),
            ),
            SubCategory(
              color: AppColors.HOSTELS_color,
              name: "Big Joe Hostel",
              imgName: "kudirathostel",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.741138, 6.078592),
            ),
            SubCategory(
              color: AppColors.HOSTELS_color,
              name: "Onyerugbulem Female Hostel",
              imgName: "kudirathostel",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.740461, 6.077357),
            ),
            SubCategory(
              color: AppColors.HOSTELS_color,
              name: "Reverend Martins Hostel",
              imgName: "revmartins",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.738639, 6.078279),
            ),
            SubCategory(
              color: AppColors.HOSTELS_color,
              name: "Onyerugbulem Male Hostel",
              imgName: "kudirathostel",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.738769, 6.078383),
            ),
            SubCategory(
              color: AppColors.HOSTELS_color,
              name: "Iyare Female Hostel",
              imgName: "iyera",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.740109, 6.07739),
            ),
            SubCategory(
              color: AppColors.HOSTELS_color,
              name: "EMARARE HOSTEL",
              imgName: "emarare",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.740485, 6.079156),
            ),
          ]),
      Category(
          color: AppColors.EATRY_color,
          name: "Eatery",
          imgName: "oilwell",
          icon: const Icon(Icons.food_bank_rounded),
          subCategories: [
            SubCategory(
              color: AppColors.EATRY_color,
              name: "Oil Well",
              imgName: "oilwell",
              icon: const Icon(Icons.food_bank_rounded),
              destination: const LatLng(6.737235, 6.07857),
            ),
            SubCategory(
              color: AppColors.EATRY_color,
              name: "AAU Co-Operative",
              imgName: "cooperative",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.739322, 6.081479),
            ),
            SubCategory(
              color: AppColors.EATRY_color,
              name: "bush bar",
              imgName: "cooperative",
              icon: const Icon(Icons.hotel_rounded),
              destination: const LatLng(6.739219, 6.08159),
            ),
          ]),
      Category(
          color: AppColors.ADMIN_color,
          name: "Administrative  Building",
          imgName: "administrative1",
          icon: const Icon(Icons.admin_panel_settings_rounded),
          subCategories: [
            SubCategory(
              color: AppColors.ADMIN_color,
              name: "New Administrative  Building",
              imgName: "administrative",
              icon: const Icon(Icons.admin_panel_settings_rounded),
              destination: const LatLng(6.7394915, 6.0838388),
            ),
            SubCategory(
              color: AppColors.ADMIN_color,
              name: "Old Admin Building",
              imgName: "oldadmin",
              icon: const Icon(Icons.admin_panel_settings_rounded),
              destination: const LatLng(6.736878, 6.082065),
            ),
            SubCategory(
              color: AppColors.ADMIN_color,
              name: "ICT Building",
              imgName: "ict",
              icon: const Icon(Icons.admin_panel_settings_rounded),
              destination: const LatLng(6.733064, 6.085131),
            ),
            SubCategory(
              color: AppColors.ADMIN_color,
              name: "University Bookshop",
              imgName: "ict2",
              icon: const Icon(Icons.admin_panel_settings_rounded),
              destination: const LatLng(6.738173, 6.081917),
            ),
            SubCategory(
              color: AppColors.ADMIN_color,
              name: "Ambrose Ali University Press",
              imgName: "press",
              icon: const Icon(Icons.admin_panel_settings_rounded),
              destination: const LatLng(6.736883, 6.083592),
            ),
            SubCategory(
              color: AppColors.ADMIN_color,
              name: "Health Center",
              imgName: "healthcenter",
              icon: const Icon(Icons.admin_panel_settings_rounded),
              destination: const LatLng(6.739833, 6.086273),
            ),
          ]),
      Category(
          color: AppColors.LIBRARY_color,
          name: "Library",
          imgName: "oilwell",
          icon: const Icon(Icons.library_books_rounded),
          subCategories: [
            SubCategory(
              color: AppColors.LIBRARY_color,
              name: "Main Library",
              imgName: "physicalscienceimg",
              icon: const Icon(Icons.library_books_rounded),
              destination: const LatLng(6.731201, 6.086821),
            ),
            SubCategory(
              color: AppColors.LIBRARY_color,
              name: "E-Library",
              imgName: "cooperative",
              icon: const Icon(Icons.library_books_rounded),
              destination: const LatLng(6.731201, 6.086821),
            ),
          ]),
      Category(
          color: AppColors.CHURCH_color,
          name: "Worship Center",
          imgName: "church",
          icon: const Icon(Icons.healing_rounded),
          subCategories: [
            SubCategory(
              color: AppColors.CHURCH_color,
              name: "St PATRICK'S  Catholic church",
              imgName: "johnchurch",
              icon: const Icon(Icons.healing_rounded),
              destination: const LatLng(6.732862, 6.076906),
            ),
            SubCategory(
              color: AppColors.CHURCH_color,
              name: "Mosque",
              imgName: "mosque",
              icon: const Icon(Icons.healing_rounded),
              destination: const LatLng(6.732931, 6.079148),
            ),
            SubCategory(
              color: AppColors.CHURCH_color,
              name: "NIFES CF AAU CHAPTER",
              imgName: "church",
              icon: const Icon(Icons.healing_rounded),
              destination: const LatLng(6.734179, 6.077688),
            ),
            SubCategory(
              color: AppColors.CHURCH_color,
              name: "Deeper Life Bibile Church",
              imgName: "church",
              icon: const Icon(
                Icons.healing_rounded,
                color: AppColors.CHURCH_color,
                size: 50,
              ),
              destination: const LatLng(6.734487, 6.078504),
            ),
            SubCategory(
              color: AppColors.CHURCH_color,
              name: "CHAPEL OF THE GOOD SHEPHERD",
              imgName: "goodshep",
              icon: const Icon(
                Icons.healing_rounded,
                color: AppColors.CHURCH_color,
                size: 50,
              ),
              destination: const LatLng(6.732463, 6.075288),
            ),
          ]),
    ];
  }

  static String deviceSuffix(BuildContext context) {
    String deviceSuffix = '';
    TargetPlatform platform = Theme.of(context).platform;
    switch (platform) {
      case TargetPlatform.android:
        deviceSuffix = '_android';
        break;
      case TargetPlatform.iOS:
        deviceSuffix = '_ios';
        break;
      default:
        deviceSuffix = '';
        break;
    }
    return deviceSuffix;
  }
}
