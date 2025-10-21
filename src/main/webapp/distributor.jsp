<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<c:if test="${empty sessionScope.username}">
    <c:redirect url="index.jsp"/>
    <c:remove var="_stop"/>
</c:if>

<c:if test="${requestScope.distributorList == null}">
    <c:redirect url="DistributorServlet"/>
</c:if>

<!-- dashboard url via servlet to ensure counts are populated -->
<c:url var="dashboardUrl" value="/DashboardServlet"/>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Distributor</title>

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
    <c:url var="logoutUrl" value="/LogoutServlet" />

</head>
<body data-page="distributor">

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
                        <img src="${profilePicUrl}" alt="Profile" width="32" height="32" class="rounded-circle">
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
        <a href="DashboardServlet" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-decoration-none text-dark">
            <img src="${iconUrl}" alt="Logo" width="40" height="40"
                 style="border-radius: 8px;">
            <span class="fs-6 ms-2">Mahadev Medical Store</span>
        </a>
    </b>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="DashboardServlet" class="nav-link">
                <i class="fas fa-tachometer-alt me-2"></i> Dashboard</a>
        </li>
        <li>
            <a href="ProductServlet" class="nav-link">
                <i class="fas fa-pills me-2"></i> Product
            </a>
        </li>
        <li>
            <a href="DistributorServlet" class="nav-link active" aria-current="page"><i class="fas fa-truck me-2"></i>Distributor
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
                        <li class="breadcrumb-item active" aria-current="page">Distributor</li>
                    </ol>
                </nav>
            </div>
            <div class="col-md-4 col-12 text-md-end">
                <button class="btn btn-outline-success" id="addDistributor" data-action="show-form" data-mode="add">
                    <i class="fas fa-truck me-2"></i>Add Distributor
                </button>
            </div>
        </div>

        <div>
            <c:choose>
                <c:when test="${empty distributorList}">
                    <div id="noDistributorAvailable">
                        <h2 style="margin-bottom: 10px; color: #4CAF50;">No Distributor Available</h2>
                        <p style="color: #777;">You have not added any distributor yet. Start by adding new distributor
                            to manage your inventory efficiently.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="distributorTable">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered shadow-sm rounded">
                            <thead class="table-light">
                            <tr>
                                <th>Distributor Name</th>
                                <th>Contact Person</th>
                                <th>Contact Number</th>
                                <th>Address</th>
                                <th>Edit</th>
                                <th>Delete</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="distributor" items="${distributorList}">
                                <tr>
                                    <td>${distributor.distributorName}</td>
                                    <td>${distributor.contactPerson}</td>
                                    <td>${distributor.contactNumber}</td>
                                    <td>${distributor.address}</td>
                                    <td><a href="DistributorServlet?editId=${distributor.distributorId}" title="Edit"><i
                                            class="fas fa-edit"></i></a></td>
                                    <td><a href="DistributorServlet?deleteId=${distributor.distributorId}"
                                           data-action="delete"
                                           data-confirm="Are you sure you want to delete this distributor?"
                                           title="Delete"><i class="fas fa-trash-alt"></i></a></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        </div>

                        <div class="pagination-wrapper">
                            <c:if test="${noOfPages > 1}">
                                <c:forEach begin="1" end="${noOfPages}" var="i">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="btn btn-success btn-sm">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url var="pageUrl" value="DistributorServlet">
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

            <div id="distributorForm" style="display:none;">
                <h5 class="card-title mb-3" id="formTitle">Add New Distributor</h5>
                <form action="DistributorServlet" method="post">
                    <input type="hidden" id="distributorId" name="distributorId"
                           value="${requestScope.distributorDetails.distributorId}">
                    <input type="hidden" name="actionType"
                           value="${requestScope.distributorDetails != null ? 'update' : 'add'}">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="distributorName" name="txtDistributorName"
                                       placeholder="Distributor Name"
                                       value="${requestScope.distributorDetails.distributorName}" required>
                                <label for="distributorName">Distributor Name</label>
                            </div>
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="contactPerson" name="txtContactPerson"
                                       placeholder="Contact Person"
                                       value="${requestScope.distributorDetails.contactPerson}">
                                <label for="contactPerson">Contact Person</label>
                            </div>
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="contactNumber" name="txtContactNumber"
                                       placeholder="Contact Number"
                                       value="${requestScope.distributorDetails.contactNumber}" required>
                                <label for="contactNumber">Contact Number</label>
                            </div>
                            <div class="form-floating mb-3">
                                <input type="email" class="form-control" id="email" name="txtEmail"
                                       placeholder="Email Address" value="${requestScope.distributorDetails.email}">
                                <label for="email">Email Address</label>
                            </div>
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="address" name="txtAddress"
                                       placeholder="Address" value="${requestScope.distributorDetails.address}"
                                       required>
                                <label for="address">Address</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3"><input type="text" class="form-control" id="city"
                                                                   name="txtCity" placeholder="City"
                                                                   value="${requestScope.distributorDetails.city}"><label
                                    for="city">City</label></div>
                            <div class="form-floating mb-3"><input type="text" class="form-control" id="state"
                                                                   name="txtState" placeholder="State"
                                                                   value="${requestScope.distributorDetails.state}"><label
                                    for="state">State</label></div>
                            <div class="form-floating mb-3"><input type="text" class="form-control" id="pinCode"
                                                                   name="txtPinCode" placeholder="Pin Code"
                                                                   value="${requestScope.distributorDetails.pincode}"><label
                                    for="pinCode">Pin Code</label></div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-success me-2">Save Distributor</button>
                        <button type="reset" class="btn btn-secondary" id="btnReset">Reset</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- /MAIN CONTENT -->

<!-- Shared JS -->
<script src="assets/js/app.js"></script>
<c:if test="${not empty requestScope.distributorDetails}">
    <script>document.addEventListener('DOMContentLoaded', function () {
        PMS.showForm('edit');
    });</script>
</c:if>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>