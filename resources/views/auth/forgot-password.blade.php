@extends('layouts.auth')

@section('title', 'Forgot Password')

@section('content')
<div class="text-center mb-4">
    <h2 class="h3 mb-2">Forgot Password</h2>
    <p class="text-muted">No problem. Just let us know your email address and we will email you a password reset link.</p>
</div>

@if (session('status'))
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">check_circle</span>
        {{ session('status') }}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
@endif

<form method="POST" action="{{ route('password.email') }}">
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
            placeholder="Enter your email address"
        >
        @error('email')
            <div class="invalid-feedback">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 16px;">error</span>
                {{ $message }}
            </div>
        @enderror
    </div>

    <div class="d-grid mb-3">
        <button type="submit" class="btn btn-primary btn-lg">
            <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">lock_reset</span>
            Send Reset Link
        </button>
    </div>
</form>

@if (Route::has('login'))
    <div class="text-center mt-4 pt-4 border-top">
        <p class="mb-0 text-muted">
            Remember your password?
            <a href="{{ route('login') }}" class="text-decoration-none fw-semibold">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">login</span>
                Sign in here
            </a>
        </p>
    </div>
@endif
@endsection
