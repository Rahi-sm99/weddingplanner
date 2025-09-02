// A single-file Flutter application for a professional wedding planner app.
// This code demonstrates a clean architecture, state management with Provider,
// and a modern, appealing UI with dynamic features.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const WeddingApp());
}

final ThemeData kWeddingTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFF06292),
    primary: const Color(0xFFF06292),
    secondary: const Color(0xFF81C784),
    background: const Color(0xFFF4F4F9),
    brightness: Brightness.light,
  ),
  fontFamily: 'Montserrat',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    ),
  ),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 4,
    color: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.white,
    headerBackgroundColor: const Color(0xFFF06292),
    headerForegroundColor: Colors.white,
    dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFF06292);
      }
      return Colors.white;
    }),
    dayForegroundColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
      }
      return Colors.black;
    }),
  ),
);

final ThemeData kWeddingDarkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFF06292),
    primary: const Color(0xFFF06292),
    secondary: const Color(0xFF81C784),
    background: const Color(0xFF121212),
    brightness: Brightness.dark,
  ),
  fontFamily: 'Montserrat',
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    ),
  ),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 4,
    color: const Color(0xFF1E1E1E),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: const Color(0xFF1E1E1E),
    headerBackgroundColor: const Color(0xFFF06292),
    headerForegroundColor: Colors.white,
    dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFF06292);
      }
      return const Color(0xFF1E1E1E);
    }),
    dayForegroundColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
      }
      return Colors.white;
    }),
  ),
);

enum ThemeModeOption { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  ThemeModeOption _themeMode = ThemeModeOption.light;

  ThemeModeOption get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeModeOption.dark ? ThemeModeOption.light : ThemeModeOption.dark;
    notifyListeners();
  }

  void setTheme(ThemeModeOption mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

class WeddingApp extends StatelessWidget {
  const WeddingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChecklistProvider()),
        ChangeNotifierProvider(create: (_) => VenueProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Wedding Planner',
            theme: kWeddingTheme,
            darkTheme: kWeddingDarkTheme,
            themeMode: themeProvider.themeMode == ThemeModeOption.dark ? ThemeMode.dark : ThemeMode.light,
            home: Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return auth.user != null ? const HomeScreen() : const AuthScreen();
              },
            ),
          );
        },
      ),
    );
  }
}

class User {
  final String uid;
  final String email;

  User({required this.uid, required this.email});
}

class Task {
  final String id;
  String title;
  bool isCompleted;
  String imageUrl;
  double hours;
  bool isFeatured;
  double pricePerHour;
  DateTime? bookingDate;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.imageUrl,
    this.hours = 0.0,
    this.isFeatured = false,
    this.pricePerHour = 5000,
    this.bookingDate,
  });
}

class Venue {
  final String name;
  final String location;
  final String priceRange;
  final int capacity;
  final String imageUrl;
  final double pricePerHour;
  final List<String> services;

  Venue({
    required this.name,
    required this.location,
    required this.priceRange,
    required this.capacity,
    required this.imageUrl,
    required this.pricePerHour,
    required this.services,
  });
}

class Guest {
  final String id;
  String name;
  String status;

  Guest({
    required this.id,
    required this.name,
    required this.status,
  });
}

class Booking {
  final String id;
  final String eventName;
  final DateTime bookingDate;
  final String status;
  final String imageUrl;
  final double price;

  Booking({
    required this.id,
    required this.eventName,
    required this.bookingDate,
    required this.status,
    required this.imageUrl,
    required this.price,
  });
}

class AuthService {
  Future<User> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@example.com' && password == 'password123') {
      return User(uid: 'user-abc', email: email);
    }
    throw Exception('Invalid credentials');
  }

  Future<User> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email.contains('@') && password.length >= 6) {
      return User(uid: 'user-${Random().nextInt(1000)}', email: email);
    }
    throw Exception('Registration failed');
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

class AuthProvider extends ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();

  User? get user => _user;

  Future<void> signIn(String email, String password) async {
    try {
      _user = await _authService.signIn(email, password);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      _user = await _authService.register(email, password);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}

class ChecklistProvider extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Venue Booking',
      imageUrl: 'assets/images/venue.jpg',
      hours: 8,
      pricePerHour: 0,
    ),
    Task(
      id: '2',
      title: 'Photography & Videography',
      imageUrl: 'assets/images/photography.jpg',
      hours: 10,
    ),
    Task(
      id: '3',
      title: 'Catering Service',
      imageUrl: 'assets/images/catering.jpg',
      hours: 6,
    ),
    Task(
      id: '4',
      title: 'Mehendi Artist',
      imageUrl: 'assets/images/mehendi.jpg',
      hours: 4,
    ),
    Task(
      id: '5',
      title: 'Sangeet Choreographer',
      imageUrl: 'assets/images/sangeet.jpg',
      hours: 5,
    ),
    Task(
      id: '6',
      title: 'Honeymoon Booking',
      imageUrl: 'assets/images/honeymoon.jpg',
      hours: 2,
    ),
  ];
  bool isLoading = false;
  String? _selectedTaskId;

  List<Task> get tasks => _tasks;
  String? get selectedTaskId => _selectedTaskId;

  void setSelectedTask(String? taskId) {
    _selectedTaskId = taskId;
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    _tasks.add(Task(
      id: 'task-${Random().nextInt(1000)}',
      title: title,
      imageUrl: 'assets/images/new_task.png',
      pricePerHour: 5000,
    ));
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }
}

class VenueProvider extends ChangeNotifier {
  final List<Venue> _venues = [
    Venue(
      name: 'Grand Ballroom',
      location: 'New York, NY',
      priceRange: '₹₹₹',
      capacity: 500,
      imageUrl: 'assets/images/grand_ballroom.jpg',
      pricePerHour: 15000,
      services: ['Full Catering', 'Decorations', 'Live Music', 'Valet Parking'],
    ),
    Venue(
      name: 'The Lake House',
      location: 'Lake Placid, NY',
      priceRange: '₹₹',
      capacity: 200,
      imageUrl: 'assets/images/the_lake_house.jpg',
      pricePerHour: 10000,
      services: ['On-site Catering', 'Indoor & Outdoor Space', 'Bar Service', 'Bridal Suite'],
    ),
    Venue(
      name: 'City Gardens',
      location: 'San Francisco, CA',
      priceRange: '₹',
      capacity: 100,
      imageUrl: 'assets/images/city_gardens.jpg',
      pricePerHour: 8000,
      services: ['Garden Ceremony', 'Reception Hall', 'Photography Services', 'Setup & Cleanup'],
    ),
    Venue(
      name: 'Rustic Manor',
      location: 'Austin, TX',
      priceRange: '₹₹',
      capacity: 350,
      imageUrl: 'assets/images/rustic_manor.jpg',
      pricePerHour: 12000,
      services: ['Country-style Venue', 'Barn Dance Floor', 'Full-service Bar', 'In-house Florist'],
    ),
    Venue(
      name: 'Mountain View Resort',
      location: 'Aspen, CO',
      priceRange: '₹₹₹₹',
      capacity: 150,
      imageUrl: 'assets/images/mountain_view_resort.jpg',
      pricePerHour: 20000,
      services: ['Luxury Lodging', 'Ski-in/Ski-out', 'Fine Dining', 'Spa & Wellness'],
    ),
  ];

  List<Venue> get allVenues => _venues;

  List<Venue> getFilteredVenues({int minCapacity = 0, int maxCapacity = 1000}) {
    return _venues.where((venue) {
      return venue.capacity >= minCapacity && venue.capacity <= maxCapacity;
    }).toList();
  }
}

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = [];
  bool isLoading = false;

  List<Booking> get bookings => _bookings;

  Future<void> fetchBookings() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    isLoading = false;
    notifyListeners();
  }

  Future<void> addBooking(Booking booking) async {
    _bookings.add(booking);
    notifyListeners();
  }
}

class BudgetProvider extends ChangeNotifier {
  double _totalBudget = 500000;
  List<Guest> _guests = [
    Guest(id: '1', name: 'Rohan Sharma', status: 'Attending'),
    Guest(id: '2', name: 'Priya Verma', status: 'Pending'),
    Guest(id: '3', name: 'Rahul Jain', status: 'Not Attending'),
  ];

  double get totalBudget => _totalBudget;
  List<Guest> get guests => _guests;

  void setTotalBudget(double newBudget) {
    _totalBudget = newBudget;
    notifyListeners();
  }

  void addGuest(String name) {
    _guests.add(Guest(id: DateTime.now().toIso8601String(), name: name, status: 'Pending'));
    notifyListeners();
  }

  void updateGuestStatus(String id, String newStatus) {
    final guest = _guests.firstWhere((g) => g.id == id);
    guest.status = newStatus;
    notifyListeners();
  }

  void removeGuest(String id) {
    _guests.removeWhere((guest) => guest.id == id);
    notifyListeners();
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMeDetails();
  }

  Future<void> _loadRememberMeDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveRememberMeDetails(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      prefs.setBool('rememberMe', true);
      prefs.setString('email', email);
      prefs.setString('password', password);
    } else {
      prefs.clear();
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        if (_isLogin) {
          await authProvider.signIn(_emailController.text, _passwordController.text);
        } else {
          await authProvider.register(_emailController.text, _passwordController.text);
        }
        await _saveRememberMeDetails(_emailController.text, _passwordController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app-logo',
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isLogin ? 'Welcome Back!' : 'Join Us!',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  _isLogin ? 'Log in to your account' : 'Create a new account',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    const Text('Remember me'),
                  ],
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFFF06292))
                    : ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFFF06292),
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                  child: Text(
                    _isLogin ? 'Log In' : 'Sign Up',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'Don\'t have an account? Sign Up'
                        : 'Already have an account? Log In',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    Provider.of<ChecklistProvider>(context, listen: false).fetchTasks();
    Provider.of<BookingProvider>(context, listen: false).fetchBookings();
    _widgetOptions = <Widget>[
      const ChecklistScreen(),
      const VenuesScreen(),
      const BookingsScreen(),
      const BudgetScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wedding Planner'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.sunny,
              color: themeProvider.themeMode == ThemeModeOption.light ? Theme.of(context).primaryColor : Colors.grey,
            ),
            onPressed: () {
              themeProvider.setTheme(ThemeModeOption.light);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.nights_stay,
              color: themeProvider.themeMode == ThemeModeOption.dark ? Theme.of(context).primaryColor : Colors.grey,
            ),
            onPressed: () {
              themeProvider.setTheme(ThemeModeOption.dark);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Checklist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            label: 'Venues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'Budget',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ChecklistProvider>(context, listen: false).fetchTasks();
  }

  void _showAddTaskDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add New Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Provider.of<ChecklistProvider>(context, listen: false).addTask(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showVenueSelection(BuildContext context, Task task) {
    final venueProvider = Provider.of<VenueProvider>(context, listen: false);
    final checklistProvider = Provider.of<ChecklistProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Venue'),
          content: SingleChildScrollView(
            child: ListBody(
              children: venueProvider.allVenues.map((venue) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(venue.imageUrl),
                    ),
                    title: Text(venue.name),
                    subtitle: Text(
                      'Price per hour: ₹${venue.pricePerHour.toStringAsFixed(0)}',
                    ),
                    onTap: () {
                      task.title = 'Venue Booking: ${venue.name}';
                      task.imageUrl = venue.imageUrl;
                      task.pricePerHour = venue.pricePerHour;
                      checklistProvider.updateTask(task);
                      Navigator.of(context).pop();
                      checklistProvider.setSelectedTask(task.id);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, Task task) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      final newBooking = Booking(
        id: 'booking-${Random().nextInt(1000)}',
        eventName: task.title,
        bookingDate: picked,
        status: 'Confirmed',
        imageUrl: task.imageUrl,
        price: task.pricePerHour * task.hours,
      );
      await bookingProvider.addBooking(newBooking);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booked ${task.title} for ${picked.toLocal().toString().split(' ')[0]}'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChecklistProvider>(
        builder: (context, checklist, child) {
          if (checklist.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: checklist.tasks.length,
            itemBuilder: (context, index) {
              final task = checklist.tasks[index];
              final bool isExpanded = checklist.selectedTaskId == task.id;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (task.title.contains('Venue Booking')) {
                            _showVenueSelection(context, task);
                          } else {
                            checklist.setSelectedTask(isExpanded ? null : task.id);
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(task.imageUrl),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.darken,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Checkbox(
                                value: task.isCompleted,
                                onChanged: (bool? newValue) {
                                  task.isCompleted = newValue ?? false;
                                  checklist.updateTask(task);
                                },
                                activeColor: Theme.of(context).colorScheme.secondary,
                                checkColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        firstChild: Container(),
                        secondChild: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Price (per hour):', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                  Text('₹${task.pricePerHour.toStringAsFixed(0)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Slider(
                                value: task.hours,
                                min: 0,
                                max: 24,
                                divisions: 24,
                                label: task.hours.toStringAsFixed(0),
                                onChanged: (double newValue) {
                                  task.hours = newValue;
                                  checklist.updateTask(task);
                                },
                                activeColor: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Total Cost: ₹${(task.pricePerHour * task.hours).toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Feature this Event',
                                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                  ),
                                  Switch(
                                    value: task.isFeatured,
                                    onChanged: (bool newValue) {
                                      task.isFeatured = newValue;
                                      checklist.updateTask(task);
                                    },
                                    activeColor: Theme.of(context).colorScheme.secondary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () => _selectDate(context, task),
                                icon: const Icon(Icons.calendar_today_outlined, color: Colors.white),
                                label: const Text('Select Date', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  minimumSize: const Size.fromHeight(50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class VenuesScreen extends StatelessWidget {
  const VenuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final venueProvider = Provider.of<VenueProvider>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: venueProvider.allVenues.length,
      itemBuilder: (context, index) {
        final venue = venueProvider.allVenues[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VenueDetailScreen(venue: venue),
                ),
              );
            },
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Hero(
                    tag: 'venue-${venue.name}',
                    child: Image.asset(
                      venue.imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venue.name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(venue.location, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('Capacity: ${venue.capacity} guests', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.currency_rupee, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('Price per hour: ₹${venue.pricePerHour.toStringAsFixed(0)}',
                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VenueDetailScreen extends StatelessWidget {
  final Venue venue;

  const VenueDetailScreen({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(venue.name),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'venue-${venue.name}',
              child: Image.asset(
                venue.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(venue.location, style: const TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Venue Details',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary)),
                          const SizedBox(height: 10),
                          _buildDetailRow(
                            context,
                            icon: Icons.attach_money,
                            label: 'Price per hour:',
                            value: '₹${venue.pricePerHour.toStringAsFixed(0)}',
                          ),
                          _buildDetailRow(
                            context,
                            icon: Icons.people_outline,
                            label: 'Capacity:',
                            value: '${venue.capacity} guests',
                          ),
                          _buildDetailRow(
                            context,
                            icon: Icons.credit_card,
                            label: 'Price Range:',
                            value: venue.priceRange,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Services Included',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary)),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: venue.services
                                .map((service) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Icon(Icons.check,
                                      size: 20, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text(service, style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookingProvider>(context, listen: false).fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        if (bookingProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bookingProvider.bookings.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No bookings yet!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Select a date for an event to see it here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookingProvider.bookings.length,
          itemBuilder: (context, index) {
            final booking = bookingProvider.bookings[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(booking.imageUrl),
                  radius: 25,
                ),
                title: Text(
                  booking.eventName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Date: ${booking.bookingDate.toLocal().toString().split(' ')[0]}\n'
                      'Total Price: ₹${booking.price.toStringAsFixed(0)}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.check_circle_outline, color: Colors.green),
              ),
            );
          },
        );
      },
    );
  }
}

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _budgetController = TextEditingController();
  final _guestNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    _budgetController.text = budgetProvider.totalBudget.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _guestNameController.dispose();
    super.dispose();
  }

  void _addGuest() {
    if (_guestNameController.text.isNotEmpty) {
      Provider.of<BudgetProvider>(context, listen: false).addGuest(_guestNameController.text);
      _guestNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Calculator',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<BudgetProvider>(
                builder: (context, budgetProvider, child) {
                  final double venueCost = budgetProvider.totalBudget * 0.40;
                  final double cateringCost = budgetProvider.totalBudget * 0.50;
                  final double decorCost = budgetProvider.totalBudget * 0.10;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Set Your Total Budget', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _budgetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Total Budget (₹)',
                          prefixText: '₹',
                        ),
                        onSubmitted: (value) {
                          final newBudget = double.tryParse(value);
                          if (newBudget != null) {
                            budgetProvider.setTotalBudget(newBudget);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('Budget Breakdown', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      _buildBudgetRow(context, 'Venue', venueCost, 40),
                      _buildBudgetRow(context, 'Catering', cateringCost, 50),
                      _buildBudgetRow(context, 'Decor', decorCost, 10),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Guest List Management',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _guestNameController,
                    decoration: InputDecoration(
                      labelText: 'Add a new guest',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add_circle, color: Color(0xFFF06292)),
                        onPressed: _addGuest,
                      ),
                    ),
                    onSubmitted: (_) => _addGuest(),
                  ),
                  const SizedBox(height: 20),
                  Consumer<BudgetProvider>(
                    builder: (context, budgetProvider, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: budgetProvider.guests.length,
                        itemBuilder: (context, index) {
                          final guest = budgetProvider.guests[index];
                          return ListTile(
                            title: Text(guest.name),
                            subtitle: Text('Status: ${guest.status}'),
                            trailing: DropdownButton<String>(
                              value: guest.status,
                              items: ['Attending', 'Not Attending', 'Pending']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  budgetProvider.updateGuestStatus(guest.id, newValue);
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetRow(BuildContext context, String title, double amount, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title ($percentage%)', style: const TextStyle(fontSize: 16)),
          Text('₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
