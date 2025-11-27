<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!-- Session and required data checks using JSTL/EL -->
<c:if test="${empty sessionScope.username}">
    <c:redirect url="index.jsp"/>
    <c:remove var="_stop"/>
</c:if>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Import/Export</title>
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
<!-- Import/Export Page Body -->
<body data-page="import-export">

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
            <a href="ProductServlet" class="nav-link">
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
                            <a href="ImportExportServlet" class="nav-link active" aria-current="page">
                                <i class="fas fa-file-csv me-2"></i> Import/Export
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
            <div class="col-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0" id="breadcrumbItem">
                        <li class="breadcrumb-item"><a href="DashboardServlet">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Import/Export</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Success/Error Message Display -->
        <c:if test="${not empty requestScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <span><c:out value="${requestScope.successMessage}"/></span>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <span><c:out value="${requestScope.errorMessage}"/></span>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row">
            <!-- Import Section -->
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0"><i class="fas fa-upload me-2"></i>Import Data</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted">Import products or distributors data from CSV files.</p>

                        <form action="ImportExportServlet" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="actionType" value="upload">

                            <div class="mb-3">
                                <label for="importType" class="form-label">Select Import Type</label>
                                <select class="form-control" id="importType" name="importType" required>
                                    <option value="">Choose what to import</option>
                                    <option value="products">Products</option>
                                    <option value="distributors">Distributors</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="csvFile" class="form-label">CSV File</label>
                                <input type="file" class="form-control" id="csvFile" name="csvFile"
                                       accept=".csv" required>
                                <div class="form-text">Select a CSV file to import data.</div>
                            </div>

                            <div id="formatInstructions" class="mb-3" style="display: none;">
                                <div class="alert alert-info">
                                    <h6 class="alert-heading">CSV Format Instructions</h6>
                                    <div id="productsFormat">
                                        <p><strong>Products CSV should have these columns in order:</strong></p>
                                        <small>
                                            productName, category, manufacturer, batchNumber, strength, location, distributorId, manufacturingDate, expiryDate, quantity, subQuantity, reorderLevel, purchasingPrice, sellingPrice, unit
                                        </small>
                                    </div>
                                    <div id="distributorsFormat" style="display: none;">
                                        <p><strong>Distributors CSV should have these columns in order:</strong></p>
                                        <small>
                                            distributorName, contactPerson, email, phone, address, city, state, pinCode
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-upload me-2"></i>Import Data
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Export Section -->
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0"><i class="fas fa-download me-2"></i>Download Templates</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted">Download CSV templates to prepare your data for import.</p>

                        <div class="d-grid gap-2">
                            <a href="ImportExportServlet?action=downloadTemplate&type=products"
                               class="btn btn-outline-success">
                                <i class="fas fa-file-csv me-2"></i>Download Products Template
                            </a>
                            <a href="ImportExportServlet?action=downloadTemplate&type=distributors"
                               class="btn btn-outline-success">
                                <i class="fas fa-file-csv me-2"></i>Download Distributors Template
                            </a>
                        </div>

                        <hr>
                        <h6 class="text-muted">Instructions</h6>
                        <ol class="small text-muted">
                            <li>Download the appropriate template CSV file</li>
                            <li>Open it in Excel or any CSV editor</li>
                            <li>Add your data following the column order (don't change column headers)</li>
                            <li>Save the file as CSV</li>
                            <li>Upload the file using the Import section</li>
                        </ol>

                        <div class="alert alert-info mt-3">
                            <strong>Note:</strong> For products, you can use either distributor ID or distributor name in the distributorId column. Distributor names will be automatically matched to existing distributors.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sample Data Section -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0"><i class="fas fa-info-circle me-2"></i>Sample Data Formats</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- Products Sample -->
                            <div class="col-lg-6 mb-3">
                                <h6 class="text-primary"><i class="fas fa-pills me-2"></i>Products CSV Format</h6>
                                <div class="table-responsive">
                                    <table class="table table-sm table-striped">
                                        <thead class="table-light">
                                        <tr>
                                            <th>Column</th>
                                            <th>Sample Value</th>
                                            <th>Notes</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr><td>productName</td><td>Paracetamol 500mg</td><td>Required</td></tr>
                                        <tr><td>category</td><td>Analgesic</td><td>Required</td></tr>
                                        <tr><td>manufacturer</td><td>ABC Pharma</td><td>Required</td></tr>
                                        <tr><td>batchNumber</td><td>BATCH2025</td><td>Required, unique</td></tr>
                                        <tr><td>strength</td><td>500mg</td><td>Required</td></tr>
                                        <tr><td>location</td><td>Rack A1</td><td>Optional</td></tr>
                                        <tr><td>distributorId</td><td>ABC Distributors</td><td>ID number or Name</td></tr>
                                        <tr><td>manufacturingDate</td><td>2025-01-01</td><td>YYYY-MM-DD, MM/DD/YYYY, DD/MM/YYYY, etc.</td></tr>
                                        <tr><td>expiryDate</td><td>2026-01-01</td><td>YYYY-MM-DD, MM/DD/YYYY, DD/MM/YYYY, etc.</td></tr>
                                        <tr><td>quantity</td><td>100</td><td>Integer</td></tr>
                                        <tr><td>subQuantity</td><td>10</td><td>Optional, integer</td></tr>
                                        <tr><td>reorderLevel</td><td>20</td><td>Integer</td></tr>
                                        <tr><td>purchasingPrice</td><td>5.50</td><td>Decimal</td></tr>
                                        <tr><td>sellingPrice</td><td>7.25</td><td>Decimal</td></tr>
                                        <tr><td>unit</td><td>strip</td><td>strip/bottle/etc</td></tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Distributors Sample -->
                            <div class="col-lg-6 mb-3">
                                <h6 class="text-primary"><i class="fas fa-truck me-2"></i>Distributors CSV Format</h6>
                                <div class="table-responsive">
                                    <table class="table table-sm table-striped">
                                        <thead class="table-light">
                                        <tr>
                                            <th>Column</th>
                                            <th>Sample Value</th>
                                            <th>Notes</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr><td>distributorName</td><td>ABC Pharma Corp</td><td>Required, unique</td></tr>
                                        <tr><td>contactPerson</td><td>John Smith</td><td>Optional</td></tr>
                                        <tr><td>email</td><td>john@abc.com</td><td>Required</td></tr>
                                        <tr><td>phone</td><td>9876543210</td><td>Required, 10 digits</td></tr>
                                        <tr><td>address</td><td>123 Main Street</td><td>Optional</td></tr>
                                        <tr><td>city</td><td>Mumbai</td><td>Optional</td></tr>
                                        <tr><td>state</td><td>Maharashtra</td><td>Optional</td></tr>
                                        <tr><td>pinCode</td><td>400001</td><td>Optional</td></tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<!-- /MAIN CONTENT -->

</div>

<!-- Shared JS -->
<script src="${appJs}"></script>

<script src="${bootstrapJs}"></script>

<script>
document.getElementById('importType').addEventListener('change', function() {
    var selectedType = this.value;
    var instructions = document.getElementById('formatInstructions');
    var productsFormat = document.getElementById('productsFormat');
    var distributorsFormat = document.getElementById('distributorsFormat');

    if (selectedType) {
        instructions.style.display = 'block';
        if (selectedType === 'products') {
            productsFormat.style.display = 'block';
            distributorsFormat.style.display = 'none';
        } else if (selectedType === 'distributors') {
            productsFormat.style.display = 'none';
            distributorsFormat.style.display = 'block';
        }
    } else {
        instructions.style.display = 'none';
    }
});
</script>

</body>
</html>
