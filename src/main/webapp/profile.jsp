<%@ page contentType="text/html;charset=UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ page isELIgnored="false" %>

			<c:if test="${empty sessionScope.username}">
				<c:redirect url="index.jsp" />
				<c:remove var="_stop" />
			</c:if>

			<!DOCTYPE html>
			<html lang="en">

			<head>
				<meta charset="UTF-8">
				<meta name="viewport" content="width=device-width, initial-scale=1.0">
				<title>Profile - ${sessionScope.medicalStoreName != null ? sessionScope.medicalStoreName : 'Medical
					Store'}</title>
				<c:url var="bootstrapCss" value="/assets/css/bootstrap.min.css" />
				<c:url var="fontAwesomeCss" value="/assets/css/fontawesome.min.css" />
				<c:url var="themeCss" value="/assets/css/theme.css" />
				<c:url var="bootstrapJs" value="/assets/js/bootstrap.bundle.min.js" />
				<c:url var="appJs" value="/assets/js/app.js" />
				<c:url var="interRegular" value="/assets/fonts/inter/Inter-Regular.woff2" />
				<link rel="stylesheet" href="${bootstrapCss}" />
				<link rel="stylesheet" href="${fontAwesomeCss}" />
				<link rel="stylesheet" href="${themeCss}" />
				<link rel="preload" href="${interRegular}" as="font" type="font/woff2" crossorigin>
				<c:url var="styleUrl" value="/assets/css/style.css" />
				<link rel="stylesheet" href="${styleUrl}" />
				<c:url var="enhancedStyleUrl" value="/assets/css/enhanced-ui.css" />
				<link rel="stylesheet" href="${enhancedStyleUrl}" />
				<c:url var="noAnimationsUrl" value="/assets/css/no-animations.css" />
				<link rel="stylesheet" href="${noAnimationsUrl}" />
				<c:url var="iconUrl" value="/assets/images/logo-modern.svg" />
				<c:url var="faviconUrl" value="/assets/images/favicon.svg" />
				<link rel="icon" href="${faviconUrl}" type="image/svg+xml">
				<c:url var="profilePicUrl" value="/assets/images/ProfilePic.jpg" />
				<c:url var="logoutUrl" value="/LogoutServlet" />
			</head>

			<body data-page="profile">
				<div class="app-shell">
					<!-- SIDEBAR -->
					<jsp:include page="sidebar.jsp">
						<jsp:param name="activePage" value="profile" />
					</jsp:include>
					<!-- /SIDEBAR -->

					<!-- MAIN CONTENT -->
					<main id="content-wrapper" class="flex-fill">
						<div class="container-fluid">
							<div class="row align-items-center mb-3">
								<div class="col-md-9 col-12 mb-2 mb-md-0">
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb mb-0" id="breadcrumbItem">
											<li class="breadcrumb-item"><a href="DashboardServlet">Home</a></li>
											<li class="breadcrumb-item active" aria-current="page">Profile</li>
										</ol>
									</nav>
								</div>
							</div>

							<!-- ERROR/SUCCESS MESSAGE -->
							<c:if test="${not empty requestScope.errorMessage}">
								<div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
									<i class="fas fa-exclamation-circle me-2"></i>
									<span>${requestScope.errorMessage}</span>
									<button type="button" class="btn-close" data-bs-dismiss="alert"
										aria-label="Close"></button>
								</div>
							</c:if>

							<c:if test="${not empty requestScope.successMessage}">
								<div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
									<i class="fas fa-check-circle me-2"></i> <span>${requestScope.successMessage}</span>
									<button type="button" class="btn-close" data-bs-dismiss="alert"
										aria-label="Close"></button>
								</div>
							</c:if>

							<!-- PROFILE VIEW -->
							<div id="profileView" class="card">
								<div class="card-header d-flex justify-content-between align-items-center">
									<h5 class="mb-0">Profile Information</h5>
									<button type="button" class="btn btn-primary btn-sm" id="editProfile"
										onclick="PMS.showForm('edit')">
										<i class="fas fa-edit me-1"></i>Edit Profile
									</button>
								</div>
								<div class="card-body">
									<div class="row align-items-center">
										<div class="col-auto d-flex align-items-center justify-content-center">
											<div class="profile-image-area">
												<c:set var="defaultLogo"
													value="${pageContext.request.contextPath}/assets/images/logo-modern.svg" />
												<c:choose>
													<c:when
														test="${not empty requestScope.userProfile.medicalStoreLogo}">
														<img src="data:image/jpeg;base64,${requestScope.userProfile.medicalStoreLogo}"
															alt="Store Logo" class="profile-photo"
															style="width: 100px; height: 100px; object-fit: cover; border-radius: 50%;"
															onerror="this.onerror=null; this.src='${defaultLogo}';">
													</c:when>
													<c:otherwise>
														<img src="${defaultLogo}" alt="Default Store Logo"
															class="profile-photo"
															style="width: 100px; height: 100px; object-fit: cover; border-radius: 50%;">
													</c:otherwise>
												</c:choose>
											</div>
										</div>
										<div class="col">
											<strong
												class="text-primary">${requestScope.userProfile.medicalStoreName}</strong><br>
											<small class="text-muted">Username:
												${requestScope.userProfile.userName}</small><br>
										</div>
									</div>
								</div>
							</div>

							<!-- PROFILE EDIT FORM -->
							<div id="profileForm" class="card form-card">
								<h5 class="card-title mb-3" id="formTitle">Edit Profile</h5>
								<form action="ProfileServlet" method="post" enctype="multipart/form-data"
									id="profileUpdateForm">
									<input type="hidden" name="actionType" value="update">

									<div class="row">
										<div class="col-md-6">
											<div class="form-floating mb-3">
												<input type="text" class="form-control" id="userName" name="txtUserName"
													placeholder="Username" value="${requestScope.userProfile.userName}"
													readonly>
												<label for="userName">Username</label>
												<div class="form-text">Username cannot be changed</div>
											</div>

											<div class="form-floating mb-3">
												<input type="text" class="form-control" id="medicalStoreName"
													name="txtMedicalStoreName" placeholder="Medical Store Name"
													value="${requestScope.userProfile.medicalStoreName}" required>
												<label for="medicalStoreName">Medical Store Name</label>
												<div class="invalid-feedback">Store name must be 3–50
													characters and can include spaces.</div>
											</div>

											<div class="form-floating mb-3">
												<input type="password" class="form-control" id="currentPassword"
													name="txtCurrentPassword" placeholder="Current Password"> <label
													for="currentPassword">Current Password</label>
												<div class="form-text">Leave empty if you don't want to
													change password</div>
											</div>

											<div class="form-floating mb-3">
												<input type="password" class="form-control" id="newPassword"
													name="txtNewPassword" placeholder="New Password"> <label
													for="newPassword">New Password</label>
												<div class="invalid-feedback">Password must contain
													uppercase, lowercase, number & symbol (8+ chars).</div>
											</div>
										</div>

										<div class="col-md-6">
											<div class="mb-3">
												<label for="storeLogo" class="form-label ">Update Store
													Logo (Will be resized to 500KB)</label>
												<input type="file" class="form-control" id="storeLogo"
													name="storeLogoFile" accept="image/png, image/jpeg, image/jpg">
												<div class="store-logo-error text-danger small mt-1"></div>
											</div>

											<div class="form-floating mb-3">
												<input type="password" class="form-control" id="confirmPassword"
													name="txtConfirmPassword" placeholder="Confirm New Password"> <label
													for="confirmPassword">Confirm New Password</label>
												<div class="invalid-feedback">Passwords must match.</div>
											</div>
										</div>
									</div>

									<div class="d-flex justify-content-end">
										<button type="submit" class="btn btn-primary me-2">
											<i class="fas fa-save me-2"></i>Update Profile
										</button>
										<a href="ProfileServlet" class="btn btn-outline-secondary" id="btnCancel"> <i
												class="fas fa-times me-2"></i>Cancel
										</a>

									</div>
								</form>
							</div>
						</div>
					</main>
					<!-- /MAIN CONTENT -->
				</div>


				<script src="${bootstrapJs}"></script>
				<script src="${appJs}"></script>
				<script>
					document
						.addEventListener(
							'DOMContentLoaded',
							function () {

								if (window.PMS && window.PMS.hideForm) {
									window.PMS.hideForm();
								} else {
									document.getElementById('profileForm').style.display = 'none';
									document.getElementById('profileView').style.display = 'block';
									document.getElementById('editProfile').style.display = 'inline-block';
								}

								// FORM VALIDATION
								const newPasswordField = document
									.getElementById('newPassword');
								const confirmPasswordField = document
									.getElementById('confirmPassword');
								const currentPasswordField = document
									.getElementById('currentPassword');

								function validatePasswords() {
									if (newPasswordField.value
										&& newPasswordField.value !== confirmPasswordField.value) {
										confirmPasswordField
											.setCustomValidity('Passwords do not match');
									} else {
										confirmPasswordField.setCustomValidity('');
									}
								}

								newPasswordField.addEventListener('input',
									validatePasswords);
								confirmPasswordField.addEventListener('input',
									validatePasswords);

								newPasswordField
									.addEventListener(
										'input',
										function () {
											if (this.value) {
												currentPasswordField
													.setAttribute(
														'required',
														'required');
												confirmPasswordField
													.setAttribute(
														'required',
														'required');
											} else {
												currentPasswordField
													.removeAttribute('required');
												confirmPasswordField
													.removeAttribute('required');
											}
										});

								// IMAGE COMPRESSION FUNCTION
								let compressedImageFile = null;

								function compressImage(file, maxSizeKB = 500) {
									return new Promise((resolve, reject) => {
										const reader = new FileReader();
										reader.readAsDataURL(file);
										reader.onload = function (event) {
											const img = new Image();
											img.src = event.target.result;
											img.onload = function () {
												const canvas = document.createElement('canvas');
												let width = img.width;
												let height = img.height;

												// Resize if too large
												const maxDimension = 800;
												if (width > height && width > maxDimension) {
													height = (height * maxDimension) / width;
													width = maxDimension;
												} else if (height > maxDimension) {
													width = (width * maxDimension) / height;
													height = maxDimension;
												}

												canvas.width = width;
												canvas.height = height;

												const ctx = canvas.getContext('2d');
												ctx.drawImage(img, 0, 0, width, height);

												// Start with quality 0.9 and reduce until size is acceptable
												let quality = 0.9;
												let compressed = canvas.toDataURL('image/jpeg', quality);

												while (compressed.length > maxSizeKB * 1024 * 1.37 && quality > 0.1) {
													quality -= 0.1;
													compressed = canvas.toDataURL('image/jpeg', quality);
												}

												// Convert base64 to blob
												canvas.toBlob(function (blob) {
													const compressedFile = new File([blob], file.name, {
														type: 'image/jpeg',
														lastModified: Date.now()
													});
													resolve(compressedFile);
												}, 'image/jpeg', quality);
											};
											img.onerror = reject;
										};
										reader.onerror = reject;
									});
								}

								// FILE UPLOAD WITH COMPRESSION
								const fileInput = document.getElementById('storeLogo');
								const logoError = document.querySelector('.store-logo-error');

								if (fileInput) {
									fileInput.addEventListener('change', async function (e) {
										logoError.innerHTML = '<span class="text-info">Processing image...</span>';

										if (this.files.length > 0) {
											const file = this.files[0];
											const fileSizeMB = file.size / (1024 * 1024);

											try {
												// Compress the image
												compressedImageFile = await compressImage(file, 500);
												const compressedSizeKB = compressedImageFile.size / 1024;

												logoError.innerHTML = '<span class="text-success">Image compressed: ' +
													fileSizeMB.toFixed(2) + 'MB → ' + compressedSizeKB.toFixed(0) + 'KB ✓</span>';
											} catch (error) {
												logoError.innerHTML = '<span class="text-danger">Error processing image</span>';
												compressedImageFile = null;
												this.value = "";
											}
										} else {
											logoError.innerHTML = "";
											compressedImageFile = null;
										}
									});
								}

								// FORM SUBMIT HANDLER - Replace original file with compressed
								const profileForm = document.getElementById('profileUpdateForm');
								if (profileForm) {
									profileForm.addEventListener('submit', function (e) {
										if (compressedImageFile && fileInput) {
											// Create new DataTransfer to replace the file
											const dataTransfer = new DataTransfer();
											dataTransfer.items.add(compressedImageFile);
											fileInput.files = dataTransfer.files;
										}
									});
								}

								// PROFILE FORM VALIDATION
								const medicalStoreNameInput = document
									.getElementById('medicalStoreName');
								const newPasswordInput = document
									.getElementById('newPassword');
								const confirmPasswordInput = document
									.getElementById('confirmPassword');
								const updateBtn = document
									.querySelector('#profileForm button[type="submit"]');

								const storeNamePattern = /^[a-zA-Z0-9 ]{3,50}$/;
								const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_\\-+={}[\\]|\\\\]).{8,}$/;

								function validateField(input, pattern) {
									if (!pattern.test(input.value.trim())) {
										input.classList.add('is-invalid');
										input.classList.remove('is-valid');
										return false;
									} else {
										input.classList.remove('is-invalid');
										input.classList.add('is-valid');
										return true;
									}
								}

								function validatePasswordMatch() {
									const hasNewPassword = newPasswordInput.value
										.trim() !== '';
									const hasConfirmPassword = confirmPasswordInput.value
										.trim() !== '';

									if ((hasNewPassword || hasConfirmPassword)) {
										if (newPasswordInput.value !== confirmPasswordInput.value) {
											confirmPasswordInput.classList
												.add('is-invalid');
											confirmPasswordInput.classList
												.remove('is-valid');
											return false;
										} else if (hasConfirmPassword) {
											confirmPasswordInput.classList
												.remove('is-invalid');
											confirmPasswordInput.classList
												.add('is-valid');
											return true;
										}
									} else {
										confirmPasswordInput.classList.remove(
											'is-invalid', 'is-valid');
									}
									return true;
								}

								function validateProfileForm() {
									let isValid = true;

									if (!validateField(medicalStoreNameInput,
										storeNamePattern)) {
										isValid = false;
									}

									//PASSWORD VALIDATION
									const hasNewPassword = newPasswordInput.value
										.trim() !== '';

									if (hasNewPassword) {
										if (!validateField(newPasswordInput,
											passwordPattern)) {
											isValid = false;
										}
									} else {
										newPasswordInput.classList.remove(
											'is-invalid', 'is-valid');
									}

									if (!validatePasswordMatch()) {
										isValid = false;
									}

									if (updateBtn) {
										updateBtn.disabled = !isValid;
									}
								}

								// STORE NAME VALIDATION
								if (medicalStoreNameInput) {
									medicalStoreNameInput.addEventListener('input',
										function () {
											validateField(this,
												storeNamePattern);
											validateProfileForm();
										});
								}

								// NEW PASSWORD VALIDATION
								if (newPasswordInput) {
									newPasswordInput.addEventListener('input',
										function () {
											const hasPassword = this.value
												.trim() !== '';
											if (hasPassword) {
												validateField(this,
													passwordPattern);
											} else {
												this.classList.remove(
													'is-invalid',
													'is-valid');
											}
											validatePasswordMatch();
											validateProfileForm();
										});
								}

								// CONFIRM PASSWORD VALIDATION
								if (confirmPasswordInput) {
									confirmPasswordInput.addEventListener('input',
										function () {
											validatePasswordMatch();
											validateProfileForm();
										});
								}

								// INITIAL VALIDATION
								validateProfileForm();

								// CANCEL BUTTON
								const cancelBtn = document
									.getElementById('btnCancel');
								if (cancelBtn) {
									cancelBtn
										.addEventListener(
											'click',
											function () {
												if (window.PMS
													&& window.PMS.hideForm) {
													window.PMS.hideForm();
												} else {
													document
														.getElementById('profileForm').style.display = 'none';
													document
														.getElementById('profileView').style.display = 'block';
													document
														.getElementById('editProfile').style.display = 'inline-block';
												}
											});
								}
							});
				</script>
			</body>

			</html>