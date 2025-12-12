<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!-- Session and required data checks using JSTL/EL -->
<c:if test="${empty sessionScope.username}">
    <c:redirect url="index.jsp"/>
    <c:remove var="_stop"/>
</c:if>

<c:if test="${requestScope.customerList == null}">
    <c:redirect url="CustomerServlet"/>
</c:if>

<c:set var="c" value="${requestScope.customerDetails}"/>
<!-- URL for dashboard servlet (ensures correct context path) -->
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer</title>
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
<!-- Customer Management Page Body -->
<body data-page="customer">

<!-- Main Application Container -->
<div class="app-shell">
<!-- SIDEBAR -->
<jsp:include page="sidebar.jsp">
    <jsp:param name="activePage" value="customer" />
</jsp:include>
<!-- /SIDEBAR -->

<!-- MAIN CONTENT -->
<main id="content-wrapper" class="flex-fill">
    <div class="container-fluid">
        <div class="row align-items-center mb-3">
            <div class="col-md-6 col-12 mb-2 mb-md-0">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0" id="breadcrumbItem">
                        <li class="breadcrumb-item"><a href="DashboardServlet">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Customer</li>
                    </ol>
                </nav>
            </div>
            <div class="col-md-3 col-12 mb-2 mb-md-0">
                <div class="input-group">
                    <input type="search" class="form-control" id="searchBox" placeholder="Search customers...">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>
            </div>
            <div class="col-md-3 col-12 text-end">
                <button type="button" class="btn btn-outline-success" id="addCustomer"
                        data-action="show-form" data-mode="add">
                    <i class="fas fa-plus-circle me-2"></i>Add Customer
                </button>
            </div>
        </div>
        <!-- Error message display -->
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <span><c:out value="${requestScope.errorMessage}"/></span>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <div>
            <c:choose>
                <c:when test="${empty customerList}">
                    <div id="noCustomerAvailable" class="empty-state">
                        <h2 class="empty-state__title">No customers available</h2>
                        <p class="empty-state__subtitle">Add your first customer to start managing customer information.</p>
                        <button type="button" class="btn btn-success" data-action="show-form" data-mode="add">
                            <i class="fas fa-plus-circle me-2"></i>Add Customer
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="customerTable" class="card table-card">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>Customer Name</th>
                                <th>Contact Number</th>
                                <th>Email</th>
                                <th>Address</th>
                                <th>Edit</th>
                                <th>Delete</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="customer" items="${customerList}">
                                <tr>
                                    <td>${customer.customerName}</td>
                                    <td>${customer.contactNumber}</td>
                                    <td>${customer.email}</td>
                                    <td>${customer.address}</td>
                                    <td><a href="CustomerServlet?id=${customer.customerId}" title="Edit"><i
                                            class="fas fa-edit"></i></a></td>
                                    <td><a href="CustomerServlet?deleteId=${customer.customerId}"
                                         data-confirm="Are you sure you want to delete this customer?" title="Delete"><i class="fas fa-trash-alt"></i></a></td>
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
                                            <c:url var="pageUrl" value="CustomerServlet">
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

            <!-- Customer Add/Edit Form - Hidden by default, shown by JavaScript -->
            <div id="customerForm" class="card form-card" style="display: none;">
                <h5 class="card-title mb-3" id="formTitle">Add New Customer</h5>
                <form action="CustomerServlet" method="post">
                    <!-- Hidden fields for customer ID and action type -->
                    <input type="hidden" id="customerId" name="customerId"
                           value="${requestScope.customerDetails.customerId}">
                    <input type="hidden" name="actionType"
                           value="${requestScope.actionTypeValue != null ? requestScope.actionTypeValue : (requestScope.customerDetails != null ? 'update' : 'add')}">
                    <input type="hidden" name="txtUserId" value="${sessionScope.userId}">

                    <!-- Form fields -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="customerName" name="txtCustomerName"
                                       placeholder="Customer Name"
                                       value="${requestScope.customerDetails.customerName}" required>
                                <label for="customerName">Customer Name</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="contactNumber" name="txtContactNumber"
                                       placeholder="Contact Number"
                                       value="${requestScope.customerDetails.contactNumber}" required>
                                <label for="contactNumber">Contact Number</label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="email" class="form-control" id="email" name="txtEmail"
                                       placeholder="Email Address"
                                       value="${requestScope.customerDetails.email}">
                                <label for="email">Email Address</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <textarea class="form-control" id="address" name="txtAddress"
                                          placeholder="Address" rows="3">${requestScope.customerDetails.address}</textarea>
                                <label for="address">Address</label>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-success me-2">Save Customer</button>
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



<c:if test="${not empty requestScope.customerDetails and requestScope.actionTypeValue != 'view'}">
    <script>
        // Ask shared module to show edit form when server provided customerDetails
        document.addEventListener('DOMContentLoaded', function () {
            PMS.showForm('edit');
        });
    </script>
</c:if>

<c:if test="${not empty requestScope.errorMessage}">
    <script>
        // Show form when there are validation errors
        document.addEventListener('DOMContentLoaded', function () {
            var form = document.getElementById('customerForm');
            if (form) {
                form.style.display = 'block';
            }
            // Hide table if exists
            var table = document.getElementById('customerTable');
            if (table) {
                table.style.display = 'none';
            }
            // Hide empty state if exists
            var noBox = document.getElementById('noCustomerAvailable');
            if (noBox) {
                noBox.style.display = 'none';
            }
            // Hide search and add button
            var addBtn = document.querySelector('[data-action="show-form"][data-mode="add"]');
            if (addBtn) addBtn.style.display = 'none';
            var searchBox = document.getElementById('searchBox');
            if (searchBox) {
                var col = searchBox.closest('.col-md-3');
                if (col) col.style.display = 'none';
            }
        });
    </script>
</c:if>

<script src="${bootstrapJs}"></script>


</body>
</html>
