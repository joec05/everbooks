class UserAuthTokensClass{
  String accessToken;
  String accessTokenExpiry;
  String idToken;
  String refreshToken;

  UserAuthTokensClass(
    this.accessToken,
    this.accessTokenExpiry,
    this.idToken,
    this.refreshToken
  );

  Map toMap(){
    return {
      'access_token': accessToken,
      'access_token_expiry': accessTokenExpiry,
      'id_token': idToken,
      'refresh_token': refreshToken
    };
  }

  factory UserAuthTokensClass.fromMap(Map map){
    return UserAuthTokensClass(
      map['access_token'], 
      map['access_token_expiry'], 
      map['id_token'], 
      map['refresh_token']
    );
  }
}