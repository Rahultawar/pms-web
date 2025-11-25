<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page isELIgnored="false" %>

            <c:if test="${empty sessionScope.username}">
                <c:redirect url="index.jsp" />
                <c:remove var="_stop" />
            </c:if>

            <c:if test="${requestScope.distributorList == null}">
                <c:redirect url="DistributorServlet" />
            </c:if>

            <c:url var="dashboardUrl" value="/DashboardServlet" />

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Distributor</title>

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
                <c:url var="noAnimationsUrl" value="/assets/css/no-animations.css"/>
                <link rel="stylesheet" href="${noAnimationsUrl}"/>
                <c:url var="iconUrl" value="/assets/images/logo-modern.svg" />
                <c:url var="faviconUrl" value="/assets/images/favicon.svg" />
                <link rel="icon" href="${faviconUrl}" type="image/svg+xml">
                <c:url var="profilePicUrl" value="/assets/images/ProfilePic.jpg" />
                <c:url var="logoutUrl" value="/LogoutServlet" />

            </head>

<body data-page="distributor">

                <div class="app-shell">
                <!-- SIDEBAR -->
                <aside id="sidebar" class="d-flex flex-column flex-shrink-0 p-3">
                    <b>
                        <a href="DashboardServlet"
                            class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-decoration-none text-dark">
                            <img src="${iconUrl}" alt="Logo" width="40" height="40" style="border-radius: 8px;">
                            <span class="fs-6 ms-2">${sessionScope.medicalStoreName != null ? sessionScope.medicalStoreName : 'Medical Store'}</span>
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
                            <a href="DistributorServlet" class="nav-link active" aria-current="page"><i
                                    class="fas fa-truck me-2"></i>Distributor
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
                                        <li class="breadcrumb-item active" aria-current="page">Distributor</li>
                                    </ol>
                                </nav>
                            </div>
                            <div class="col-md-4 col-12 text-md-end">
                                <button class="btn btn-outline-success" id="addDistributor" data-action="show-form"
                                    data-mode="add">
                                    <i class="fas fa-truck me-2"></i>Add Distributor
                                </button>
                            </div>
                        </div>

                        <div>
                            <c:choose>
                                <c:when test="${empty distributorList}">
                                    <div id="noDistributorAvailable" class="empty-state">
                                        <h2 class="empty-state__title">No distributors available</h2>
                                        <p class="empty-state__subtitle">Add your partner details to keep supplier
                                            information close at hand.</p>
                                        <button class="btn btn-success" data-action="show-form" data-mode="add">
                                            <i class="fas fa-truck me-2"></i>Add Distributor
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div id="distributorTable" class="card table-card">
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle">
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
                                                            <td>${distributor.phone}</td>
                                                            <td>${distributor.address}</td>
                                                            <td><a href="DistributorServlet?editId=${distributor.distributorId}"
                                                                    title="Edit"><i class="fas fa-edit"></i></a></td>
                                                            <td><a href="DistributorServlet?deleteId=${distributor.distributorId}"
                                                                    data-action="delete"
                                                                    data-confirm="Are you sure you want to delete this distributor?"
                                                                    title="Delete"><i class="fas fa-trash-alt"></i></a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="pagination-wrapper card-footer bg-transparent">
                                            <c:if test="${noOfPages > 1}">
                                                <c:forEach begin="1" end="${noOfPages}" var="i">
                                                    <c:choose>
                                                        <c:when test="${i == currentPage}">
                                                            <span class="btn btn-success btn-sm">${i}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:url var="pageUrl" value="DistributorServlet">
                                                                <c:param name="page" value="${i}" />
                                                            </c:url>
                                                            <a href="${pageUrl}"
                                                                class="btn btn-outline-success btn-sm">${i}</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div id="distributorForm" class="card form-card">
                                <h5 class="card-title mb-3" id="formTitle">Add New Distributor</h5>
                                <form action="DistributorServlet" method="post">
                                    <input type="hidden" id="distributorId" name="distributorId"
                                        value="${requestScope.distributorDetails.distributorId}">
                                    <input type="hidden" name="actionType"
                                        value="${requestScope.distributorDetails != null ? 'update' : 'add'}">

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-floating mb-3">
                                                <input type="text" class="form-control" id="distributorName"
                                                    name="txtDistributorName" placeholder="Distributor Name"
                                                    value="${requestScope.distributorDetails.distributorName}" required>
                                                <label for="distributorName">Distributor Name</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input type="text" class="form-control" id="contactPerson"
                                                    name="txtContactPerson" placeholder="Contact Person"
                                                    value="${requestScope.distributorDetails.contactPerson}">
                                                <label for="contactPerson">Contact Person</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input type="text" class="form-control" id="phone"
                                                    name="txtPhone" placeholder="Phone Number"
                                                    value="${requestScope.distributorDetails.phone}" required 
                                                    maxlength="10" pattern="[0-9]{10}">
                                                <label for="phone">Phone Number</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input type="email" class="form-control" id="email" name="txtEmail"
                                                    placeholder="Email Address"
                                                    value="${requestScope.distributorDetails.email}">
                                                <label for="email">Email Address</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input type="text" class="form-control" id="address" name="txtAddress"
                                                    placeholder="Address"
                                                    value="${requestScope.distributorDetails.address}" required>
                                                <label for="address">Address</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-floating mb-3"><input type="text" class="form-control"
                                                    id="city" name="txtCity" placeholder="City"
                                                    value="${requestScope.distributorDetails.city}"><label
                                                    for="city">City</label></div>
                                            <div class="form-floating mb-3"><input type="text" class="form-control"
                                                    id="state" name="txtState" placeholder="State"
                                                    value="${requestScope.distributorDetails.state}"><label
                                                    for="state">State</label></div>
                                            <div class="form-floating mb-3"><input type="text" class="form-control"
                                                    id="pinCode" name="txtPinCode" placeholder="Pin Code"
                                                    value="${requestScope.distributorDetails.pinCode}"><label
                                                    for="pinCode">Pin Code</label></div>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-end">
                                        <button type="submit" class="btn btn-success me-2">Save Distributor</button>
                                        <button type="reset" class="btn btn-outline-secondary" id="btnReset">Reset</button>
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
                <c:if test="${not empty requestScope.distributorDetails}">
                    <script>document.addEventListener('DOMContentLoaded', function () {
                            PMS.showForm('edit');
                        });</script>
                </c:if>
                <script src="${bootstrapJs}"></script>
            </body>

            </html>
