import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final user =
          authState is AuthAuthenticated ? authState.user : null;
          final name = user?.displayName ?? 'User';
          final email = user?.email ?? 'No email';

          return Scaffold(
            backgroundColor: const Color(0xFFF0F4FF),
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              elevation: 0,
            ),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Avatar + name + email
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Info card
                _card(children: [
                  _tile(
                    icon: Icons.person_outline,
                    label: 'Name',
                    value: name,
                  ),
                  _divider(),
                  _tile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: email,
                  ),
                ]),

                const SizedBox(height: 16),

                // Settings card
                _card(children: [
                  _tile(
                    icon: Icons.info_outline,
                    label: 'App Version',
                    value: 'v1.0.0',
                  ),
                  _divider(),
                  _tile(
                    icon: Icons.help_outline,
                    label: 'Help & FAQ',
                    value: '',
                  ),
                  _divider(),
                  _tile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    value: '',
                  ),
                ]),

                const SizedBox(height: 24),

                // Sign out button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmLogout(context),
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black45),
            )
          else
            const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    indent: 50,
    color: Color(0xFFF0F0F0),
  );

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sign Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}