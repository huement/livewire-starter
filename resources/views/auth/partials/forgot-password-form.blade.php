@if (session('status'))
    <div class="alert alert-success" role="alert">
        {{ session('status') }}
    </div>
@endif

<div class="mb-4 text-center">
    <p class="text-muted">Forgot your password? No problem. Just let us know your email address and we will email you a password reset link that will allow you to choose a new one.</p>
</div>

<form method="POST" action="{{ route('password.email') }}" class="auth-form">
    @csrf

    <div class="floating-label mb-3">
        <input id="email" type="email" class="form-control @error('email') is-invalid @enderror" name="email" value="{{ old('email') }}" required autocomplete="email" autofocus placeholder="Enter your email address">
        <label for="email">Email Address</label>
        @error('email')
            <span class="invalid-feedback" role="alert">
                <strong>{{ $message }}</strong>
            </span>
        @enderror
    </div>

    <button type="submit" class="btn btn-primary btn-auth-submit">
        Send Reset Link
    </button>
</form>

<div class="auth-footer">
    <p class="text-center">
        Remember your password? 
        <a href="{{ route('login') }}" class="auth-link">Sign in here</a>
    </p>
</div>
