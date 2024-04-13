//import 'package:supabase/supabase.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String SPLASH_SCREEN = 'SPLASH_SCREEN';
const String SIGNIN_SCREEN = 'SIGNIN_SCREEN';
const String SIGNUP_SCREEN = 'SIGNUP_SCREEN';
const String PASSWORDRECOVER_SCREEN = 'PASSWORDRECOVER_SCREEN';

const PERSIST_SESSION_KEY = 'PERSIST_SESSION_KEY';

const OAUTH_REDIRECT_URI = 'io.supabase.demoapp://login-callback';

/// TODO: Add your Supabase URL / ANNON KEY here
const SUPABASE_URL = 'https://omnsmejhyygqryvvombg.supabase.co';
const SUPABASE_ANNON_KEY =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9tbnNtZWpoeXlncXJ5dnZvbWJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE0MjA1NjAsImV4cCI6MjAyNjk5NjU2MH0.6w-bkZCh7GGFzYZloQLnqeJneQc-kfr7WbauZgijQBc';
final supabaseClient = SupabaseClient(SUPABASE_URL, SUPABASE_ANNON_KEY);
final supabase = Supabase.instance.client;

const kPrimaryColor = Color(0xFF0C9869);
const kTextColor = Color(0xFF3C4046);
const kbackgroundColor = Color(0xFFF9F8FD);
const kDefaultPadding = 20.0;
