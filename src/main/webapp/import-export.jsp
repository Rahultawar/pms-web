<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!-- SESSION AND REQUIRED DATA CHECKS USING JSTL/EL -->
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
<jsp:include page="sidebar.jsp">
    <jsp:param name="activePage" value="import-export" />
</jsp:include>
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
                                    <option value="customers">Customers</option>
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
                                    <div id="customersFormat" style="display: none;">
                                        <p><strong>Customers CSV should have these columns in order:</strong></p>
                                        <small>
                                            customerName, contactNumber, userId
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
                            <a href="ImportExportServlet?action=downloadTemplate&type=customers"
                               class="btn btn-outline-success">
                                <i class="fas fa-file-csv me-2"></i>Download Customers Template
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
    var customersFormat = document.getElementById('customersFormat');

    if (selectedType) {
        instructions.style.display = 'block';
        if (selectedType === 'products') {
            productsFormat.style.display = 'block';
            distributorsFormat.style.display = 'none';
            customersFormat.style.display = 'none';
        } else if (selectedType === 'distributors') {
            productsFormat.style.display = 'none';
            distributorsFormat.style.display = 'block';
            customersFormat.style.display = 'none';
        } else if (selectedType === 'customers') {
            productsFormat.style.display = 'none';
            distributorsFormat.style.display = 'none';
            customersFormat.style.display = 'block';
        }
    } else {
        instructions.style.display = 'none';
    }
});

// Format selector for sample data
document.addEventListener('DOMContentLoaded', function() {
    function updateFormatDisplay() {
        var selected = document.querySelector('input[name="formatSelector"]:checked');
        var value = selected ? selected.id : 'showProducts';

        var sections = document.querySelectorAll('.format-section');
        var container = document.querySelector('.sample-data');

        sections.forEach(function(section) {
            section.style.display = 'none';
            section.classList.remove('format-single');
            // Reset classes for when showing all
            section.classList.remove('col-12');
            if (!section.classList.contains('col-lg-4')) {
                section.classList.add('col-lg-4');
            }
            section.classList.add('mb-4');
        });

        if (value === 'showAll') {
            sections.forEach(function(section) {
                section.style.display = 'block';
                section.classList.add('col-lg-4');
                section.classList.remove('col-12');
            });
        } else {
            var targetClass = '';
            if (value === 'showProducts') {
                targetClass = 'format-products';
            } else if (value === 'showDistributors') {
                targetClass = 'format-distributors';
            } else if (value === 'showCustomers') {
                targetClass = 'format-customers';
            }

            var targetSection = document.querySelector('.' + targetClass);
            if (targetSection) {
                targetSection.style.display = 'block';
                targetSection.classList.add('format-single');
                targetSection.classList.add('col-12');
                targetSection.classList.add('mb-4');
            }
        }
    }

    // Initialize - show products by default
    updateFormatDisplay();

    // Add event listeners to radio buttons
    document.querySelectorAll('input[name="formatSelector"]').forEach(function(radio) {
        radio.addEventListener('change', updateFormatDisplay);
    });
});
</script>

</body>
</html>
