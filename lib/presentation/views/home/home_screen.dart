import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../product/product_list_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../../config/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ProductListScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Navigate to login and removing all previous routes
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('ShopEase'),
          actions: [
            IconButton(
              icon: Icon(
                context.watch<ThemeCubit>().state.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<AuthBloc>().add(LoggedOut());
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          height: 70,
          elevation: 3,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(Icons.shopping_cart_rounded),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
