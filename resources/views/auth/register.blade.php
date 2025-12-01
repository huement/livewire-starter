@extends('layouts.auth')

@section('title', 'Register')

@section('content')
<div class="text-center mb-4">
    <h2 class="h3 mb-2">Create Account</h2>
    <p class="text-muted">Join us today and get started</p>
</div>

<form method="POST" action="{{ route('register') }}">
    @csrf

    <div class="mb-3">
        <label for="name" class="form-label">
            <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">person</span>
            Full Name
        </label>
        <input 
            type="text" 
            class="form-control @error('name') is-invalid @enderror" 
            id="name" 
            name="name" 
            value="{{ old('name') }}" 
            required 
            autocomplete="name" 
            autofocus
            placeholder="Enter your full name"
        >
        @error('name')
            <div class="invalid-feedback">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 16px;">error</span>
                {{ $message }}
            </div>
        @enderror
    </div>

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
            autocomplete="new-password"
            placeholder="Create a password"
        >
        @error('password')
            <div class="invalid-feedback">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 16px;">error</span>
                {{ $message }}
            </div>
        @enderror
    </div>

    <div class="mb-3">
        <label for="password-confirm" class="form-label">
            <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">lock</span>
            Confirm Password
        </label>
        <input 
            type="password" 
            class="form-control" 
            id="password-confirm" 
            name="password_confirmation" 
            required 
            autocomplete="new-password"
            placeholder="Confirm your password"
        >
    </div>

    <div class="d-grid mb-3">
        <button type="submit" class="btn btn-primary btn-lg">
            <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">person_add</span>
            Create Account
        </button>
    </div>
</form>

@if (Route::has('login'))
    <div class="text-center mt-4 pt-4 border-top">
        <p class="mb-0 text-muted">
            Already have an account?
            <a href="{{ route('login') }}" class="text-decoration-none fw-semibold">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">login</span>
                Sign in here
            </a>
        </p>
    </div>
@endif
@endsection
