import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _statusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildUserInfo(),
          _buildSearchAndFilter(),
          Expanded(child: _buildUsersList()),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        final userModel = authProvider.userModel;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${userModel?.name ?? 'User'}!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Email: ${user?.email}'),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    user?.emailVerified == true
                        ? Icons.verified
                        : Icons.warning,
                    color: user?.emailVerified == true
                        ? Colors.green
                        : Colors.orange,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Email Status: ${user?.emailVerified == true ? 'Verified' : 'Not Verified'}',
                    style: TextStyle(
                      color: user?.emailVerified == true
                          ? Colors.green[700]
                          : Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (user?.emailVerified == false) ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final user = authProvider.user;
                          if (user != null) {
                            await authProvider.sendEmailVerification();

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Verification email sent!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No user is logged in.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to send email: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text('Send Verification'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        await authProvider.reloadUser();

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Status refreshed!')),
                        );
                      },
                      child: Text('Refresh Status'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name or email...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('Filter by status: '),
              SizedBox(width: 8),
              DropdownButton<String?>(
                value: _statusFilter,
                hint: Text('All'),
                items: [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: 'verified', child: Text('Verified')),
                  DropdownMenuItem(
                    value: 'unverified',
                    child: Text('Not Verified'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _statusFilter = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder<List<UserModel>>(
      stream: _firestoreService.getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found'));
        }

        List<UserModel> users = snapshot.data!;

        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          users = users.where((user) {
            return user.name.toLowerCase().contains(_searchQuery) ||
                user.email.toLowerCase().contains(_searchQuery);
          }).toList();
        }

        // Apply status filter
        if (_statusFilter != null) {
          users = users.where((user) {
            if (_statusFilter == 'verified') {
              return user.isEmailVerified;
            } else if (_statusFilter == 'unverified') {
              return !user.isEmailVerified;
            }
            return true;
          }).toList();
        }

        if (users.isEmpty) {
          return Center(child: Text('No users match your criteria'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: user.isEmailVerified
                      ? Colors.green
                      : Colors.orange,
                  child: Icon(
                    user.isEmailVerified ? Icons.verified_user : Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  user.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          user.isEmailVerified
                              ? Icons.check_circle
                              : Icons.warning,
                          color: user.isEmailVerified
                              ? Colors.green
                              : Colors.orange,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          user.isEmailVerified ? 'Verified' : 'Not Verified',
                          style: TextStyle(
                            color: user.isEmailVerified
                                ? Colors.green[700]
                                : Colors.orange[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
