<!-- Social Login Buttons -->
<x-social-login-buttons :providers="["google", "github" , "facebook" , "twitter" ]" />

<!-- Divider -->
<div class="divider">
    <span class="divider-text">or</span>
</div>

<!-- Registration Form -->
<form method="POST" action="{{ route("register") }}" class="auth-form">
    @csrf

    <div class="floating-label mb-3">
        <input id="name" type="text" class="form-control @error("name") is-invalid @enderror" name="name"
            value="{{ old("name") }}" required autocomplete="name" autofocus placeholder="Enter your full name">
        <label for="name">Full Name</label>
        @error("name")
            <span class="invalid-feedback" role="alert">
                <strong>{{ $message }}</strong>
            </span>
        @enderror
    </div>

    <div class="floating-label mb-3">
        <input id="email" type="email" class="form-control @error("email") is-invalid @enderror" name="email"
            value="{{ old("email") }}" required autocomplete="email" placeholder="Enter your email">
        <label for="email">Email Address</label>
        @error("email")
            <span class="invalid-feedback" role="alert">
                <strong>{{ $message }}</strong>
            </span>
        @enderror
    </div>

    <div class="floating-label mb-3">
        <input id="password" type="password" class="form-control @error("password") is-invalid @enderror"
            name="password" required autocomplete="new-password" placeholder="Create a password">
        <label for="password">Password</label>
        @error("password")
            <span class="invalid-feedback" role="alert">
                <strong>{{ $message }}</strong>
            </span>
        @enderror
    </div>

    <div class="floating-label mb-3">
        <input id="password-confirm" type="password" class="form-control" name="password_confirmation" required
            placeholder="Confirm your password">
        <label for="password-confirm">Confirm Password</label>
    </div>

    <!-- CAPTCHA -->
    <div class="form-group mb-3">
        <label class="form-label">Security Check</label>
        <div class="captcha-container">
            <svg class="captcha-mockup" viewBox="0 0 304 78">
                <rect width="304" height="78" fill="#f8f9fa" stroke="#dee2e6" stroke-width="1" />
                <text x="152" y="25" text-anchor="middle" font-family="Arial, sans-serif" font-size="12"
                    fill="#6c757d">insert</text>
                <text x="152" y="40" text-anchor="middle" font-family="Arial, sans-serif" font-size="12"
                    fill="#6c757d">captcha</text>
                <text x="152" y="55" text-anchor="middle" font-family="Arial, sans-serif" font-size="12"
                    fill="#6c757d">here</text>
            </svg>
        </div>
    </div>

    <button type="submit" class="btn btn-primary btn-auth-submit">
        Create Account
    </button>
</form>

<div class="auth-footer">
    <p class="text-center">
        Already have an account?
        <a href="{{ route("login") }}" class="auth-link">Sign in here</a>
    </p>
</div>
