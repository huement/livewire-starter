@extends('layouts.auth')

@section('title', 'Confirm Password')

@section('content')
<div class="text-center mb-4">
    <h2 class="h3 mb-2">Confirm Password</h2>
    <p class="text-muted">This is a secure area of the application. Please confirm your password before continuing.</p>
</div>

<form method="POST" action="{{ route('password.confirm') }}">
    @csrf

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
            autofocus
            placeholder="Enter your password"
        >
        @error('password')
            <div class="invalid-feedback">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 16px;">error</span>
                {{ $message }}
            </div>
        @enderror
    </div>

    <div class="d-grid mb-3">
        <button type="submit" class="btn btn-primary btn-lg">
            <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">verified</span>
            Confirm
        </button>
    </div>
</form>

@if (Route::has('login'))
    <div class="text-center mt-4 pt-4 border-top">
        <a href="{{ route('login') }}" class="text-decoration-none">
            <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">arrow_back</span>
            Back to login
        </a>
    </div>
@endif
@endsection
