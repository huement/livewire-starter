<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" data-bs-theme="auto">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', config('app.name', 'Laravel'))</title>

    <!-- Favicons -->
    <link rel="icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">
    <link rel="icon" type="image/png" sizes="16x16" href="{{ asset('favicon-16x16.png') }}">
    <link rel="icon" type="image/png" sizes="32x32" href="{{ asset('favicon-32x32.png') }}">
    <link rel="apple-touch-icon" sizes="180x180" href="{{ asset('apple-touch-icon.png') }}">
    <link rel="icon" type="image/png" sizes="192x192" href="{{ asset('android-chrome-192x192.png') }}">
    <link rel="icon" type="image/png" sizes="512x512" href="{{ asset('android-chrome-512x512.png') }}">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    
    <!-- Prism CSS -->
    <link rel="stylesheet" href="{{ asset('css/hui-prism.css') }}">
    
    @vite(["resources/sass/dashboard.scss"])

    @livewireStyles

    @stack('styles')
</head>
<body>
    <header class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3 fs-6" href="{{ url('/') }}">
            {{ config('app.name', 'Laravel') }}
        </a>
        <button class="navbar-toggler position-absolute d-md-none collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <input class="form-control form-control-dark w-100 rounded-0 border-0" type="text" placeholder="Search" aria-label="Search">
        <div class="navbar-nav">
            @auth
                <div class="nav-item text-nowrap dropdown">
                    <a class="nav-link px-3 dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">account_circle</span>
                        {{ Auth::user()->name }}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="{{ route('profile.edit') }}">
                            <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 18px;">person</span>
                            Profile
                        </a></li>
                        <li><a class="dropdown-item" href="#">
                            <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 18px;">settings</span>
                            Settings
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <form method="POST" action="{{ route('logout') }}" class="d-inline">
                                @csrf
                                <button type="submit" class="dropdown-item">
                                    <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 18px;">logout</span>
                                    Sign out
                                </button>
                            </form>
                        </li>
                    </ul>
                </div>
            @else
                <div class="nav-item text-nowrap d-flex">
                    @if (Route::has('login'))
                        <a class="nav-link px-3" href="{{ route('login') }}">
                            <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">login</span>
                            Log in
                        </a>
                    @endif
                    @if (Route::has('register'))
                        <a class="nav-link px-3" href="{{ route('register') }}">
                            <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">person_add</span>
                            Register
                        </a>
                    @endif
                </div>
            @endauth
        </div>
    </header>

    <div class="container-fluid">
        <div class="row">
            @include('layouts.navigation.sidebar')

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                @yield('content')
            </main>
        </div>
    </div>

     <!-- start viewport debugger -->
     @if (env("DEBUG_BOOTSTRAP_ENABLED", false))
        <div class="mediaq xs-debug sm-debug md-debug lg-debug xl-debug xxl-debug" id="viewport-debugger"
            title="Click to remove"></div>
    @endif
    <!-- end viewport debugger -->

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
    <!-- Prism.js -->
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.30.0/components/prism-core.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.30.0/plugins/autoloader/prism-autoloader.min.js"></script>
    
    @stack('scripts')
</body>
</html>
