import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vivamais/src/features/auth/data/firebase_data_sources/i_firebase_data_sources.dart';
import 'package:vivamais/src/features/user/domain/entities/user_entity.dart';

import '../../../../core/api/firebase_const.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../user/data/models/user_model.dart';

class FirebaseDataSources implements IFirebaseDataSources {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseDataSources(
      {required this.firebaseFirestore,
      required this.firebaseAuth,
      required this.firebaseStorage});

  Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
    // final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    // final uid = await getCurrentUid();

    // userCollection.doc(uid).get().then((userDoc) {
    //   final newUser = UserModel(
    //           uid: uid,
    //           name: user.name,
    //           email: user.email,
    //           bio: user.bio,
    //           following: user.following,
    //           website: user.website,
    //           profileUrl: profileUrl,
    //           username: user.username,
    //           totalFollowers: user.totalFollowers,
    //           followers: user.followers,
    //           totalFollowing: user.totalFollowing,
    //           totalPosts: user.totalPosts)
    //       .toJson();

    //   if (!userDoc.exists) {
    //     userCollection.doc(uid).set(newUser);
    //   } else {
    //     userCollection.doc(uid).update(newUser);
    //   }
    // }).catchError((error) {
    //   AppConstants.toast("Some error occur");
    // });
  }

  @override
  Future<void> createUser(UserEntity user) async {
    // final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    // final uid = await getCurrentUid();

    // userCollection.doc(uid).get().then((userDoc) {
    //   final newUser = UserModel(
    //           uid: uid,
    //           name: user.name,
    //           email: user.email,
    //           bio: user.bio,
    //           following: user.following,
    //           website: user.website,
    //           profileUrl: user.profileUrl,
    //           username: user.username,
    //           totalFollowers: user.totalFollowers,
    //           followers: user.followers,
    //           totalFollowing: user.totalFollowing,
    //           totalPosts: user.totalPosts)
    //       .toJson();

    //   if (!userDoc.exists) {
    //     userCollection.doc(uid).set(newUser);
    //   } else {
    //     userCollection.doc(uid).update(newUser);
    //   }
    // }).catchError((error) {
    //   AppConstants.toast("Some error occur");
    // });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: otherUid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty && user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        debugPrint("fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        AppConstants.toast("user not found");
      } else if (e.code == "wrong-password") {
        AppConstants.toast("Invalid email or password");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!)
          .then((currentUser) async {
        if (currentUser.user?.uid != null) {
          if (user.avatar_url != null) {
            uploadImageProfileToStorage(user.avatar_url as File?)
                .then((profileUrl) {
              createUserWithImage(user, profileUrl);
            });
          } else {
            createUserWithImage(user, "");
          }
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        AppConstants.toast("email is already taken");
      } else {
        AppConstants.toast("something went wrong");
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    Map<String, dynamic> userInformation = {};

    // if (user.username != "" && user.username != null) {
    //   userInformation['username'] = user.username;
    // }

    // if (user.website != "" && user.website != null) {
    //   userInformation['website'] = user.website;
    // }

    // if (user.profileUrl != "" && user.profileUrl != null) {
    //   userInformation['profileUrl'] = user.profileUrl;
    // }

    // if (user.bio != "" && user.bio != null) userInformation['bio'] = user.bio;

    // if (user.name != "" && user.name != null) {
    //   userInformation['name'] = user.name;
    // }

    // if (user.totalFollowing != null) {
    //   userInformation['totalFollowing'] = user.totalFollowing;
    // }

    // if (user.totalFollowers != null) {
    //   userInformation['totalFollowers'] = user.totalFollowers;
    // }

    // if (user.totalPosts != null) {
    //   userInformation['totalPosts'] = user.totalPosts;
    // }

    // userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> uploadImageProfileToStorage(File? file) async {
    Reference ref = firebaseStorage
        .ref()
        .child("profileImages")
        .child(firebaseAuth.currentUser!.uid);

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }

  @override
  Future<void> followUnFollowUser(UserEntity user) async {
    // final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    // final myDocRef = await userCollection.doc(user.uid).get();
    // final otherUserDocRef = await userCollection.doc(user.otherUid).get();

    // if (myDocRef.exists && otherUserDocRef.exists) {
    //   List myFollowingList = myDocRef.get("following");
    //   List otherUserFollowersList = otherUserDocRef.get("followers");

    //   // My Following List
    //   if (myFollowingList.contains(user.otherUid)) {
    //     userCollection.doc(user.uid).update({
    //       "following": FieldValue.arrayRemove([user.otherUid])
    //     }).then((value) {
    //       final userCollection =
    //           firebaseFirestore.collection(FirebaseConst.users).doc(user.uid);

    //       userCollection.get().then((value) {
    //         if (value.exists) {
    //           final totalFollowing = value.get('totalFollowing');
    //           userCollection.update({"totalFollowing": totalFollowing - 1});
    //           return;
    //         }
    //       });
    //     });
    //   } else {
    //     userCollection.doc(user.uid).update({
    //       "following": FieldValue.arrayUnion([user.otherUid])
    //     }).then((value) {
    //       final userCollection =
    //           firebaseFirestore.collection(FirebaseConst.users).doc(user.uid);

    //       userCollection.get().then((value) {
    //         if (value.exists) {
    //           final totalFollowing = value.get('totalFollowing');
    //           userCollection.update({"totalFollowing": totalFollowing + 1});
    //           return;
    //         }
    //       });
    //     });
    //   }

    //   // Other User Following List
    //   if (otherUserFollowersList.contains(user.uid)) {
    //     userCollection.doc(user.otherUid).update({
    //       "followers": FieldValue.arrayRemove([user.uid])
    //     }).then((value) {
    //       final userCollection = firebaseFirestore
    //           .collection(FirebaseConst.users)
    //           .doc(user.otherUid);

    //       userCollection.get().then((value) {
    //         if (value.exists) {
    //           final totalFollowers = value.get('totalFollowers');
    //           userCollection.update({"totalFollowers": totalFollowers - 1});
    //           return;
    //         }
    //       });
    //     });
    //   } else {
    //     userCollection.doc(user.otherUid).update({
    //       "followers": FieldValue.arrayUnion([user.uid])
    //     }).then((value) {
    //       final userCollection = firebaseFirestore
    //           .collection(FirebaseConst.users)
    //           .doc(user.otherUid);

    //       userCollection.get().then((value) {
    //         if (value.exists) {
    //           final totalFollowers = value.get('totalFollowers');
    //           userCollection.update({"totalFollowers": totalFollowers + 1});
    //           return;
    //         }
    //       });
    //     });
    //   }
    // }
  }

  @override
  Future<bool> sendOtpNumber(String code, String verificationId) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);

      final user = await firebaseAuth.signInWithCredential(credential);
      print("TRUEEEEE $user");
      return true;
    } catch (e) {
      print("DEU UM ERRO");
      print(e);
      return false;
    }
  }

  @override
  Future<bool> verifyNumber(String number) {
    // TODO: implement verifyNumber
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /************************ */

  @override
  Future<void> signInWithCredential(String verificationId, String smsCode) {
    // TODO: implement signInWithCredential
    throw UnimplementedError();
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber,
      Function(String verificationId, int? resendToken) codeSent) {
    // TODO: implement verifyPhoneNumber
    throw UnimplementedError();
  }
}
