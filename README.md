<p align="center">
  <a href="https://huement.com" target="_blank">
    <img src="huement-logo.png" width="200" alt="Huement Logo">
  </a>
</p>

<h1 align="center">Livewire Starter</h1>

<p align="center">
  A modern Laravel application starter kit with Livewire 3, Bootstrap 5, and Material Icons
</p>

<p align="center">
  <a href="https://laravel.com"><img src="https://img.shields.io/badge/Laravel-11.x-FF2D20?style=flat-square&logo=laravel" alt="Laravel"></a>
  <a href="https://livewire.laravel.com"><img src="https://img.shields.io/badge/Livewire-3.x-FB70A9?style=flat-square" alt="Livewire"></a>
  <a href="https://getbootstrap.com"><img src="https://img.shields.io/badge/Bootstrap-5.3-7952B3?style=flat-square&logo=bootstrap" alt="Bootstrap"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="License"></a>
</p>

---

## About

This is a **Laravel 11** starter application featuring **Livewire 3**, **Bootstrap 5**, and **Material Icons**. It provides a solid foundation for building modern, interactive web applications with minimal setup.

### Built With

- **[Laravel 11](https://laravel.com)** - The PHP framework for web artisans
- **[Livewire 3](https://livewire.laravel.com)** - Full-stack framework for Laravel
- **[Bootstrap 5.3](https://getbootstrap.com)** - Powerful, extensible frontend toolkit
- **[Material Icons](https://fonts.google.com/icons)** - Beautiful, consistent iconography
- **[Laravel Breeze](https://laravel.com/docs/breeze)** - Authentication scaffolding
- **[Pest](https://pestphp.com)** - Testing framework with a focus on simplicity

### Features

- ✅ Pre-configured authentication (login, register, password reset)
- ✅ Bootstrap 5 dashboard layout with sidebar navigation
- ✅ Material Icons integration
- ✅ Prism.js syntax highlighting
- ✅ Vite for modern asset bundling
- ✅ Docker support via Laravel Sail
- ✅ Comprehensive setup and run scripts
- ✅ Test suite with Pest

---

## Quick Start

### Prerequisites

- **PHP 8.2+** (or Docker for Sail)
- **Composer**
- **Node.js 18+** and **npm**
- **Docker** (optional, for Laravel Sail)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd livewire-starter
   ```

2. **Run the setup script**
   ```bash
   ./setup.sh
   ```
   
   The setup script will:
   - Check system requirements
   - Install Composer dependencies
   - Install NPM dependencies
   - Set up environment configuration
   - Generate application key
   - Run database migrations
   - Seed the database with a test user
   - Build frontend assets

3. **Choose your development environment**
   - **Option 1:** Direct PHP (requires local PHP installation)
   - **Option 2:** Laravel Sail (uses Docker, no local PHP needed)

---

## Running the Application

### Option 1: Direct PHP

If you have PHP 8.2+ installed locally:

```bash
./RUN.sh
```

This will start the Laravel development server at `http://localhost:8008`.

**Important:** You must also run Vite for asset compilation:
```bash
npm run dev
```

Or build for production:
```bash
npm run build
```

### Option 2: Laravel Sail (Docker)

If you prefer using Docker:

```bash
./run-sail.sh
```

This will start all Docker containers. The application will be available at `http://localhost`.

**Important:** You must also run Vite inside the Sail container:
```bash
./vendor/bin/sail npm run dev
```

---

## Default Credentials

After running the setup script, you can log in with:

- **Email:** `test@example.com`
- **Password:** `password`

---

## Development

### Running Tests

```bash
php artisan test
```

Or with Sail:
```bash
./vendor/bin/sail artisan test
```

### Code Formatting

This project uses Laravel Pint for code formatting:

```bash
vendor/bin/pint
```

### Database Migrations

```bash
php artisan migrate
```

Or with Sail:
```bash
./vendor/bin/sail artisan migrate
```

### Seeding the Database

```bash
php artisan db:seed
```

Or with Sail:
```bash
./vendor/bin/sail artisan db:seed
```

---

## Project Structure

```
livewire-starter/
├── app/                    # Application core
│   ├── Http/              # Controllers, middleware, requests
│   ├── Livewire/          # Livewire components
│   └── Models/            # Eloquent models
├── resources/
│   ├── views/             # Blade templates
│   │   ├── auth/         # Authentication views
│   │   ├── layouts/      # Layout templates
│   │   └── livewire/     # Livewire component views
│   ├── js/                # JavaScript files
│   └── sass/              # SCSS stylesheets
├── routes/                 # Route definitions
├── tests/                  # Test files
├── public/                 # Public assets
└── setup.sh               # Setup script
```

---

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects.

### Key Features

- [Simple, fast routing engine](https://laravel.com/docs/routing)
- [Powerful dependency injection container](https://laravel.com/docs/container)
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage
- [Expressive, intuitive database ORM](https://laravel.com/docs/eloquent)
- Database agnostic [schema migrations](https://laravel.com/docs/migrations)
- [Robust background job processing](https://laravel.com/docs/queues)
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting)

---

## Learning Resources

- **[Laravel Documentation](https://laravel.com/docs)** - Comprehensive framework documentation
- **[Livewire Documentation](https://livewire.laravel.com/docs)** - Learn Livewire 3
- **[Laravel Bootcamp](https://bootcamp.laravel.com)** - Guided tutorial for building a Laravel app
- **[Laracasts](https://laracasts.com)** - Video tutorials on Laravel and modern PHP

---

## Contributing

Thank you for considering contributing to this project! Please feel free to submit issues, fork the repository, and create pull requests.

---

## License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

---

## Credits

<p align="center">
  <strong>Created and sponsored by</strong>
</p>

<p align="center">
  <a href="https://www.templatemonster.com/admin-templates/ultraviolet-pro-bootstrap-5-static-html-admin-dashboard-template-with-hud-dark-mode-amp-rtl-551768.html" target="_blank">
    <img src="uv-promo.gif" width="150" alt="Huement">
  </a>
</p>

<p align="center">
  Check out <a href="https://www.templatemonster.com/admin-templates/ultraviolet-pro-bootstrap-5-static-html-admin-dashboard-template-with-hud-dark-mode-amp-rtl-551768.html" target="_blank">UltraViolet</a> for a premium Livewire template a bunch of templates!
</p>

<p align="center">
  <a href="https://huement.com" target="_blank">Huement.com</a> | 
  <a href="https://huement.com/blog" target="_blank">Blog</a>
</p>

<p align="center">
  Check out <a href="https://huement.com/blog" target="_blank">huement.com/blog</a> for cool articles, tutorials, and insights about Laravel, Livewire, and modern web development!
</p>

---

<p align="center">
  Made with ❤️ by the team at <a href="https://huement.com" target="_blank">Huement</a>
</p>
