<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacy Management System - Login</title>
    <c:url var="bootstrapCss" value="/assets/css/bootstrap.min.css"/>
    <c:url var="fontAwesomeCss" value="/assets/css/fontawesome.min.css"/>
    <c:url var="themeCss" value="/assets/css/theme.css"/>
    <c:url var="authCss" value="/assets/css/auth.css"/>
    <c:url var="interRegular" value="/assets/fonts/inter/Inter-Regular.woff2"/>
    <c:url var="faviconUrl" value="/assets/images/favicon.svg"/>
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
        <!-- BRAND SECTION-->
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

        <!-- FORM SECTION -->
        <div class="col-lg-7 auth-form-section">
            <div class="p-4 p-sm-5">
                <!-- MOBILE LOGO -->
                <div class="text-center mb-4 d-lg-none">
                    <i class="fas fa-pills fa-3x text-primary mb-2"></i>
                    <h5 class="fw-bold">PMS</h5>
                </div>

                <!-- FORM HEADER -->
                <div class="form-header">
                    <h3 class="fw-bold mb-2">Welcome Back</h3>
                    <p class="text-muted mb-4">Sign in to manage your pharmacy</p>
                </div>

                <!-- ALERT MESSAGE -->
                <% String errorMessage = (String) request.getAttribute("error-message");
                    if (errorMessage != null) { %>
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <span><%= errorMessage %></span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>

                <form action="LoginServlet" method="post">
                    <%--USERNAME--%>
                    <div class="mb-3">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="username" name="txtUsername"
                                   placeholder="Username" required>
                            <label for="username">Username</label>
                            <div class="username-error text-danger"></div>
                        </div>
                    </div>

                    <%-- PASSWORD --%>
                    <div class="mb-3">
                        <div class="form-floating password-group position-relative mb-3">
                            <input type="password" class="form-control" id="password" name="txtPassword"
                                   placeholder="Password" required>

                            <label for="password">Password</label>
                            <i class="fas fa-eye toggle-password"></i>
                        </div>
                        <div class="password-error text-danger"></div>
                    </div>



                    <%-- SIGN IN BUTTON --%>
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
                        <i class="fas fa-sign-in-alt me-2"></i>Sign In
                    </button>
                </form>


                <%-- FOOTER--%>
                <div class="text-center mt-4 pt-3 border-top">
                    <p class="text-muted mb-2">Don't have an account?
                        <%-- REGISTRATION PAGE LINK--%>
                        <a href="registration.jsp" class="text-decoration-none fw-semibold">Create Account</a>
                    </p>
                    <p class="text-muted small mb-0">&copy; 2025 Pharmacy Management System. All rights reserved.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<c:url var="bootstrapJs" value="/assets/js/bootstrap.bundle.min.js"/>
<script src="${bootstrapJs}"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        const usernameInput = document.getElementById("username");
        const passwordInput = document.getElementById("password");
        const usernameError = document.querySelector(".username-error");
        const passwordError = document.querySelector(".password-error");
        const loginBtn = document.querySelector("button");

        function validateForm() {
            const usernameValid = /^[a-z][a-z0-9]{5,19}$/.test(usernameInput.value);
            const passwordValid = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_\-+={}[\]|\\]).{8,}$/.test(passwordInput.value);

            // ENABLE ONLY WHEN BOTH ARE VALID
            loginBtn.disabled = !(usernameValid && passwordValid);
        }

        // USERNAME VALIDATION
        usernameInput.addEventListener("input", function () {
            if (!/^[a-z][a-z0-9]{5,19}$/.test(this.value)) {
                usernameError.innerHTML = "Username must start with lowercase and be 6–20 characters.";
            } else {
                usernameError.innerHTML = "";
            }
            validateForm();
        });

        // PASSWORD VALIDATION
        passwordInput.addEventListener("input", function () {
            if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_\-+={}[\]|\\]).{8,}$/.test(this.value)) {
                passwordError.innerHTML = "Password must contain uppercase, lowercase, number & symbol (8+ chars).";
            } else {
                passwordError.innerHTML = "";
            }
            validateForm();
        });

        // SHOW / HIDE PASSWORD
        document.querySelector(".toggle-password").addEventListener("click", function () {
            passwordInput.type = (passwordInput.type === "password") ? "text" : "password";
            this.classList.toggle("fa-eye");
            this.classList.toggle("fa-eye-slash");
        });

        // DISABLE BUTTON
        loginBtn.disabled = true;
    });
</script>

</body>
</html>