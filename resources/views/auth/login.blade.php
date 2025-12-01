@extends('layouts.auth')

@section('title', 'Login')

@section('content')
<div class="text-center mb-4">
    <h2 class="h3 mb-2">Welcome Back</h2>
    <p class="text-muted">Sign in to your account to continue</p>
</div>

@if (session('status'))
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">check_circle</span>
        {{ session('status') }}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
@endif

<form method="POST" action="{{ route('login') }}">
    @csrf

    <div class="mb-3">
        <label for="email" class="form-label">
            <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">email</span>
            Email Address
        </label>
        <input 
            type="email" 
            class="form-control @error('email') is-invalid @enderror" 
            id="email" 
            name="email" 
            value="{{ old('email') }}" 
            required 
            autocomplete="email" 
            autofocus
            placeholder="Enter your email"
        >
        @error('email')
            <div class="invalid-feedback">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 16px;">error</span>
                {{ $message }}
            </div>
        @enderror
    </div>

    <div class="mb-3">
        <label for="password" class="form-label">
            <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">lock</span>
            Password
        </label>
        <input 
            type="password" 
            class="form-control @error('password') is-invalid @enderror" 
            id="password" 
            name="password" 
            required 
            autocomplete="current-password"
            placeholder="Enter your password"
        >
        @error('password')
            <div class="invalid-feedback">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 16px;">error</span>
                {{ $message }}
            </div>
        @enderror
    </div>

    <div class="mb-3 form-check">
        <input type="checkbox" class="form-check-input" id="remember" name="remember" {{ old('remember') ? 'checked' : '' }}>
        <label class="form-check-label" for="remember">
            Remember me
        </label>
    </div>

    <div class="d-grid mb-3">
        <button type="submit" class="btn btn-primary btn-lg">
            <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">login</span>
            Sign In
        </button>
    </div>

    @if (Route::has('password.request'))
        <div class="text-center">
            <a href="{{ route('password.request') }}" class="text-decoration-none">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">lock_reset</span>
                Forgot your password?
            </a>
        </div>
    @endif
</form>

@if (Route::has('register'))
    <div class="text-center mt-4 pt-4 border-top">
        <p class="mb-0 text-muted">
            Don't have an account?
            <a href="{{ route('register') }}" class="text-decoration-none fw-semibold">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">person_add</span>
                Sign up here
            </a>
        </p>
    </div>
@endif
@endsection
