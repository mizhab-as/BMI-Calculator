import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial1/bmi_record.dart';

class StorageService {
  static const String _keyBmiRecords = 'bmi_records_key';

  // Save a record
  static Future<void> saveRecord(BmiRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final List<BmiRecord> records = await getRecords();
    
    // Check if the record already exists, update it, else add it
    final int index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      records[index] = record;
    } else {
      records.add(record);
    }

    final List<String> jsonList = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_keyBmiRecords, jsonList);
  }

  // Get all records (sorted from newest to oldest)
  static Future<List<BmiRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_keyBmiRecords);
    if (jsonList == null) return [];

    try {
      final List<BmiRecord> records = jsonList
          .map((item) => BmiRecord.fromJson(jsonDecode(item) as Map<String, dynamic>))
          .toList();
      
      // Sort: newest first
      records.sort((a, b) => b.date.compareTo(a.date));
      return records;
    } catch (e) {
      return [];
    }
  }

  // Delete a specific record by ID
  static Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<BmiRecord> records = await getRecords();
    records.removeWhere((r) => r.id == id);
    
    final List<String> jsonList = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_keyBmiRecords, jsonList);
  }

  // Clear all records
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBmiRecords);
  }
}
