import 'package:cloud_firestore/cloud_firestore.dart';

///Paginates a firestore query
class GeneralPagination {
  late QuerySnapshot collectionState;
  late Query query;

  GeneralPagination({required this.query});

  ///Gets first documents in query
  Future<QuerySnapshot> getFirstDocs({required int first}) async {
    Query _query = this.query.limit(first);
    collectionState = await _query.get();
    return collectionState;
  }

  ///Gets next documents in query. Remembers internally where to start off.
  Future<QuerySnapshot> getNextDocs({required int next}) async {
    if (collectionState.docs.isNotEmpty) {
      var lastVisible = this.collectionState.docs.last;
      //this.collectionState.docs[this.collectionState.docs.length - 1];
      Query _query = query.startAfterDocument(lastVisible).limit(next);
      collectionState = await _query.get();
    }
    return collectionState;
  }
}
