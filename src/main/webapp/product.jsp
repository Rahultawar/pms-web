<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!-- Session and required data checks using JSTL/EL -->
<c:if test="${empty sessionScope.username}">
    <c:redirect url="index.jsp"/>
    <c:remove var="_stop"/>
</c:if>

<c:if test="${requestScope.productList == null}">
    <c:redirect url="ProductServlet"/>
</c:if>

<c:set var="p" value="${requestScope.productDetails}"/>
<!-- URL for dashboard servlet (ensures correct context path) -->
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product</title>
    <c:url var="bootstrapCss" value="/assets/css/bootstrap.min.css"/>
    <c:url var="fontAwesomeCss" value="/assets/css/fontawesome.min.css"/>
    <c:url var="themeCss" value="/assets/css/theme.css"/>
    <c:url var="bootstrapJs" value="/assets/js/bootstrap.bundle.min.js"/>
    <c:url var="appJs" value="/assets/js/app.js"/>
    <c:url var="interRegular" value="/assets/fonts/inter/Inter-Regular.woff2"/>
    <link rel="stylesheet" href="${bootstrapCss}"/>
    <link rel="stylesheet" href="${fontAwesomeCss}"/>
    <link rel="stylesheet" href="${themeCss}"/>
    <link rel="preload" href="${interRegular}" as="font" type="font/woff2" crossorigin>

    <c:url var="styleUrl" value="/assets/css/style.css"/>
    <link rel="stylesheet" href="${styleUrl}"/>
    <c:url var="enhancedStyleUrl" value="/assets/css/enhanced-ui.css"/>
    <link rel="stylesheet" href="${enhancedStyleUrl}"/>
    <c:url var="noAnimationsUrl" value="/assets/css/no-animations.css"/>
    <link rel="stylesheet" href="${noAnimationsUrl}"/>
    <c:url var="iconUrl" value="/assets/images/logo-modern.svg"/>
    <c:url var="faviconUrl" value="/assets/images/favicon.svg"/>
    <link rel="icon" href="${faviconUrl}" type="image/svg+xml">
    <c:url var="profilePicUrl" value="/assets/images/ProfilePic.jpg"/>
    <c:url var="logoutUrl" value="/LogoutServlet"/>
</head>
<!-- Product Management Page Body -->
<body data-page="product">

<!-- Main Application Container -->
<div class="app-shell">
<!-- SIDEBAR -->
<aside id="sidebar" class="d-flex flex-column flex-shrink-0 p-3">
    <b>
        <a href="DashboardServlet"
           class="d-flex align-items-center mb-3 mb-md-0 p-2 me-md-auto text-decoration-none text-dark">
            <img src="${iconUrl}" alt="Logo" width="40" height="40"
                 style="border-radius: 8px;">
            <span class="fs-6 ms-2">${sessionScope.medicalStoreName != null ? sessionScope.medicalStoreName : 'Medical Store'}</span>
        </a>
    </b>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="DashboardServlet" class="nav-link">
                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="ProductServlet" class="nav-link active" aria-current="page">
                <i class="fas fa-pills me-2"></i> Product
            </a>
        </li>
        <li>
            <a href="DistributorServlet" class="nav-link">
                <i class="fas fa-truck me-2"></i> Distributor
            </a>
        </li>
                        <li>
                            <a href="SaleServlet" class="nav-link">
                                <i class="fas fa-file-invoice-dollar me-2"></i> Sales
                            </a>
                        </li>
                        <li>
                            <a href="#" class="nav-link">
                                <i class="fas fa-user me-2"></i> Profile
                            </a>
                        </li>
                        <li>
                            <a href="${logoutUrl}" class="nav-link">
                                <i class="fas fa-sign-out-alt me-2"></i> Logout
                            </a>
                        </li>
                    </ul>
</aside>
<!-- /SIDEBAR -->

<!-- MAIN CONTENT -->
<main id="content-wrapper" class="flex-fill">
    <div class="container-fluid">
        <div class="row align-items-center mb-3">
            <div class="col-md-8 col-12 mb-2 mb-md-0">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0" id="breadcrumbItem">
                        <li class="breadcrumb-item"><a href="DashboardServlet">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Product</li>
                    </ol>
                </nav>
            </div>
            <div class="col-md-4 col-12 text-md-end">
                <button class="btn btn-outline-success" id="addProduct"
                        data-action="show-form" data-mode="add">
                    <i class="fas fa-plus-circle me-2"></i>Add Product
                </button>
            </div>
        </div>
        <div>
            <c:choose>
                <c:when test="${empty productList}">
                    <div id="noProductAvailable" class="empty-state">
                        <h2 class="empty-state__title">No products available</h2>
                        <p class="empty-state__subtitle">Add your first product to start tracking inventory and
                            availability in one place.</p>
                        <button class="btn btn-success" data-action="show-form" data-mode="add">
                            <i class="fas fa-plus-circle me-2"></i>Add Product
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="productTable" class="card table-card">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>Product Name</th>
                                <th>Category</th>
                                <th>Manufacturing Date</th>
                                <th>Expiry Date</th>
                                <th>Quantity In Stock</th>
                                <th>Selling Price</th>
                                <th>Edit</th>
                                <th>Delete</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="product" items="${productList}">
                                <tr>
                                    <td>${product.productName}</td>
                                    <td>${product.category}</td>
                                    <td>${product.manufacturingDate}</td>
                                    <td>${product.expiryDate}</td>
                                    <td>${product.quantity}</td>
                                    <td>${product.sellingPrice}</td>
                                    <td><a href="ProductServlet?id=${product.productId}" title="Edit"><i
                                            class="fas fa-edit"></i></a></td>
                     <td><a href="ProductServlet?deleteId=${product.productId}"
                         data-confirm="Are you sure you want to delete this product?" title="Delete"><i class="fas fa-trash-alt"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        </div>

                        <!-- Pagination -->
                        <div class="pagination-wrapper card-footer bg-transparent">
                            <c:if test="${noOfPages > 1}">
                                <c:forEach begin="1" end="${noOfPages}" var="i">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="btn btn-success btn-sm">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url var="pageUrl" value="ProductServlet">
                                                <c:param name="page" value="${i}"/>
                                            </c:url>
                                            <a href="${pageUrl}" class="btn btn-outline-success btn-sm">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Product Add/Edit Form - Hidden by default, shown by JavaScript -->
            <div id="productForm" class="card form-card">
                <h5 class="card-title mb-3" id="formTitle">Add New Product</h5>
                <form action="ProductServlet" method="post">
                    <!-- Hidden fields for product ID and action type -->
                    <input type="hidden" id="productId" name="productId"
                           value="${requestScope.productDetails.productId}">
                    <input type="hidden" name="actionType"
                           value="${requestScope.productDetails != null ? 'update' : 'add'}">
                    <input type="hidden" name="txtUserId" value="${sessionScope.userId}">

                    <!-- Form fields organized in two columns for better layout -->
                    <div class="row">
                    <input type="hidden" id="productId" name="productId"
                           value="${requestScope.productDetails.productId}">
                    <input type="hidden" name="actionType"
                           value="${requestScope.productDetails != null ? 'update' : 'add'}">
                    <input type="hidden" name="txtUserId" value="${sessionScope.userId}">

                    <div class="row">
                        <!-- First Column -->

                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="productName" name="txtProductName"
                                       placeholder="Product Name"
                                       value="${requestScope.productDetails.productName}" required>
                                <label for="productName">Product Name</label>
                            </div>

                            <div class="form-floating mb-3">
                                <select class="form-control" id="category" name="selCategory">
                                    <option value="" disabled>Select Category</option>
                                    <option value="Analgesic"
                                            <c:if test="${p != null and p.category == 'Analgesic'}">selected</c:if>>
                                        Analgesic
                                    </option>
                                    <option value="Antacid"
                                            <c:if test="${p != null and p.category == 'Antacid'}">selected</c:if>>
                                        Antacid
                                    </option>
                                    <option value="Antiseptic"
                                            <c:if test="${p != null and p.category == 'Antiseptic'}">selected</c:if>>
                                        Antiseptic
                                    </option>
                                    <option value="Antifungal"
                                            <c:if test="${p != null and p.category == 'Antifungal'}">selected</c:if>>
                                        Antifungal
                                    </option>
                                    <option value="Antiviral"
                                            <c:if test="${p != null and p.category == 'Antiviral'}">selected</c:if>>
                                        Antiviral
                                    </option>
                                    <option value="Anti-inflammatory"
                                            <c:if test="${p != null and p.category == 'Anti-inflammatory'}">selected</c:if>>
                                        Anti-inflammatory
                                    </option>
                                    <option value="Antiallergic"
                                            <c:if test="${p != null and p.category == 'Antiallergic'}">selected</c:if>>
                                        Antiallergic
                                    </option>
                                    <option value="Antipyretic"
                                            <c:if test="${p != null and p.category == 'Antipyretic'}">selected</c:if>>
                                        Antipyretic
                                    </option>
                                    <option value="Cough & Cold"
                                            <c:if test="${p != null and p.category == 'Cough & Cold'}">selected</c:if>>
                                        Cough & Cold
                                    </option>
                                    <option value="Vitamins & Supplements"
                                            <c:if test="${p != null and p.category == 'Vitamins & Supplements'}">selected</c:if>>
                                        Vitamins & Supplements
                                    </option>
                                    <option value="Cardiac"
                                            <c:if test="${p != null and p.category == 'Cardiac'}">selected</c:if>>
                                        Cardiac
                                    </option>
                                    <option value="Diabetic Care"
                                            <c:if test="${p != null and p.category == 'Diabetic Care'}">selected</c:if>>
                                        Diabetic Care
                                    </option>
                                    <option value="Gastrointestinal"
                                            <c:if test="${p != null and p.category == 'Gastrointestinal'}">selected</c:if>>
                                        Gastrointestinal
                                    </option>
                                    <option value="Dermatology"
                                            <c:if test="${p != null and p.category == 'Dermatology'}">selected</c:if>>
                                        Dermatology
                                    </option>
                                    <option value="Neurology"
                                            <c:if test="${p != null and p.category == 'Neurology'}">selected</c:if>>
                                        Neurology
                                    </option>
                                    <option value="Ophthalmic"
                                            <c:if test="${p != null and p.category == 'Ophthalmic'}">selected</c:if>>
                                        Ophthalmic
                                    </option>
                                    <option value="ENT"
                                            <c:if test="${p != null and p.category == 'ENT'}">selected</c:if>>ENT
                                    </option>
                                    <option value="Pediatric"
                                            <c:if test="${p != null and p.category == 'Pediatric'}">selected</c:if>>
                                        Pediatric
                                    </option>
                                    <option value="Gynecology"
                                            <c:if test="${p != null and p.category == 'Gynecology'}">selected</c:if>>
                                        Gynecology
                                    </option>
                                    <option value="Personal Care"
                                            <c:if test="${p != null and p.category == 'Personal Care'}">selected</c:if>>
                                        Personal Care
                                    </option>
                                    <option value="Cosmetics"
                                            <c:if test="${p != null and p.category == 'Cosmetics'}">selected</c:if>>
                                        Cosmetics
                                    </option>
                                    <option value="Medical Devices"
                                            <c:if test="${p != null and p.category == 'Medical Devices'}">selected</c:if>>
                                        Medical Devices
                                    </option>
                                    <option value="Surgical"
                                            <c:if test="${p != null and p.category == 'Surgical'}">selected</c:if>>
                                        Surgical
                                    </option>
                                    <option value="Sanitizers & Disinfectants"
                                            <c:if test="${p != null and p.category == 'Sanitizers & Disinfectants'}">selected</c:if>>
                                        Sanitizers & Disinfectants
                                    </option>
                                    <option value="Baby Care"
                                            <c:if test="${p != null and p.category == 'Baby Care'}">selected</c:if>>Baby
                                        Care
                                    </option>
                                    <option value="OTC Products"
                                            <c:if test="${p != null and p.category == 'OTC Products'}">selected</c:if>>
                                        OTC Products
                                    </option>
                                </select>
                                <label for="category">Category</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="manufacturer" name="txtManufacturer"
                                       placeholder="Manufacturer"
                                       value="${requestScope.productDetails.manufacturer}" required>
                                <label for="manufacturer">Manufacturer</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="batchNumber" name="txtBatchNumber"
                                       placeholder="Batch Number"
                                       value="${requestScope.productDetails.batchNumber}" required>
                                <label for="batchNumber">Batch Number</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="strength" name="txtStrength"
                                       placeholder="Strength"
                                       value="${requestScope.productDetails.strength}" required>
                                <label for="strength">Strength</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="location" name="txtLocation"
                                       placeholder="Location"
                                       value="${requestScope.productDetails.location}">
                                <label for="location">Location</label>
                            </div>

                            <div class="form-floating mb-3">
                                <select class="form-control" id="distributorId" name="txtDistributorId" required>
                                    <option value="">Select Distributor</option>
                                    <c:forEach var="distributor" items="${requestScope.distributorList}">
                                        <option value="${distributor.distributorId}"
                                            ${distributor.distributorId == requestScope.productDetails.distributorId ? 'selected' : ''}>
                                                ${distributor.distributorName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <label for="distributorId">Distributor</label>
                            </div>

                <div class="form-floating mb-3 stripDetails">
                                <input type="number" class="form-control" min="0" id="subQuantity"
                                       name="txtSubQuantity" placeholder="Sub Quantity (Units in Strip)"
                                       value="${requestScope.productDetails.subQuantity > 0 ? requestScope.productDetails.subQuantity : ''}"
                                       data-strip-required="false" disabled>
                                <label for="subQuantity">Sub Quantity (Units in Strip)</label>
                            </div>
                        </div>

                        <!-- Second Column -->
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="date" class="form-control" id="manufacturingDate" name="manufacturingDate"
                                       placeholder="Manufacturing Date"
                                       value="${requestScope.productDetails.manufacturingDate}" required>
                                <label for="manufacturingDate">Manufacturing Date</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="date" class="form-control" id="expiryDate" name="expiryDate"
                                       placeholder="Expiry Date"
                                       value="${requestScope.productDetails.expiryDate}" required>
                                <label for="expiryDate">Expiry Date</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="number" class="form-control" id="quantity" name="txtQuantity"
                                       placeholder="Quantity"
                                       value="${requestScope.productDetails.quantity}" required>
                                <label for="quantity">Quantity</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="number" class="form-control" id="reorderLevel" name="txtReorderLevel"
                                       placeholder="Reorder Level"
                                       value="${requestScope.productDetails.reorderLevel}" required>
                                <label for="reorderLevel">Reorder Level</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="number" step="0.01" class="form-control" id="purchasingPrice"
                                       name="txtPurchasingPrice" placeholder="Purchasing Price"
                                       value="${requestScope.productDetails.purchasingPrice}" required>
                                <label for="purchasingPrice">Purchasing Price</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="number" step="0.01" class="form-control" id="sellingPrice"
                                       name="txtSellingPrice" placeholder="Selling Price"
                                       value="${requestScope.productDetails.sellingPrice}" required>
                                <label for="sellingPrice">Selling Price</label>
                            </div>

                            <div class="form-floating mb-3">
                                <select class="form-control" id="unit" name="selUnit" required>
                                    <option value="" disabled>Select unit</option>
                                    <option value="tube" ${requestScope.productDetails.unit == 'tube' ? 'selected' : ''}>
                                        Tube
                                    </option>
                                    <option value="vial" ${requestScope.productDetails.unit == 'vial' ? 'selected' : ''}>
                                        Vial
                                    </option>
                                    <option value="strip" ${requestScope.productDetails.unit == 'strip' ? 'selected' : ''}>
                                        Strip
                                    </option>
                                    <option value="bottle" ${requestScope.productDetails.unit == 'bottle' ? 'selected' : ''}>
                                        Bottle
                                    </option>
                                    <option value="sachet" ${requestScope.productDetails.unit == 'sachet' ? 'selected' : ''}>
                                        Sachet
                                    </option>
                                    <option value="box" ${requestScope.productDetails.unit == 'box' ? 'selected' : ''}>
                                        Box
                                    </option>
                                    <option value="piece" ${requestScope.productDetails.unit == 'piece' ? 'selected' : ''}>
                                        Piece
                                    </option>
                                    <option value="ampoule" ${requestScope.productDetails.unit == 'ampoule' ? 'selected' : ''}>
                                        Ampoule
                                    </option>
                                    <option value="syringe" ${requestScope.productDetails.unit == 'syringe' ? 'selected' : ''}>
                                        Syringe
                                    </option>
                                    <option value="injection" ${requestScope.productDetails.unit == 'injection' ? 'selected' : ''}>
                                        Injection
                                    </option>
                                    <option value="pack" ${requestScope.productDetails.unit == 'pack' ? 'selected' : ''}>
                                        Pack
                                    </option>
                                    <option value="roll" ${requestScope.productDetails.unit == 'roll' ? 'selected' : ''}>
                                        Roll
                                    </option>
                                </select>
                                <label for="unit">Unit</label>
                            </div>


                        </div>
                    </div>

                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-success me-2">Save Product</button>
                        <button type="reset" class="btn btn-outline-secondary">Reset</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>
<!-- /MAIN CONTENT -->

</div>

<!-- Shared JS -->
                <script src="${appJs}"></script>

<c:if test="${not empty requestScope.productDetails}">
    <script>
        // Ask shared module to show edit form when server provided productDetails
        document.addEventListener('DOMContentLoaded', function () {
            PMS.showForm('edit');
        });
    </script>
</c:if>

<script src="${bootstrapJs}"></script>


</body>
</html>
