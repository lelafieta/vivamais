class UserModel {
  final String nome;
  final String email;
  final String telefone;
  String? foto;

  UserModel({
    required this.nome,
    required this.email,
    required this.telefone,
    this.foto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'foto': foto,
    };
  }
}
