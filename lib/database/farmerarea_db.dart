// import 'package:sqflite/sqflite.dart';
// import 'package:gkvk/database/database_service.dart';

// class FarmerareaDb {
//   final DatabaseService _databaseService = DatabaseService();

//   Future<void> createFarmerArea(Map<String, dynamic> data) async {
//     final db = await _databaseService.database;

//     await db.transaction((txn) async {
//       // Insert farmer area
//       for (var hissaNumber in data['hissaNumbers']) {
//         await txn.insert('farmerProfile', {
//           'aadharId': data['aadharId'],
//           'hissaNumber': hissaNumber,
//         });

//         // Insert crop details for each hissaNumber
//         if (data['cropDetails'] != null && data['cropDetails'][hissaNumber] != null) {
//           for (var cropDetails in data['cropDetails'][hissaNumber]) {
//             await txn.insert('cropDetails', {
//               'aadharId': data['aadharId'],
//               'hissaNumber': hissaNumber,
//               'cropName': cropDetails['cropName'],
//               'area': cropDetails['area'],
//               'surveyHissa': cropDetails['surveyHissa'],
//               'variety': cropDetails['variety'],
//               'duration': cropDetails['duration'],
//               'season': cropDetails['season'],
//               'typeOfLand': cropDetails['typeOfLand'],
//               'sourceOfIrrigation': cropDetails['sourceOfIrrigation'],
//               'cost': cropDetails['cost'],
//               'nitrogen': cropDetails['nitrogen'],
//               'phosphorous': cropDetails['phosphorous'],
//               'potassium': cropDetails['potassium'],
//               'rdfNitrogen': cropDetails['rdfNitrogen'],
//               'rdfPhosphorous': cropDetails['rdfPhosphorous'],
//               'rdfPotassium': cropDetails['rdfPotassium'],
//               'adjustedrdfNitrogen': cropDetails['adjustedrdfNitrogen'],
//               'adjustedrdfPhosphorous': cropDetails['adjustedrdfPhosphorous'],
//               'adjustedrdfPotassium': cropDetails['adjustedrdfPotassium'],
//               'organicManureName': cropDetails['organicManureName'],
//               'organicManureQuantity': cropDetails['organicManureQuantity'],
//               'organicManureCost': cropDetails['organicManureCost'],
//               'bioFertilizerName': cropDetails['bioFertilizerName'],
//               'bioFertilizerQuantity': cropDetails['bioFertilizerQuantity'],
//               'bioFertilizerCost': cropDetails['bioFertilizerCost'],
//               'plantProtectionCost': cropDetails['plantProtectionCost'],
//               'ownLabourNumber': cropDetails['ownLabourNumber'],
//               'ownLabourCost': cropDetails['ownLabourCost'],
//               'hiredLabourNumber': cropDetails['hiredLabourNumber'],
//               'hiredLabourCost': cropDetails['hiredLabourCost'],
//               'animalDrawnCost': cropDetails['animalDrawnCost'],
//               'animalMechanizedCost': cropDetails['animalMechanizedCost'],
//               'irrigationCost': cropDetails['irrigationCost'],
//               'otherProductionCost': cropDetails['otherProductionCost'],
//               'totalProductionCost': cropDetails['totalProductionCost'],
//               'mainProductQuantity': cropDetails['mainProductQuantity'],
//               'mainProductPrice': cropDetails['mainProductPrice'],
//               'mainProductAmount': cropDetails['mainProductAmount'],
//               'byProductQuantity': cropDetails['byProductQuantity'],
//               'byProductPrice': cropDetails['byProductPrice'],
//               'byProductAmount': cropDetails['byProductAmount'],
//               'totalByProductAmount1': cropDetails['totalByProductAmount1'],
//               'totalByProductAmount2': cropDetails['totalByProductAmount2'],
//               'totalByProductAmount3': cropDetails['totalByProductAmount3'],
//               'methodsoffertilizer': cropDetails['methodsoffertilizer'],
//             });
//           }
//         }
//       }
//     });
//   }

//   // Additional method to retrieve farmer area data if needed
//   Future<List<Map<String, dynamic>>> getFarmerAreas(int aadharId) async {
//     final db = await _databaseService.database;
//     return await db.query('farmerProfile', where: 'aadharId = ?', whereArgs: [aadharId]);
//   }

//   // Additional method to retrieve crop details for a specific hissaNumber
//   Future<List<Map<String, dynamic>>> getCropDetails(int aadharId, int hissaNumber) async {
//     final db = await _databaseService.database;
//     return await db.query('cropDetails', where: 'aadharId = ? AND hissaNumber = ?', whereArgs: [aadharId, hissaNumber]);
//   }

//   create(int aadharId, int hissaNumber) {}
// }
