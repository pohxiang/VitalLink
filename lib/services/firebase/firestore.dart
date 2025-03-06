import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieves all documents from the specified [collectionPath].
  /// Returns a list of maps representing each document's data.
  Future<List<Map<String, dynamic>>> getData(String collectionPath) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection(collectionPath).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching data from $collectionPath: $e');
      rethrow;
    }
  }

  /// Adds [data] to the specified [collectionPath].
  /// Returns a [DocumentReference] pointing to the new document.
  Future<DocumentReference<Map<String, dynamic>>> addData(
      String collectionPath, Map<String, dynamic> data) async {
    try {
      return await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      print('Error adding data to $collectionPath: $e');
      rethrow;
    }
  }

  /// Updates the document with [documentId] in [collectionPath] using [data].
  Future<void> updateData(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      print('Error updating document $documentId in $collectionPath: $e');
      rethrow;
    }
  }

  /// Deletes the document with [documentId] from the specified [collectionPath].
  Future<void> deleteData(String collectionPath, String documentId) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      print('Error deleting document $documentId from $collectionPath: $e');
      rethrow;
    }
  }

  /// Returns a stream of snapshots for all documents in [collectionPath].
  Stream<QuerySnapshot<Map<String, dynamic>>> getDataStream(
      String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }

  /// Returns a stream of snapshots for documents in [collectionPath] where [field] equals [value].
  Stream<QuerySnapshot<Map<String, dynamic>>> getDataStreamWithQuery(
      String collectionPath, String field, dynamic value) {
    return _firestore
        .collection(collectionPath)
        .where(field, isEqualTo: value)
        .snapshots();
  }

  /// Returns a stream of snapshots for documents in [collectionPath] matching [field] equals [value] with a limit of [limit] documents.
  Stream<QuerySnapshot<Map<String, dynamic>>> getDataStreamWithQueryAndLimit(
      String collectionPath, String field, dynamic value, int limit) {
    return _firestore
        .collection(collectionPath)
        .where(field, isEqualTo: value)
        .limit(limit)
        .snapshots();
  }

  /// Returns a stream of snapshots for documents in [collectionPath] where [field] equals [value] ordered by [orderByField] in ascending order.
  Stream<QuerySnapshot<Map<String, dynamic>>> getDataStreamWithQueryAndOrder(
      String collectionPath, String field, dynamic value, String orderByField) {
    return _firestore
        .collection(collectionPath)
        .where(field, isEqualTo: value)
        .orderBy(orderByField)
        .snapshots();
  }

  /// Returns a stream of snapshots for documents in [collectionPath] where [field] equals [value] ordered by [orderByField] in descending order.
  Stream<QuerySnapshot<Map<String, dynamic>>>
      getDataStreamWithQueryAndOrderDescending(String collectionPath,
          String field, dynamic value, String orderByField) {
    return _firestore
        .collection(collectionPath)
        .where(field, isEqualTo: value)
        .orderBy(orderByField, descending: true)
        .snapshots();
  }
}
