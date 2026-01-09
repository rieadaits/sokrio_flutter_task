import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sokrio_flutter_task/src/domain/entities/user_entity.dart';

part 'users_response.freezed.dart';
part 'users_response.g.dart';

@freezed
abstract class UsersResponse with _$UsersResponse {
  const factory UsersResponse({
    @JsonKey(name: "page") required int page,
    @JsonKey(name: "per_page") required int perPage,
    @JsonKey(name: "total") required int total,
    @JsonKey(name: "total_pages") required int totalPages,
    @JsonKey(name: "data") required List<User> userList,
  }) = _UsersResponse;

  factory UsersResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseFromJson(json);
}

@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "first_name") required String firstName,
    @JsonKey(name: "last_name") required String lastName,
    @JsonKey(name: "avatar") required String avatar,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserXModel on User{
  UserEntity toEntity(){
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      profilePicture: avatar,
    );
  }
}

//For Caching into database
extension UserEntityToModel on UserEntity{
  User toModel(){
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      avatar: profilePicture,
    );
  }
}
