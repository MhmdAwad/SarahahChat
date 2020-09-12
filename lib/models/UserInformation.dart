class UserInformation{
  final String username;
  final String email;
  final String uid;
  final String userImage;

  UserInformation(this.username, this.email, this.uid, this.userImage);

  Map<String, Object> toMap(){
    return {
      "username":username,
      "email":email,
      "uid":uid,
      "userImage":userImage
    };
  }
}