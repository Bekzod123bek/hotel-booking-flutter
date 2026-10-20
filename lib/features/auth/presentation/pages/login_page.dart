import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_image.dart';
import '../cubit/auth_cubit.dart';

final _emailPattern = RegExp(r'^[\w.+\-]+@[\w\-]+\.[\w.\-]{2,}$');

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final auth = context.read<AuthCubit>();
    final email = _email.text.trim();
    if (_register) {
      auth.register(_name.text, email, _password.text);
    } else {
      auth.login(email, _password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = context.select((AuthCubit c) => c.state.busy);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const AppImage(
                    'https://images.unsplash.com/photo-1600011689032-8b628b8a8747?w=900&q=80',
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _register ? 'Create account' : 'Welcome back',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _register
                          ? 'Sign up to save favorites and bookings.'
                          : 'Sign in to continue planning your trip.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('Sign in')),
                        ButtonSegment(value: true, label: Text('Sign up')),
                      ],
                      selected: {_register},
                      onSelectionChanged: (s) =>
                          setState(() => _register = s.first),
                    ),
                    const SizedBox(height: 20),
                    if (_register) ...[
                      TextFormField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => (v == null || v.trim().length < 2)
                            ? 'Enter your name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                    ],
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      validator: (v) => _emailPattern.hasMatch(v?.trim() ?? '')
                          ? null
                          : 'Enter a valid email',
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _obscure ? 'Show password' : 'Hide password',
                          icon: Icon(_obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'At least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: busy ? null : _submit,
                      child: busy
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : Text(_register ? 'Create account' : 'Sign in'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Demo app: no data leaves your device.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
