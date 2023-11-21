import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Eventos
abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;

  SignUpEvent({required this.email, required this.password});
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

// Estados
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState({required this.error});
}

class AuthSignedInState extends AuthState {}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignUpEvent) {
      yield AuthLoadingState();

      // Aquí deberías implementar la lógica de registro
      // Puedes usar Firebase, API REST, etc.

      // Simulamos un retraso para mostrar el estado de carga
      await Future.delayed(Duration(seconds: 2));

      // Si el registro es exitoso, cambiamos al estado de autenticado
      yield AuthSignedInState();
    } else if (event is SignInEvent) {
      yield AuthLoadingState();

      // Aquí deberías implementar la lógica de inicio de sesión
      // Puedes usar Firebase, API REST, etc.

      // Simulamos un retraso para mostrar el estado de carga
      await Future.delayed(Duration(seconds: 2));

      // Si el inicio de sesión es exitoso, cambiamos al estado de autenticado
      yield AuthSignedInState();
    }
  }
}

// Pantalla de Registro

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          // Manejar el error de autenticación
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthSignedInState) {
          // Navegar a la pantalla principal después del registro exitoso
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Disparar el evento de registro
                  BlocProvider.of<AuthBloc>(context).add(
                    SignUpEvent(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                  );
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Pantalla de Inicio de Sesión
class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: SignInForm(),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          // Manejar el error de autenticación
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthSignedInState) {
          // Navegar a la pantalla principal después del inicio de sesión exitoso
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Disparar el evento de inicio de sesión
                  BlocProvider.of<AuthBloc>(context).add(
                    SignInEvent(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                  );
                },
                child: Text('Iniciar Sesión'),
              ),
            ],
          ),
        );
      },
    );
  }
}
