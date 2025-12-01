@extends('layouts.app')

@section('title', 'Welcome')

@section('content')
<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">Welcome to {{ config('app.name', 'Laravel') }}</h1>
    <div class="btn-toolbar mb-2 mb-md-0">
        <div class="btn-group me-2">
            <button type="button" class="btn btn-sm btn-outline-secondary">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">share</span>
                Share
            </button>
            <button type="button" class="btn btn-sm btn-outline-secondary">
                <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">download</span>
                Export
            </button>
        </div>
        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle">
            <span class="material-symbols-rounded align-text-bottom me-1" style="font-size: 18px;">schedule</span>
            This week
        </button>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">
                    <span class="material-symbols-rounded align-text-bottom me-2">check_circle</span>
                    Bootstrap 5 & Material Icons Setup
                </h5>
            </div>
            <div class="card-body">
                <p class="card-text">This page demonstrates that Bootstrap 5 and Material Icons are properly configured and working.</p>
                
                <h6 class="mt-4 mb-3">Bootstrap Components:</h6>
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <button type="button" class="btn btn-primary w-100">
                            <span class="material-symbols-rounded align-text-bottom me-1">favorite</span>
                            Primary Button
                        </button>
                    </div>
                    <div class="col-md-4">
                        <button type="button" class="btn btn-success w-100">
                            <span class="material-symbols-rounded align-text-bottom me-1">check</span>
                            Success Button
                        </button>
                    </div>
                    <div class="col-md-4">
                        <button type="button" class="btn btn-danger w-100">
                            <span class="material-symbols-rounded align-text-bottom me-1">delete</span>
                            Danger Button
                        </button>
                    </div>
                </div>

                <h6 class="mt-4 mb-3">Material Icons Examples:</h6>
                <div class="d-flex flex-wrap gap-3 mb-4">
                    <span class="badge bg-primary">
                        <span class="material-symbols-rounded align-text-bottom me-1">star</span>
                        Star
                    </span>
                    <span class="badge bg-secondary">
                        <span class="material-symbols-rounded align-text-bottom me-1">favorite</span>
                        Favorite
                    </span>
                    <span class="badge bg-success">
                        <span class="material-symbols-rounded align-text-bottom me-1">thumb_up</span>
                        Thumb Up
                    </span>
                    <span class="badge bg-danger">
                        <span class="material-symbols-rounded align-text-bottom me-1">thumb_down</span>
                        Thumb Down
                    </span>
                    <span class="badge bg-warning text-dark">
                        <span class="material-symbols-rounded align-text-bottom me-1">warning</span>
                        Warning
                    </span>
                    <span class="badge bg-info text-dark">
                        <span class="material-symbols-rounded align-text-bottom me-1">info</span>
                        Info
                    </span>
                </div>

                <h6 class="mt-4 mb-3">Bootstrap Cards with Icons:</h6>
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body text-center">
                                <span class="material-symbols-rounded" style="font-size: 48px; color: #0d6efd;">code</span>
                                <h5 class="card-title mt-3">Code</h5>
                                <p class="card-text">Material Icons are working!</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body text-center">
                                <span class="material-symbols-rounded" style="font-size: 48px; color: #198754;">palette</span>
                                <h5 class="card-title mt-3">Design</h5>
                                <p class="card-text">Bootstrap styling is active!</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body text-center">
                                <span class="material-symbols-rounded" style="font-size: 48px; color: #dc3545;">rocket_launch</span>
                                <h5 class="card-title mt-3">Launch</h5>
                                <p class="card-text">Everything is ready!</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">
                    <span class="material-symbols-rounded align-text-bottom me-2">code</span>
                    Syntax Highlighting with Prism.js
                </h5>
            </div>
            <div class="card-body">
                <p class="card-text">Below is an example of syntax highlighting using Prism.js with the hui-prism theme.</p>
                
                <h6 class="mt-4 mb-3">JavaScript Example:</h6>
                <pre><code class="language-javascript">// Example JavaScript code
function greet(name) {
    return `Hello, ${name}!`;
}

const user = 'World';
console.log(greet(user));

// Arrow function example
const add = (a, b) => a + b;
console.log(add(2, 3));</code></pre>

                <h6 class="mt-4 mb-3">PHP Example:</h6>
                <pre><code class="language-php">&lt;?php
// Example PHP code
class WelcomeController {
    public function index() {
        $message = 'Hello, World!';
        return view('welcome', compact('message'));
    }
}

// Function example
function calculateSum($a, $b) {
    return $a + $b;
}

echo calculateSum(5, 10);</code></pre>

                <h6 class="mt-4 mb-3">HTML Example:</h6>
                <pre><code class="language-html">&lt;!DOCTYPE html&gt;
&lt;html lang="en"&gt;
&lt;head&gt;
    &lt;meta charset="UTF-8"&gt;
    &lt;title&gt;Example&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
    &lt;h1&gt;Hello, World!&lt;/h1&gt;
    &lt;p&gt;This is a paragraph.&lt;/p&gt;
&lt;/body&gt;
&lt;/html&gt;</code></pre>

                <h6 class="mt-4 mb-3">CSS Example:</h6>
                <pre><code class="language-css">/* Example CSS code */
.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.button {
    background-color: #007bff;
    color: white;
    padding: 10px 20px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
}

.button:hover {
    background-color: #0056b3;
}</code></pre>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="alert alert-success" role="alert">
            <span class="material-symbols-rounded align-text-bottom me-2">check_circle</span>
            <strong>Success!</strong> Bootstrap 5, Material Icons, and Prism.js are all working correctly.
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    // Initialize Prism.js after page load
    document.addEventListener('DOMContentLoaded', function() {
        if (typeof Prism !== 'undefined') {
            Prism.highlightAll();
        }
    });
</script>
@endpush
