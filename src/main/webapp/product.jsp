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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

    <style src="./assets/css/style.css"></style>
    <c:url var="styleUrl" value="/assets/css/style.css"/>
    <link rel="stylesheet" href="${styleUrl}"/>
    <c:url var="enhancedStyleUrl" value="/assets/css/enhanced-ui.css"/>
    <link rel="stylesheet" href="${enhancedStyleUrl}"/>
    <c:url var="iconUrl" value="/assets/images/logo-modern.svg"/>
    <c:url var="faviconUrl" value="/assets/images/favicon.svg"/>
    <link rel="icon" href="${faviconUrl}" type="image/svg+xml">
    <c:url var="profilePicUrl" value="/assets/images/ProfilePic.jpg"/>
    <c:url var="logoutUrl" value="/LogoutServlet"/>
</head>
<body data-page="product">
<!-- HEADER -->
<header class="p-2 mb-3">
    <div class="container">
        <div class="row justify-content-end align-items-center">
            <div class="col-md-5">
                <form class="d-flex mb-0">
                    <input type="search" class="form-control w-75" id="searchBox" placeholder="Search..."
                           aria-label="Search">
                </form>
            </div>
            <div class="col-md-5">
                <div class="dropdown d-flex justify-content-end">
                    <a href="#" class="d-block text-decoration-none dropdown-toggle" data-bs-toggle="dropdown"
                       aria-expanded="false">
                        <img src="${profilePicUrl}" alt="Profile" width="32" height="32"
                             class="rounded-circle">
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end text-small">
                        <li><a class="dropdown-item" href="#">Profile</a></li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item" href="${logoutUrl}">Log out</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</header>
<!-- /HEADER -->

<!-- SIDEBAR -->
<div id="sidebar" class="d-flex flex-column flex-shrink-0 p-3">
    <b>
        <a href="DashboardServlet"
           class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-decoration-none text-dark">
            <img src="${iconUrl}" alt="Logo" width="40" height="40"
                 style="border-radius: 8px;">
            <span class="fs-6 ms-2">Mahadev Medical Store</span>
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
            <a href="sale.jsp" class="nav-link">
                <i class="fas fa-file-invoice-dollar me-2"></i> Sales
            </a>
        </li>
    </ul>
</div>
<!-- /SIDEBAR -->

<!-- MAIN CONTENT -->
<div id="content-wrapper" class="flex-fill">
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
                    <div id="noProductAvailable">
                        <h2 style="margin-bottom: 10px; color: #4CAF50;">No Products Available</h2>
                        <p style="color: #777;">You have not added any products yet. Start by adding new products to
                            manage
                            your inventory efficiently.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="productTable">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered shadow-sm rounded">
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
                                    <td>${product.quantityInStock}</td>
                                    <td>${product.sellingPrice}</td>
                                    <td><a href="ProductServlet?id=${product.productId}" title="Edit"><i
                                            class="fas fa-edit"></i></a></td>
                                    <td><a href="ProductServlet?deleteId=${product.productId}"
                                           onclick="getAlertBox()" title="Delete"><i class="fas fa-trash-alt"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        </div>

                        <!-- Pagination -->
                        <div class="pagination-wrapper">
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

            <!-- PRODUCT FORM -->
            <div id="productForm">
                <h5 class="card-title mb-3" id="formTitle">Add New Product</h5>
                <form action="ProductServlet" method="post">
                    <input type="hidden" id="productId" name="productId"
                           value="${requestScope.productDetails.productId}">
                    <input type="hidden" name="actionType"
                           value="${requestScope.productDetails != null ? 'update' : 'add'}">

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
                                <input type="text" class="form-control" id="shelfLocation" name="txtShelfLocation"
                                       placeholder="Shelf Location"
                                       value="${requestScope.productDetails.shelfLocation}">
                                <label for="shelfLocation">Shelf Location</label>
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

                <div class="form-floating mb-3 stripDetails" style="display:none;">
                                <select name="stripType" id="stripType" class="form-control"
                                        data-strip-required="true" disabled>
                                    <option value="" disabled <c:if test="${p == null || p.stripType == null}">selected</c:if>>Select Strip Type</option>
                    <option value="Tablet"
                        <c:if test="${p != null and p.stripType == 'Tablet'}">selected</c:if>>Tablet
                    </option>
                    <option value="Capsule"
                        <c:if test="${p != null and p.stripType == 'Capsule'}">selected</c:if>>Capsule
                    </option>
                                </select>
                                <label for="stripType">Strip Type</label>
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
                                <input type="number" class="form-control" id="quantityInStock" name="txtQuantityInStock"
                                       placeholder="Quantity in Stock"
                                       value="${requestScope.productDetails.quantityInStock}" required>
                                <label for="quantityInStock">Quantity in Stock</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="number" class="form-control" id="reorderLevel" name="txtReorderLevel"
                                       placeholder="Reorder Level"
                                       value="${requestScope.productDetails.reorderLevel}" required>
                                <label for="reorderLevel">Reorder Level</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="number" step="0.01" class="form-control" id="purchasePrice"
                                       name="txtPurchasePrice" placeholder="Purchase Price"
                                       value="${requestScope.productDetails.purchasePrice}" required>
                                <label for="purchasePrice">Purchase Price</label>
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

                            <div class="form-floating mb-3 stripDetails" style="display:none;">
                                <input type="number" class="form-control" min="1" id="unitsPerStrip"
                                       name="unitsPerStrip" placeholder="Units Per Strip"
                                       value="${p != null ? (p.unitsPerStrip > 0 ? p.unitsPerStrip : '') : ''}"
                                       data-strip-required="true" disabled>
                                <label for="unitsPerStrip">Units Per Strip</label>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-success me-2">Save Product</button>
                        <button type="reset" class="btn btn-secondary">Reset</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- /MAIN CONTENT -->

<!-- Shared JS -->
<script src="assets/js/app.js"></script>

<c:if test="${not empty requestScope.productDetails}">
    <script>
        // Ask shared module to show edit form when server provided productDetails
        document.addEventListener('DOMContentLoaded', function () {
            PMS.showForm('edit');
        });
    </script>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>
