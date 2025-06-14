import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'custom_code/sqlite_helper.dart';

import 'pages/home_page/home_page_widget.dart';
import 'pages/list/list_widget.dart';
import 'pages/dashboard/dashboard_widget.dart';
import 'pages/form/form_widget.dart';

class AppStateNotifier extends ChangeNotifier {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppStateNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // --- INICIO DE LA CORRECCIÓN ---
  // El GoRouter ahora usa una "ShellRoute" para la barra de navegación.
  // Esto asegura que la barra de navegación se mantenga visible en las
  // páginas principales (Home, Lista, Dashboard).
  static final _router = GoRouter(
    initialLocation: '/homePage', // La ruta inicial ahora es la del Home
    routes: [
      // ShellRoute actúa como el contenedor con la barra de navegación
      ShellRoute(
        builder: (context, state, child) {
          return NavBarPage(child: child); // NavBarPage ahora envuelve a las otras páginas
        },
        routes: [
          // Estas son las rutas que aparecerán DENTRO del NavBarPage
          GoRoute(
            name: 'HomePage',
            path: '/homePage',
            builder: (context, state) => const HomePageWidget(),
          ),
          GoRoute(
            name: 'List',
            path: '/list',
            builder: (context, state) => const ListWidget(),
          ),
          GoRoute(
            name: 'Dashboard',
            path: '/dashboard',
            builder: (context, state) => const DashboardWidget(),
          ),
        ],
      ),
      // Esta es una ruta de nivel superior que NO tendrá la barra de navegación,
      // lo cual es perfecto para el formulario de pantalla completa.
      GoRoute(
        name: 'Form',
        path: '/form',
        builder: (context, state) {
          final tamizaje = state.extra as Tamizaje?;
          return FormWidget(tamizajeForEdit: tamizaje);
        },
      ),
    ],
  );
  // --- FIN DE LA CORRECCIÓN ---

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tamizajes App',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es')],
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true, colorSchemeSeed: Colors.teal),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true, colorSchemeSeed: Colors.teal),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

// --- NavBarPage AHORA ES UN CONTENEDOR MÁS INTELIGENTE ---
class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key, required this.child});

  final Widget child; // El widget de la página actual (Home, Lista, o Dashboard)

  @override
  Widget build(BuildContext context) {
    // --- INICIO DE LA CORRECCIÓN ---
    // Se obtiene el estado actual del router para saber la ubicación.
    final GoRouterState state = GoRouterState.of(context);
    final String location = state.uri.toString();
    // --- FIN DE LA CORRECCIÓN ---

    int currentIndex = 0;
    if (location.startsWith('/list')) {
      currentIndex = 1;
    } else if (location.startsWith('/dashboard')) {
      currentIndex = 2;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/homePage');
              break;
            case 1:
              context.go('/list');
              break;
            case 2:
              context.go('/dashboard');
              break;
          }
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), activeIcon: Icon(Icons.list_alt), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Dashboard'),
        ],
      ),
    );
  }
}