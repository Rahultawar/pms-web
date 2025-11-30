<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Pharmacy Management System</title>
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
    <c:url var="noAnimationsUrl" value="/assets/css/no-animations.css"/>
    <link rel="stylesheet" href="${noAnimationsUrl}"/>
</head>

<body class="auth-page">
<div class="container-fluid vh-100 d-flex align-items-center justify-content-center">
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
            <div class="p-3">
                <!-- MOBILE LOGO -->
                <div class="text-center mb-4 mt-2 d-lg-none">
                    <i class="fas fa-pills fa-4x mb-4 animate-float text-success"></i>
                    <h5 class="fw-bold">Create Account</h5>
                </div>

                <div class="form-header">
                    <h3 class="fw-bold">Register Your Store</h3>
                    <p class="text-muted mb-4">Complete the form to access admin console</p>

                    <!-- DISPLAY ERROR OR SUCCESS MESSAGE -->
                    <c:if test="${not empty requestScope['error-message']}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${requestScope['error-message']}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty requestScope['success-message']}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${requestScope['success-message']}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                        </div>
                    </c:if>
                </div>

                <form action="RegistrationServlet" method="post" enctype="multipart/form-data"
                      class="needs-validation"
                      novalidate>
                    <%-- MEDICAL STORE NAME --%>
                    <div class="form-floating">
                        <input type="text" class="form-control" id="medicalStoreName" name="medicalStoreName"
                               placeholder="Medical Store Name" required>
                        <label for="medicalStoreName">Medical Store Name</label>
                        <div class="medicalStoreName-error text-danger"></div>
                    </div>

                    <%-- USERNAME --%>
                    <div class="form-floating">
                        <input type="text" class="form-control" id="username" name="userName"
                               placeholder="Username" required>
                        <label for="userName">Username</label>
                        <div class="reg-username-error text-danger"></div>
                    </div>

                    <%-- PASSWORD --%>
                    <div class="form-floating password-group position-relative">
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="Password" required>

                        <label for="password">Password</label>
                        <i class="fas fa-eye toggle-password"></i>
                    </div>
                    <div class="reg-password-error text-danger"></div>

                    <%-- CONFIRM PASSWORD --%>
                    <div class="form-floating password-group position-relative">
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                               placeholder="Confirm Password" required>

                        <label for="confirmPassword">Confirm Password</label>
                        <i class="fas fa-eye toggle-password" id="toggle-password-con"></i>
                    </div>
                    <div class="confirmPassword-error text-danger"></div>

                    <%-- MEDICAL STORE LOGO --%>
                    <label for="medicalStoreLogo" class="form-label fw-semibold">Store Logo (Optional)</label>
                    <input type="file" class="form-control" id="medicalStoreLogo"
                           name="medicalStoreLogo" accept="image/png, image/jpeg, image/svg+xml">
                    <div class="medicalStoreLogo-error text-danger"></div>

                    <%-- CREATE ACCOUNT BUTTON --%>
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                        <i class="fas fa-user-plus me-2"></i>Create Account
                    </button>
                </form>

                <div class="text-center mt-0 pt-3 border-top">
                    <p class="text-muted">Already registered?
                        <a href="index.jsp" class="text-decoration-none fw-semibold">Sign in here</a>
                    </p>
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
        const confirmPasswordInput = document.getElementById("confirmPassword");
        const medicalStoreNameInput = document.getElementById("medicalStoreName");

        const usernameError = document.querySelector(".reg-username-error");
        const passwordError = document.querySelector(".reg-password-error");
        const confirmPasswordError = document.querySelector(".confirmPassword-error");
        const medicalStoreNameError = document.querySelector(".medicalStoreName-error");

        const createAccountBtn = document.querySelector("button");

        function validateForm() {

            const usernameValid = /^[a-z][a-z0-9]{5,19}$/.test(usernameInput.value);
            const passwordValid = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_\-+={}[\]|\\]).{8,}$/.test(passwordInput.value);
            const confirmPasswordValid = passwordInput.value === confirmPasswordInput.value;
            const medicalStoreNameValid = /^[a-zA-Z0-9 ]{3,50}$/.test(medicalStoreNameInput.value);

            createAccountBtn.disabled = !(usernameValid && passwordValid && confirmPasswordValid && medicalStoreNameValid);
        }

        // MEDICAL STORE NAME VALIDATION
        medicalStoreNameInput.addEventListener("input", function () {
            if (!/^[a-zA-Z0-9 ]{3,50}$/.test(this.value)) {
                medicalStoreNameError.innerHTML = "Store name must be 3–50 characters and can include spaces.";
            } else {
                medicalStoreNameError.innerHTML = "";
            }
            validateForm();
        });

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

        // CONFIRM PASSWORD VALIDATION
        confirmPasswordInput.addEventListener("input", function () {
            if (this.value !== passwordInput.value) {
                confirmPasswordError.innerHTML = "Passwords must match.";
            } else {
                confirmPasswordError.innerHTML = "";
            }
            validateForm();
        });

        // TOGGLE PASSWORD
        document.querySelector(".toggle-password").addEventListener("click", function () {
            passwordInput.type = (passwordInput.type === "password") ? "text" : "password";
            this.classList.toggle("fa-eye");
            this.classList.toggle("fa-eye-slash");
        });

        document.querySelector("#toggle-password-con").addEventListener("click", function () {
            confirmPasswordInput.type = (confirmPasswordInput.type === "password") ? "text" : "password";
            this.classList.toggle("fa-eye");
            this.classList.toggle("fa-eye-slash");
        });

        createAccountBtn.disabled = true;
    });
</script>
</body>

</html>
