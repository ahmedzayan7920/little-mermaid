import 'package:flutter/foundation.dart';
import 'package:puzzle/features/questions/models/questionnaire_answers_model.dart';

abstract class UserModelKeys {
  static const String id = 'id';
  static const String email = 'email';
  static const String child = 'child';
  static const String parent = 'parent';
  static const String userPiece = 'userPiece';
  static const String pieces = 'pieces';
  static const String level = 'level';
  static const String selection = 'selection';
  static const String questionnaireAnswersModel = 'questionnaireAnswersModel';
  static const String score = 'score';
}

class UserModel {
  final String id;
  final String email;
  final ChildModel child;
  final ParentModel parent;
  final int userPiece;
  final List<int> pieces;
  final int level;
  final Map<String, int> selection;
  final QuestionnaireAnswersModel questionnaireAnswersModel;
  final num score;

  UserModel({
    required this.id,
    required this.email,
    required this.child,
    required this.parent,
    required this.userPiece,
    required this.pieces,
    required this.level,
    required this.selection,
    required this.questionnaireAnswersModel,
    required this.score,
  });

  UserModel copyWith({
    String? id,
    String? email,
    ChildModel? child,
    ParentModel? parent,
    int? userPiece,
    List<int>? pieces,
    int? level,
    Map<String, int>? selection,
    QuestionnaireAnswersModel? questionnaireAnswersModel,
    num? score,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      child: child ?? this.child,
      parent: parent ?? this.parent,
      userPiece: userPiece ?? this.userPiece,
      pieces: pieces ?? this.pieces,
      level: level ?? this.level,
      selection: selection ?? this.selection,
      questionnaireAnswersModel:
          questionnaireAnswersModel ?? this.questionnaireAnswersModel,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      UserModelKeys.id: id,
      UserModelKeys.email: email,
      UserModelKeys.child: child.toJson(),
      UserModelKeys.parent: parent.toJson(),
      UserModelKeys.userPiece: userPiece,
      UserModelKeys.pieces: pieces,
      UserModelKeys.level: level,
      UserModelKeys.selection: selection,
      UserModelKeys.questionnaireAnswersModel:
          questionnaireAnswersModel.toJson(),
      UserModelKeys.score: score,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    try {
      return UserModel(
        id: map[UserModelKeys.id] ?? '',
        email: map[UserModelKeys.email] ?? '',
        child: ChildModel.fromJson(map[UserModelKeys.child] ?? {}),
        parent: ParentModel.fromJson(map[UserModelKeys.parent] ?? {}),
        userPiece: map[UserModelKeys.userPiece] ?? 0,
        pieces: List<int>.from(
            (map[UserModelKeys.pieces] as List?)?.map((e) => e) ?? []),
        level: map[UserModelKeys.level] ?? 0,
        selection:
            Map<String, int>.from(map[UserModelKeys.selection] as Map? ?? {}),
        questionnaireAnswersModel: QuestionnaireAnswersModel.fromJson(
          map[UserModelKeys.questionnaireAnswersModel] ?? {},
        ),
        score: map[UserModelKeys.score] ?? 0,
      );
    } catch (e) {
      throw Exception('Error parsing UserModel from JSON: ${e.toString()}');
    }
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, child: $child, parent: $parent, userPiece: $userPiece, pieces: $pieces, level: $level, selection: $selection, questionnaireAnswersModel: $questionnaireAnswersModel, score: $score)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.child == child &&
        other.parent == parent &&
        other.userPiece == userPiece &&
        listEquals(other.pieces, pieces) &&
        other.level == level &&
        mapEquals(other.selection, selection) &&
        other.questionnaireAnswersModel == questionnaireAnswersModel &&
        other.score == score;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        child.hashCode ^
        parent.hashCode ^
        userPiece.hashCode ^
        pieces.hashCode ^
        level.hashCode ^
        selection.hashCode ^
        questionnaireAnswersModel.hashCode ^
        score.hashCode;
  }
}

enum GenderType {
  male,
  female,
}

abstract class ChildModelKeys {
  static const String name = 'name';
  static const String profilePicture = 'profilePicture';
  static const String dateOfBirth = 'dateOfBirth';
  static const String ssn = 'ssn';
  static const String gender = 'gender';
}

class ChildModel {
  final String name;
  final String profilePicture;
  final String dateOfBirth;
  final String ssn;
  final GenderType gender;

  ChildModel({
    required this.name,
    required this.profilePicture,
    required this.dateOfBirth,
    required this.ssn,
    required this.gender,
  });

  ChildModel copyWith({
    String? name,
    String? profilePicture,
    String? dateOfBirth,
    String? ssn,
    GenderType? gender,
  }) {
    return ChildModel(
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      ssn: ssn ?? this.ssn,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ChildModelKeys.name: name,
      ChildModelKeys.profilePicture: profilePicture,
      ChildModelKeys.dateOfBirth: dateOfBirth,
      ChildModelKeys.ssn: ssn,
      ChildModelKeys.gender: gender.name,
    };
  }

  factory ChildModel.fromJson(Map<String, dynamic> map) {
    try {
      return ChildModel(
        name: map[ChildModelKeys.name] ?? '',
        profilePicture: map[ChildModelKeys.profilePicture] ?? '',
        dateOfBirth: map[ChildModelKeys.dateOfBirth] ?? '',
        ssn: map[ChildModelKeys.ssn] ?? '',
        gender: GenderType.values.firstWhere(
          (element) => element.name == (map[ChildModelKeys.gender] ?? ''),
          orElse: () => GenderType.male,
        ),
      );
    } catch (e) {
      throw Exception('Error parsing ChildModel from JSON: ${e.toString()}');
    }
  }

  @override
  String toString() {
    return 'ChildModel(name: $name, profilePicture: $profilePicture, dateOfBirth: $dateOfBirth, ssn: $ssn, gender: $gender)';
  }

  @override
  bool operator ==(covariant ChildModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profilePicture == profilePicture &&
        other.dateOfBirth == dateOfBirth &&
        other.ssn == ssn &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePicture.hashCode ^
        dateOfBirth.hashCode ^
        ssn.hashCode ^
        gender.hashCode;
  }
}

abstract class ParentModelKeys {
  static const String name = 'name';
  static const String ssn = 'ssn';
  static const String relation = 'relation';
  static const String governorate = 'governorate';
  static const String hasClinic = 'hasClinic';
  static const String clinicName = 'clinicName';
  static const String clinicAddress = 'clinicAddress';
  static const String clinicDoctorName = 'clinicDoctorName';
}

class ParentModel {
  final String name;
  final String ssn;
  final String relation;
  final String governorate;
  final bool hasClinic;
  final String? clinicName;
  final String? clinicAddress;
  final String? clinicDoctorName;

  ParentModel({
    required this.name,
    required this.ssn,
    required this.relation,
    required this.governorate,
    required this.hasClinic,
    required this.clinicName,
    required this.clinicAddress,
    required this.clinicDoctorName,
  });

  ParentModel copyWith({
    String? name,
    String? ssn,
    String? relation,
    String? governorate,
    bool? hasClinic,
    String? clinicName,
    String? clinicAddress,
    String? clinicDoctorName,
  }) {
    return ParentModel(
      name: name ?? this.name,
      ssn: ssn ?? this.ssn,
      relation: relation ?? this.relation,
      governorate: governorate ?? this.governorate,
      hasClinic: hasClinic ?? this.hasClinic,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      clinicDoctorName: clinicDoctorName ?? this.clinicDoctorName,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ParentModelKeys.name: name,
      ParentModelKeys.ssn: ssn,
      ParentModelKeys.relation: relation,
      ParentModelKeys.governorate: governorate,
      ParentModelKeys.hasClinic: hasClinic,
      ParentModelKeys.clinicName: clinicName,
      ParentModelKeys.clinicAddress: clinicAddress,
      ParentModelKeys.clinicDoctorName: clinicDoctorName,
    };
  }

  factory ParentModel.fromJson(Map<String, dynamic> map) {
    try {
      return ParentModel(
        name: map[ParentModelKeys.name] ?? '',
        ssn: map[ParentModelKeys.ssn] ?? '',
        relation: map[ParentModelKeys.relation] ?? '',
        governorate: map[ParentModelKeys.governorate] ?? '',
        hasClinic: map[ParentModelKeys.hasClinic] ?? false,
        clinicName: map[ParentModelKeys.clinicName],
        clinicAddress: map[ParentModelKeys.clinicAddress],
        clinicDoctorName: map[ParentModelKeys.clinicDoctorName],
      );
    } catch (e) {
      throw Exception('Error parsing ParentModel from JSON: ${e.toString()}');
    }
  }

  @override
  String toString() {
    return 'ParentModel(name: $name, ssn: $ssn, relation: $relation, governorate: $governorate, hasClinic: $hasClinic, clinicName: $clinicName, clinicAddress: $clinicAddress, clinicDoctorName: $clinicDoctorName)';
  }

  @override
  bool operator ==(covariant ParentModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.ssn == ssn &&
        other.relation == relation &&
        other.governorate == governorate &&
        other.hasClinic == hasClinic &&
        other.clinicName == clinicName &&
        other.clinicAddress == clinicAddress &&
        other.clinicDoctorName == clinicDoctorName;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        ssn.hashCode ^
        relation.hashCode ^
        governorate.hashCode ^
        hasClinic.hashCode ^
        clinicName.hashCode ^
        clinicAddress.hashCode ^
        clinicDoctorName.hashCode;
  }
}
