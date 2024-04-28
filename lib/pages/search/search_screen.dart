import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/models/user_model.dart';
import 'package:sports_project/pages/user_profile_page/user_profile_screen.dart';

// class User {
//   final String id;
//   final String name;
//   // Add other user properties as needed
//
//   User({required this.id, required this.name});
// }

class SearchScreen extends StatefulWidget {

  static String id = 'SearchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _searchResults = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debouncedSearch();
  }

  Future<void> _debouncedSearch() async {
    setState(() => _loading = true);

    // Debounce the search query
    await Future.delayed(Duration(milliseconds: 500));

    final String query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _loading = false;
      });
      return;
    }

    try {
      final QuerySnapshot<Map<String, dynamic>> users = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      setState(() {
        _searchResults = users.docs.map((doc) => UserModel(uid: doc.id, name: doc['name'],bio: doc['bio'],image: doc['image'])).toList();
        _loading = false;
      });
    } catch (e) {
      print('Error searching users: $e');
      setState(() {
        _searchResults.clear();
        _loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            _debouncedSearch();
          },
          decoration: InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _debouncedSearch();
              },
            ),
          ),
        ),
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results found.'),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return InkWell(
          onTap: (){
            navigateTo(context, UsersProfileScreen(model: user,));
          },
          child: ListTile(
            title: Text('${user.name}'),
            // You can add more UI elements or functionalities here
          ),
        );
      },
    );
  }
}

