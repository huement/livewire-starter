@extends('layouts.app')

@section('title', 'Dashboard')

@section('content')
<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">
        <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 32px;">dashboard</span>
        Dashboard
    </h1>
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
        <div class="alert alert-success" role="alert">
            <span class="material-symbols-rounded align-text-bottom me-2" style="font-size: 20px;">check_circle</span>
            <strong>Welcome!</strong> You're logged in successfully.
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-4 mb-4">
        <div class="card">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="flex-shrink-0">
                        <span class="material-symbols-rounded" style="font-size: 48px; color: #0d6efd;">people</span>
                    </div>
                    <div class="flex-grow-1 ms-3">
                        <h5 class="card-title mb-0">Users</h5>
                        <p class="text-muted mb-0">Total: 0</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-4">
        <div class="card">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="flex-shrink-0">
                        <span class="material-symbols-rounded" style="font-size: 48px; color: #198754;">inventory</span>
                    </div>
                    <div class="flex-grow-1 ms-3">
                        <h5 class="card-title mb-0">Orders</h5>
                        <p class="text-muted mb-0">Total: 0</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-4">
        <div class="card">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="flex-shrink-0">
                        <span class="material-symbols-rounded" style="font-size: 48px; color: #dc3545;">shopping_bag</span>
                    </div>
                    <div class="flex-grow-1 ms-3">
                        <h5 class="card-title mb-0">Products</h5>
                        <p class="text-muted mb-0">Total: 0</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
