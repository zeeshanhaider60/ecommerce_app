import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.name,
    required super.phone,
    required super.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      name: Name(
        firstname: json['name']['firstname'],
        lastname: json['name']['lastname'],
      ),
      phone: json['phone'],
      address: Address(
        city: json['address']['city'],
        street: json['address']['street'],
        number: json['address']['number'],
        zipcode: json['address']['zipcode'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': {'firstname': name.firstname, 'lastname': name.lastname},
      'phone': phone,
      'address': {
        'city': address.city,
        'street': address.street,
        'number': address.number,
        'zipcode': address.zipcode,
      },
    };
  }
}
