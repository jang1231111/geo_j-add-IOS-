import 'package:geo_j/data/repositories/user_repository.dart';
import 'package:geo_j/models/user.dart';

class UserProvider {
  final UserRepository repository = UserRepository();
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    _users = await repository.getAllUsers();
  }

  Future<void> addUser(User user) async {
    await repository.addUser(user);
    await fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    await repository.deleteUser(id);
    await fetchUsers();
  }
}
