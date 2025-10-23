import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../managers/expense_manager.dart';
import '../models/expense.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  final List<String> _titles = [
    'Home',
    'Favorite',
    'Profile',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(user: widget.user),
      const FavoritePage(),
      ProfileScreen(user: widget.user),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 33, 180),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 243, 33, 180),
        onPressed: () {
          Navigator.pushNamed(context, '/expense', arguments: widget.user);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 243, 33, 180),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color.fromARGB(187, 255, 193, 231),
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

// ----------------------------
// 🔸 Halaman HomePage (produk + expense)
// ----------------------------
class HomePage extends StatelessWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // 🔹 Filter expense berdasarkan user yang login
    var expenses = ExpenseManager.expenses
        .where((e) => e.username == user.username)
        .toList();
    var highest = expenses.isNotEmpty
        ? expenses.reduce((a, b) => a.amount > b.amount ? a : b)
        : null;

    final List<Map<String, String>> products = [
      {'name': 'Keychain Sweet Red', 'image': 'assets/keychain.png'},
      {'name': 'Rose Gold Smartwatch', 'image': 'assets/smartwatch.png'},
      {'name': 'Shining Pearl Bracelet', 'image': 'assets/bracelet.png'},
      {'name': 'Blink Star Earrings', 'image': 'assets/earrings.png'},
      {'name': 'Bag Charm Spring Bunny', 'image': 'assets/bagcharm.png'},
      {'name': 'Coquette Necklace', 'image': 'assets/necklace.png'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Image.asset('assets/logo.png', height: 80),
          const SizedBox(height: 16),

          // 🔹 Grid Produk
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            products[index]['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          products[index]['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // 🔹 Ringkasan Pengeluaran
          const Text(
            "💰 Analisis Pengeluaran Bisnis",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            color: Colors.pink[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(
                highest != null
                    ? "Pengeluaran tertinggi: ${highest.title}"
                    : "Belum ada data pengeluaran",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: highest != null
                  ? Text("Rp${highest.amount.toStringAsFixed(0)}")
                  : null,
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/expense', arguments: user);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 243, 33, 180),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Lihat Detail",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}