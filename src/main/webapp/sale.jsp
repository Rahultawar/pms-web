<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<c:set var="saleDetails" value="${requestScope.saleDetails}"/>

<c:if test="${empty sessionScope.username}">
    <c:redirect url="index.jsp"/>
    <c:remove var="_stop"/>
</c:if>

<c:if test="${requestScope.saleList == null}">
    <c:redirect url="SaleServlet"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sale</title>
    <c:url var="bootstrapCss" value="/assets/css/bootstrap.min.css"/>
    <c:url var="fontAwesomeCss" value="/assets/css/fontawesome.min.css"/>
    <c:url var="themeCss" value="/assets/css/theme.css"/>
    <c:url var="bootstrapJs" value="/assets/js/bootstrap.bundle.min.js"/>
    <link rel="stylesheet" href="${bootstrapCss}"/>
    <link rel="stylesheet" href="${fontAwesomeCss}"/>
    <link rel="stylesheet" href="${themeCss}"/>
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
<body data-page="sale">

<!-- SIDEBAR -->
<div id="sidebar" class="d-flex flex-column flex-shrink-0 p-3">
    <b>
        <a href="DashboardServlet"
           class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-decoration-none text-dark">
            <img src="${iconUrl}" alt="Logo" width="40" height="40"
                 style="border-radius: 8px;">
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
            <a href="DistributorServlet" class="nav-link">
                <i class="fas fa-truck me-2"></i> Distributor
            </a>
        </li>
        <li>
            <a href="SaleServlet" class="nav-link active" aria-current="page">
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
                        <li class="breadcrumb-item active" aria-current="page">Sale</li>
                    </ol>
                </nav>
            </div>
            <div class="col-md-4 col-12 text-md-end">
                <button class="btn btn-outline-success" id="addSale" data-action="show-form" data-mode="add">
                    <i class="fas fa-shopping-cart me-2"></i>Add Sale
                </button>
            </div>
        </div>

        <div>
            <c:choose>
                <c:when test="${empty saleList}">
                    <div id="noSaleAvailable">
                        <h2 style="margin-bottom: 10px; color: #4CAF50;">No Sale Available</h2>
                        <p style="color: #777;">You have not added any sale yet. Start by adding new sale
                            to manage your inventory efficiently.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="saleTable">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered shadow-sm rounded">
                            <thead class="table-light">
                            <tr>
                                <th>Product</th>
                                <th>Distributor</th>
                                <th>Quantity</th>
                                <th>Customer Name</th>
                                <th>Mobile Number</th>
                                <th>Total Amount</th>
                                <th>Amount Given</th>
                                <th>Status</th>
                                <th>Payment Method</th>
                                <th>Edit</th>
                                <th>Delete</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="sale" items="${saleList}">
                                <c:set var="productName" value=""/>
                                <c:set var="distributorName" value=""/>
                                <c:forEach var="product" items="${productList}">
                                    <c:if test="${product.productId == sale.productId}">
                                        <c:set var="productName" value="${product.productName}"/>
                                    </c:if>
                                </c:forEach>
                                <c:forEach var="distributor" items="${distributorList}">
                                    <c:if test="${distributor.distributorId == sale.distributorId}">
                                        <c:set var="distributorName" value="${distributor.distributorName}"/>
                                    </c:if>
                                </c:forEach>
                                <tr>
                                    <td><c:out value="${productName != '' ? productName : sale.productId}"/></td>
                                    <td><c:out value="${distributorName}"/></td>
                                    <td>${sale.quantity}</td>
                                    <td>${sale.customerName}</td>
                                    <td>${sale.mobileNumber}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${sale.totalAmount != null}">${sale.totalAmount}</c:when>
                                            <c:otherwise>
                                                <c:out value="${sale.computeExpectedTotal()}"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${sale.amountGiven}</td>
                                    <td>${sale.status}</td>
                                    <td>${sale.paymentMethod}</td>
                                    <td><a href="SaleServlet?editId=${sale.saleId}" title="Edit"><i
                                            class="fas fa-edit"></i></a></td>
                                    <td><a href="SaleServlet?deleteId=${sale.saleId}"
                                           data-action="delete"
                                           data-confirm="Are you sure you want to delete this sale?"
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
                                            <c:url var="pageUrl" value="SaleServlet">
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

            <div id="saleForm" style="display:none;">
                <h5 class="card-title mb-3" id="formTitle">Add New Sale</h5>
                <form action="SaleServlet" method="post" id="saleEntryForm">
              <input type="hidden" id="saleId" name="saleId"
                  value="${saleDetails.saleId}">
              <input type="hidden" id="saleUuid" name="saleUuid"
                  value="${saleDetails.saleUuid}">
              <input type="hidden" name="actionType"
                  value="${saleDetails != null ? 'update' : 'add'}">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <select name="selProduct" id="selProduct" class="form-control" required>
                                    <option value="" disabled <c:if test="${saleDetails == null}">selected</c:if>>Select Product</option>
                                    <c:forEach var="product" items="${productList}">
                                        <option value="${product.productId}"
                                                data-unit="${product.unit}"
                                                data-units-per-strip="${product.unitsPerStrip}"
                                                data-selling-price="${product.sellingPrice}"
                                                data-distributor-id="${product.distributorId}"
                                            <c:if test="${saleDetails != null && saleDetails.productId == product.productId}">selected</c:if>>
                                            ${product.productName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <label for="product">Product</label>
                            </div>

                            <div class="form-floating mb-3">
                                <select name="selDistributor" id="selDistributor" class="form-control" required>
                                    <option value="" disabled <c:if test="${saleDetails == null || saleDetails.distributorId == null}">selected</c:if>>Select Distributor</option>
                                    <c:forEach var="distributor" items="${distributorList}">
                                        <option value="${distributor.distributorId}"
                                            <c:if test="${saleDetails != null && saleDetails.distributorId == distributor.distributorId}">selected</c:if>>
                                            ${distributor.distributorName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <label for="distributor">Distributor</label>
                            </div>

                            <div class="form-floating mb-3">
                    <input type="number" class="form-control" id="quantity" name="txtQuantity"
                                       placeholder="Quantity"
                        value="${saleDetails.quantity}" min="1" required>
                                <label for="quantity">Quantity</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="customerName" name="txtCustomerName"
                                       placeholder="Customer Name"
                                       value="${saleDetails.customerName}">
                                <label for="customerName">Customer Name</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="mobileNumber" name="txtMobileNumber"
                                       placeholder="Mobile Number"
                                       value="${saleDetails.mobileNumber}">
                                <label for="mobileNumber">Mobile Number</label>
                            </div>

                            <div class="form-floating mb-3">
                    <input type="number" class="form-control" id="amountGiven" name="txtAmountGiven"
                        placeholder="Amount Given By Customer"
                        value="${saleDetails.amountGiven}" step="0.01" min="0">
                                <label for="amountGiven">Amount Given By Customer</label>
                            </div>

                        </div>
                        <div class="col-md-6">

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="unit"
                                       name="txtUnit" placeholder="Unit"
                                       value="${saleDetails.unit}" readonly><label
                                    for="unit">Unit</label></div>

                            <div class="form-floating mb-3">
                    <input type="number" class="form-control" id="unitPrice" step="0.01" min="0"
                        name="txtUnitPrice" placeholder="Unit Price"
                        value="${saleDetails.unitPrice}"><label
                                    for="unitPrice">Unit Price</label></div>

                            <div class="form-floating mb-3">
                                <input type="number" class="form-control" id="unitPerStrip"
                                       name="txtUnitPerStrip" placeholder="Unit Per Strip"
                                                    value="${saleDetails.unitsPerStrip}" readonly><label
                                    for="unitPerStrip">Unit Per Strip</label></div>

                            <div class="form-floating mb-3">
                                <select name="selPaymentMethod" id="selPaymentMethod" class="form-control" required>
                                    <option value="" disabled <c:if test="${saleDetails == null || empty saleDetails.paymentMethod}">selected</c:if>>Select Payment Method</option>
                                    <c:set var="paymentOptions" value="Cash,Credit Card,Debit Card,UPI,Net Banking"/>
                                    <c:forTokens items="${paymentOptions}" delims="," var="method">
                                        <option value="${method}"
                                            <c:if test="${saleDetails != null && method == saleDetails.paymentMethod}">selected</c:if>>
                                            ${method}
                                        </option>
                                    </c:forTokens>
                                </select>
                                <label for="paymentMethod">Payment Method</label>
                            </div>

                            <div class="form-floating mb-3">
                    <input type="number" class="form-control" id="discountAmount"
                        name="txtDiscountAmount" placeholder="Discount Amount"
                        value="${saleDetails.discountAmount}" step="0.01" min="0"><label
                                    for="discountAmount">Discount Amount</label></div>

                            <div class="form-floating mb-3">
                                <input type="number" class="form-control" id="totalAmount"
                                       name="txtTotalAmount" placeholder="Total Amount"
                                       value="${saleDetails.totalAmount}" readonly><label
                                    for="totalAmount">Total Amount</label></div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-success me-2">Save Sale</button>
                        <button type="reset" class="btn btn-secondary" id="btnReset">Reset</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
<script src="assets/js/app.js"></script>
<c:if test="${not empty saleDetails}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            if (window.PMS && typeof PMS.showForm === 'function') {
                PMS.showForm('edit');
            }
        });
    </script>
</c:if>
<script src="${bootstrapJs}"></script>
</html>
