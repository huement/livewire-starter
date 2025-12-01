@if (session("status"))
    <div class="alert alert-success" role="alert">
        {{ session("status") }}
    </div>
@endif

<!-- Social Login Buttons -->
<x-social-login-buttons :providers="["google", "github" , "facebook" , "twitter" ]" />

<!-- Divider -->
<div class="divider">
    <span class="divider-text">or</span>
</div>

@if (config("app.show_demo_credentials", true))
    <div class="pb-2" id="demo-credentials-alert">
        <div class="alert alert-info alert-dismissible fade show mb-2 d-block p-relative" role="alert">
            <button type="button" class="btn-close btn-close-white"
                onclick="document.getElementById('demo-credentials-alert').style.display='none'"
                aria-label="Close"></button>
            <p class="lead">In this Demo the default user is</p>
            <p class="mb-0">U: <code>test@example.com</code> &nbsp; &nbsp; &nbsp; P: <code>password</code></p>
        </div>
    </div>
@endif

<!-- Email/Password Form -->
<form method="POST" action="{{ route("login") }}" class="auth-form mt-3">
    @csrf

    <div class="floating-label mb-3">
        <input id="email" type="email" class="form-control @error("email") is-invalid @enderror" name="email"
            value="{{ old("email") }}" required autocomplete="email" autofocus placeholder="Enter your email">
        <label for="email">Email Address</label>
        @error("email")
            <span class="invalid-feedback" role="alert">
                <strong>{{ $message }}</strong>
            </span>
        @enderror
    </div>

    <div class="floating-label mb-3">
        <input id="password" type="password" class="form-control @error("password") is-invalid @enderror"
            name="password" required autocomplete="current-password" placeholder="Enter your password">
        <label for="password">Password</label>
        @error("password")
            <span class="invalid-feedback" role="alert">
                <strong>{{ $message }}</strong>
            </span>
        @enderror
    </div>

    <!-- CAPTCHA -->
    <div class="form-group mb-1">
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

    <div class="form-group mb-3">
        <div class="form-check">
            <input class="form-check-input" type="checkbox" name="remember" id="remember"
                {{ old("remember") ? "checked" : "" }}>
            <label class="form-check-label" for="remember">
                Remember me
            </label>
        </div>
    </div>

    <button type="submit" class="btn btn-primary btn-auth-submit">
        Sign In
    </button>

    @if (Route::has("password.request"))
        <div class="text-center mt-3">
            <a class="forgot-password-link" href="{{ route("password.request") }}">
                Forgot your password?
            </a>
        </div>
    @endif
</form>

<div class="auth-footer">
    <p class="text-center">
        Don't have an account?
        <a href="{{ route("register") }}" class="auth-link">Sign up here</a>
    </p>
</div>
