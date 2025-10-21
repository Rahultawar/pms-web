<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacy Management System - Login</title>
    <c:url var="bootstrapCss" value="/assets/css/bootstrap.min.css" />
    <c:url var="fontAwesomeCss" value="/assets/css/fontawesome.min.css" />
    <c:url var="themeCss" value="/assets/css/theme.css" />
    <c:url var="authCss" value="/assets/css/auth.css" />
    <c:url var="interRegular" value="/assets/fonts/inter/Inter-Regular.woff2" />
    <c:url var="faviconUrl" value="/assets/images/favicon.svg" />
    <link rel="icon" href="${faviconUrl}" type="image/svg+xml">
    <link rel="stylesheet" href="${bootstrapCss}">
    <link rel="stylesheet" href="${fontAwesomeCss}">
    <link rel="stylesheet" href="${themeCss}">
    <link rel="preload" href="${interRegular}" as="font" type="font/woff2" crossorigin>
    <link rel="stylesheet" href="${authCss}">
</head>

<body class="auth-page">
    <div class="container-fluid vh-100 d-flex align-items-center justify-content-center p-3 p-md-4">
        <div class="row w-100 g-0 auth-card shadow-lg">
            <!-- Brand Section - Hidden on mobile -->
            <div class="col-lg-5 d-none d-lg-flex auth-brand-section">
                <div class="d-flex flex-column align-items-center justify-content-center text-white p-4 w-100">
                    <i class="fas fa-pills fa-4x mb-4 animate-float"></i>
                    <h2 class="fw-bold mb-3 text-center">Pharmacy Management System</h2>
                    <p class="text-center opacity-90 mb-4">Streamline operations with intelligent inventory tracking</p>
                    <div class="feature-badges d-flex flex-wrap gap-2 justify-content-center">
                        <span class="badge bg-white bg-opacity-25 rounded-pill px-3 py-2">
                            <i class="fas fa-box-open me-1"></i> Smart Inventory
                        </span>
                        <span class="badge bg-white bg-opacity-25 rounded-pill px-3 py-2">
                            <i class="fas fa-chart-line me-1"></i> Real-time Analytics
                        </span>
                        <span class="badge bg-white bg-opacity-25 rounded-pill px-3 py-2">
                            <i class="fas fa-bell me-1"></i> Smart Alerts
                        </span>
                    </div>
                </div>
            </div>

            <!-- Form Section -->
            <div class="col-lg-7 auth-form-section">
                <div class="p-4 p-sm-5">
                    <!-- Mobile Logo -->
                    <div class="text-center mb-4 d-lg-none">
                        <i class="fas fa-pills fa-3x text-primary mb-2"></i>
                        <h5 class="fw-bold">PMS</h5>
                    </div>

                    <div class="form-header">
                        <h3 class="fw-bold mb-2">Welcome Back</h3>
                        <p class="text-muted mb-4">Sign in to manage your pharmacy</p>
                    </div>

                    <% String errorMessage = (String) request.getAttribute("error-message"); 
                       if (errorMessage != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <span><%= errorMessage %></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <% } %>

                    <form action="LoginServlet" method="post" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">Username</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="fas fa-user text-muted"></i>
                                </span>
                                <input type="text" class="form-control border-start-0 ps-0" id="username" 
                                       name="txtUsername" placeholder="Enter username" required autocomplete="username">
                                <div class="invalid-feedback">Please enter your username.</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="fas fa-lock text-muted"></i>
                                </span>
                                <input type="password" class="form-control border-start-0 ps-0" id="password" 
                                       name="txtPassword" placeholder="Enter password" required autocomplete="current-password">
                                <div class="invalid-feedback">Please enter your password.</div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="remember" name="remember">
                                <label class="form-check-label text-muted" for="remember">Remember me</label>
                            </div>
                            <a href="#" class="text-decoration-none small">Forgot Password?</a>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
                            <i class="fas fa-sign-in-alt me-2"></i>Sign In
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-3 border-top">
                        <p class="text-muted mb-2">Don't have an account? 
                            <a href="registration.jsp" class="text-decoration-none fw-semibold">Create Account</a>
                        </p>
                        <p class="text-muted small mb-0">&copy; 2025 Pharmacy Management System. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <c:url var="bootstrapJs" value="/assets/js/bootstrap.bundle.min.js" />
    <script src="${bootstrapJs}"></script>
    <script>
        // Bootstrap form validation
        (function() {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>

</html>