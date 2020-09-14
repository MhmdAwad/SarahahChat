class UserInformation{
  final String username;
  final String email;
  final String uid;
  final String userImage;
  final String userLink;

  UserInformation(this.username, this.email, this.uid, this.userImage, this.userLink);

  Map<String, Object> toMap(){
    return {
      "username":username,
      "email":email,
      "uid":uid,
      "userImage":userImage,
      "userLink": userLink
    };
  }
}