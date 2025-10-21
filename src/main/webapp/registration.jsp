<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Pharmacy Management System</title>
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
    <c:url var="noAnimationsUrl" value="/assets/css/no-animations.css"/>
    <link rel="stylesheet" href="${noAnimationsUrl}"/>
</head>

<body class="auth-page">
    <div class="container-fluid vh-100 d-flex align-items-center justify-content-center p-3 p-md-4">
        <div class="row w-100 g-0 auth-card shadow-lg">
            <!-- Brand Section - Hidden on mobile -->
            <div class="col-lg-5 d-none d-lg-flex auth-brand-section">
                <div class="d-flex flex-column align-items-center justify-content-center text-white p-4 w-100">
                    <i class="fas fa-user-plus fa-4x mb-4 animate-float"></i>
                    <h2 class="fw-bold mb-3 text-center">Pharmacy Management System</h2>
                    <p class="text-center opacity-90 mb-4">Set up your digital pharmacy workspace</p>
                    <div class="feature-badges d-flex flex-wrap gap-2 justify-content-center">
                        <span class="badge bg-white bg-opacity-25 rounded-pill px-3 py-2">
                            <i class="fas fa-shield-alt me-1"></i> Secure Access
                        </span>
                        <span class="badge bg-white bg-opacity-25 rounded-pill px-3 py-2">
                            <i class="fas fa-dolly me-1"></i> Easy Onboarding
                        </span>
                        <span class="badge bg-white bg-opacity-25 rounded-pill px-3 py-2">
                            <i class="fas fa-chart-pie me-1"></i> Real-time KPIs
                        </span>
                    </div>
                </div>
            </div>

            <!-- Form Section -->
            <div class="col-lg-7 auth-form-section">
                <div class="p-4 p-sm-5">
                    <!-- Mobile Logo -->
                    <div class="text-center mb-4 d-lg-none">
                        <i class="fas fa-user-plus fa-3x text-primary mb-2"></i>
                        <h5 class="fw-bold">Create Account</h5>
                    </div>

                    <div class="form-header">
                        <h3 class="fw-bold mb-2">Register Your Store</h3>
                        <p class="text-muted mb-4">Complete the form to access admin console</p>
                        
                        <!-- Display error or success messages -->
                        <c:if test="${not empty requestScope['error-message']}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${requestScope['error-message']}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty requestScope['success-message']}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${requestScope['success-message']}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                    </div>

                    <form action="RegistrationServlet" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="medicalStoreName" 
                                   name="medicalStoreName" placeholder="Enter store name" required autocomplete="organization">
                            <label for="medicalStoreName">Medical Store Name</label>
                            <div class="invalid-feedback">Please enter your store name.</div>
                        </div>

                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="userName" 
                                   name="userName" placeholder="Choose username" required autocomplete="username">
                            <label for="userName">Username</label>
                            <div class="invalid-feedback">Please choose a username.</div>
                        </div>

                        <div class="form-floating mb-3">
                            <input type="password" class="form-control" id="password" 
                                   name="password" placeholder="Create password" required autocomplete="new-password"
                                   minlength="8">
                            <label for="password">Password</label>
                            <div class="invalid-feedback">Password must be at least 8 characters.</div>
                            <small class="text-muted">Use 8+ characters with letters, numbers, and symbols.</small>
                        </div>

                        <div class="form-floating mb-3">
                            <input type="password" class="form-control" id="confirmPassword" 
                                   name="confirmPassword" placeholder="Confirm password" required autocomplete="new-password">
                            <label for="confirmPassword">Confirm Password</label>
                            <div class="invalid-feedback">Passwords must match.</div>
                        </div>

                        <div class="mb-3">
                            <label for="medicalStoreLogo" class="form-label fw-semibold">Store Logo (Optional)</label>
                            <input type="file" class="form-control" id="medicalStoreLogo" 
                                   name="medicalStoreLogo" accept="image/png, image/jpeg, image/svg+xml">
                            <small class="text-muted">Square logo (PNG/JPG/SVG, max 2MB)</small>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="agreeTerms" required>
                            <label class="form-check-label text-muted" for="agreeTerms">
                                I agree to the terms & privacy policy
                            </label>
                            <div class="invalid-feedback">You must agree to continue.</div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
                            <i class="fas fa-user-plus me-2"></i>Create Account
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-3 border-top">
                        <p class="text-muted mb-2">Already registered? 
                            <a href="index.jsp" class="text-decoration-none fw-semibold">Sign in here</a>
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
                    
                    // Check if passwords match
                    const password = document.getElementById('password');
                    const confirmPassword = document.getElementById('confirmPassword');
                    if (password.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity('Passwords must match');
                        event.preventDefault();
                        event.stopPropagation();
                    } else {
                        confirmPassword.setCustomValidity('');
                    }
                    
                    form.classList.add('was-validated');
                }, false);
                
                // Real-time password match validation
                const confirmPassword = document.getElementById('confirmPassword');
                confirmPassword.addEventListener('input', function() {
                    const password = document.getElementById('password');
                    if (this.value !== password.value) {
                        this.setCustomValidity('Passwords must match');
                    } else {
                        this.setCustomValidity('');
                    }
                });
            });
        })();
    </script>
</body>

</html>
