@extends('layouts.auth')

@section('title', 'Verify Email')

@section('content')
<div class="text-center mb-4">
    <span class="material-symbols-rounded mb-3" style="font-size: 64px; color: #0d6efd;">mail</span>
    <h2 class="h3 mb-2">Verify Your Email Address</h2>
</div>

@if (session('status') == 'verification-link-sent')
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">check_circle</span>
        A new verification link has been sent to the email address you provided during registration.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
@endif

<div class="alert alert-info" role="alert">
    <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">info</span>
    Thanks for signing up! Before getting started, could you verify your email address by clicking on the link we just emailed to you? If you didn't receive the email, we will gladly send you another.
</div>

<form method="POST" action="{{ route('verification.send') }}" class="d-inline">
    @csrf
    <div class="d-grid">
        <button type="submit" class="btn btn-outline-primary">
            <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">send</span>
            Resend Verification Email
        </button>
    </div>
</form>

<form method="POST" action="{{ route('logout') }}" class="d-inline mt-3">
    @csrf
    <div class="d-grid">
        <button type="submit" class="btn btn-link text-decoration-none">
            <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">logout</span>
            Log Out
        </button>
    </div>
</form>
@endsection
