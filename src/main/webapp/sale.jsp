<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!-- Session and required data checks using JSTL/EL -->
<c:if test="${empty sessionScope.username}">
    <c:redirect url="index.jsp" />
</c:if>

<c:if test="${requestScope.saleList == null}">
    <c:redirect url="SaleServlet" />
</c:if>

<c:set var="s" value="${requestScope.saleDetails}" />

<!doctype html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Sale</title>
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
    <c:url var="faviconUrl" value="/assets/images/favicon.svg" />
    <link rel="icon" href="${faviconUrl}" type="image/svg+xml">
</head>
<!-- Sale Management Page Body -->

<body data-page="sale">

    <!-- Main Application Container -->
    <div class="app-shell">
        <!-- SIDEBAR -->
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="sale" />
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
                                <li class="breadcrumb-item" id="saleBreadcrumbLink"><a href="SaleServlet">Sale</a></li>
                            </ol>
                        </nav>
                    </div>
                    <div class="col-md-3 col-12 mb-2 mb-md-0" id="searchContainer">
                        <div class="input-group">
                            <input type="search" class="form-control" id="searchBox" placeholder="Search sales...">
                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                        </div>
                    </div>
                    <div class="col-md-3 col-12 text-end">
                        <button class="btn btn-outline-success" id="addSale" data-action="show-form" data-mode="add">
                            <i class="fas fa-plus-circle me-2"></i>Add Sale
                        </button>
                    </div>
                </div>

                <!-- Error message display -->
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <span><c:out value="${requestScope.errorMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Success message display -->
                <c:if test="${not empty param.msg}">
                    <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <span><c:out value="${param.msg}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <div>
                <div>
                    <c:choose>
                        <c:when test="${empty saleList}">
                            <div id="noSaleAvailable" class="empty-state">
                                <h2 class="empty-state__title">No sales available</h2>
                                <p class="empty-state__subtitle">Add your first sale to start tracking your transactions.</p>
                                <button class="btn btn-success" data-action="show-form" data-mode="add">
                                    <i class="fas fa-plus-circle me-2"></i>Add Sale
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div id="saleTable" class="card table-card">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Product</th>
                                                <th>Distributor</th>
                                                <th>Customer</th>
                                                <th>Quantity</th>
                                                <th>Total Amount</th>
                                                <th>Amount Given</th>
                                                <th>Status</th>
                                                <th>Payment Method</th>
                                                <th>Sale Date</th>
                                                <th>Edit</th>
                                                <th>Delete</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="sale" items="${saleList}">
                                                <tr>
                                                    <td>${sale.productName}</td>
                                                    <td>${sale.distributorName}</td>
                                                    <td>${sale.customerName != null ? sale.customerName : 'N/A'}</td>
                                                    <td>${sale.quantity}${sale.subQuantity != null ? ' + '.concat(sale.subQuantity) : ''}</td>
                                                    <td>₹${sale.totalAmount}</td>
                                                    <td>₹${sale.amountGivenByCustomer}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${sale.status == 'paid'}">
                                                                <span class="badge bg-success">Paid</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning text-dark">Pending</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${sale.paymentMethod == 'CASH'}">Cash</c:when>
                                                            <c:when test="${sale.paymentMethod == 'UPI'}">UPI</c:when>
                                                            <c:when test="${sale.paymentMethod == 'CARD'}">Card</c:when>
                                                            <c:when test="${sale.paymentMethod == 'NETBANKING'}">Net Banking</c:when>
                                                            <c:otherwise>Other</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${sale.saleDate}</td>
                                                    <td><a href="SaleServlet?id=${sale.saleId}" title="Edit"><i class="fas fa-edit"></i></a></td>
                                                    <td><a href="SaleServlet?deleteId=${sale.saleId}" data-confirm="Are you sure you want to delete this sale?" title="Delete"><i class="fas fa-trash-alt"></i></a></td>
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
                                                    <c:url var="pageUrl" value="SaleServlet">
                                                        <c:param name="page" value="${i}" />
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

                    <!-- Sale Add/Edit Form - Hidden by default, shown by JavaScript -->
                    <div id="saleForm" class="card form-card">
                        <h5 class="card-title mb-3" id="formTitle">Add New Sale</h5>
                        <form action="SaleServlet" method="post" id="saleEntryForm">
                            <!-- Hidden fields for sale ID and action type -->
                            <input type="hidden" id="saleId" name="saleId" value="${s.saleId}">
                            <input type="hidden" name="actionType" value="${s != null ? 'update' : 'add'}">

                            <!-- Form fields organized in two columns for better layout -->
                            <div class="row">
                                                <!-- First Column -->
                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <select id="selProduct" name="selProduct" class="form-control" required <c:if test="${s != null}">disabled</c:if>>
                                            <option value="" disabled <c:if test="${s == null}">selected</c:if>>Select Product</option>
                                            <c:forEach var="product" items="${productList}">
                                                <option value="${product.productId}" 
                                                    data-price="${product.sellingPrice}" 
                                                    data-qty="${product.quantity}" 
                                                    data-subqty="${product.subQuantity}" 
                                                    data-dist="${product.distributorId}"
                                                    <c:if test="${s != null && s.productId == product.productId}">selected</c:if>>
                                                    ${product.productName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <label for="selProduct">Product Name</label>
                                        <c:if test="${s != null}">
                                            <input type="hidden" name="selProduct" value="${s.productId}">
                                        </c:if>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <select name="selDistributor" id="selDistributor" class="form-control" required <c:if test="${s != null}">disabled</c:if>>
                                            <option value="" disabled <c:if test="${s == null}">selected</c:if>>Select Distributor</option>
                                            <c:forEach var="distributor" items="${distributorList}">
                                                <option value="${distributor.distributorId}" 
                                                    <c:if test="${s != null && s.distributorId == distributor.distributorId}">selected</c:if>>
                                                    ${distributor.distributorName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <label for="selDistributor">Distributor Name</label>
                                        <c:if test="${s != null}">
                                            <input type="hidden" name="selDistributor" value="${s.distributorId}">
                                        </c:if>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input type="number" class="form-control" id="quantity" name="txtQuantity" 
                                            placeholder="Quantity" value="${s.quantity}" min="1" required>
                                        <label for="quantity">Quantity</label>
                                    </div>

                                    <div class="form-floating mb-3" id="subQuantityGroup">
                                        <input type="number" class="form-control" id="subQuantity" name="txtSubQuantity" 
                                            placeholder="Sub Quantity" value="${s.subQuantity}" min="0">
                                        <label for="subQuantity">Sub Quantity</label>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <select name="selCustomer" id="selCustomer" class="form-control">
                                            <option value="">Select Customer (Optional)</option>
                                            <c:forEach var="customer" items="${customerList}">
                                                <option value="${customer.customerId}" 
                                                    <c:if test="${s != null && s.customerId == customer.customerId}">selected</c:if>>
                                                    ${customer.customerName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <label for="selCustomer">Customer Name</label>
                                    </div>
                                </div>

                                <!-- Second Column -->
                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <select name="selPaymentMethod" id="selPaymentMethod" class="form-control" required>
                                            <option value="" disabled <c:if test="${s == null}">selected</c:if>>Select Payment Method</option>
                                            <option value="CASH" <c:if test="${s != null && s.paymentMethod == 'CASH'}">selected</c:if>>Cash</option>
                                            <option value="UPI" <c:if test="${s != null && s.paymentMethod == 'UPI'}">selected</c:if>>UPI</option>
                                            <option value="CARD" <c:if test="${s != null && s.paymentMethod == 'CARD'}">selected</c:if>>Card</option>
                                            <option value="NETBANKING" <c:if test="${s != null && s.paymentMethod == 'NETBANKING'}">selected</c:if>>Net Banking</option>
                                            <option value="OTHER" <c:if test="${s != null && s.paymentMethod == 'OTHER'}">selected</c:if>>Other</option>
                                        </select>
                                        <label for="selPaymentMethod">Payment Method</label>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input type="number" class="form-control" id="discount" name="txtDiscount" 
                                            placeholder="Discount %" value="${s.discount}" step="0.01" min="0" max="100">
                                        <label for="discount">Discount (%)</label>
                                        <small class="text-muted">Enter discount as percentage (0-100)</small>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input type="number" class="form-control" id="totalAmount" name="txtTotalAmount" 
                                            placeholder="Total Amount" value="${s.totalAmount}" readonly step="0.01">
                                        <label for="totalAmount">Total Amount (Auto-Calculated)</label>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input type="number" class="form-control" id="amountGivenByCustomer" 
                                            name="txtAmountGivenByCustomer" placeholder="Amount Given" 
                                            value="${s.amountGivenByCustomer}" step="0.01" min="0" required>
                                        <label for="amountGivenByCustomer">Amount Given By Customer</label>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <select name="selStatus" id="selStatus" class="form-control" required>
                                            <option value="" disabled <c:if test="${s == null}">selected</c:if>>Select Status</option>
                                            <option value="pending" <c:if test="${s != null && s.status == 'pending'}">selected</c:if>>Pending</option>
                                            <option value="paid" <c:if test="${s != null && s.status == 'paid'}">selected</c:if>>Paid</option>
                                        </select>
                                        <label for="selStatus">Payment Status</label>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end mt-3">
                                <button type="submit" class="btn btn-success me-2">
                                    <i class="fas fa-save me-2"></i>Save Sale
                                </button>
                                <button type="button" class="btn btn-secondary" id="btnCancel" data-action="hide-form">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
        <!-- /MAIN CONTENT -->
    </div>

    <script src="${appJs}"></script>
    <script src="${bootstrapJs}"></script>

    <!-- Auto-show form if editing -->
    <c:if test="${not empty s}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                if (window.PMS && typeof PMS.showForm === 'function') {
                    PMS.showForm('edit');
                }
            });
        </script>
    </c:if>
    <!-- Auto-show form if editing -->
    <c:if test="${not empty s}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                if (window.PMS && typeof PMS.showForm === 'function') {
                    PMS.showForm('edit');
                }
            });
        </script>
    </c:if>

    <!-- Sale form JavaScript for auto-calculation and smart distributor selection -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const productSelect = document.getElementById('selProduct');
            const distributorSelect = document.getElementById('selDistributor');
            const quantityInput = document.getElementById('quantity');
            const subQuantityInput = document.getElementById('subQuantity');
            const subQuantityGroup = document.getElementById('subQuantityGroup');
            const discountInput = document.getElementById('discount');
            const totalAmountInput = document.getElementById('totalAmount');

            // Product change handler - auto-select distributor and handle subQuantity
            productSelect.addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                if (selectedOption.value) {
                    const distributorId = selectedOption.getAttribute('data-dist');
                    const maxQty = selectedOption.getAttribute('data-qty');
                    const maxSubQty = selectedOption.getAttribute('data-subqty');

                    // Auto-select distributor
                    distributorSelect.value = distributorId;
                    
                    // Disable distributor selection if product has only one distributor
                    distributorSelect.disabled = true;

                    // Set max quantity
                    quantityInput.max = maxQty;

                    // Handle subQuantity field visibility
                    if (maxSubQty === 'null' || !maxSubQty) {
                        subQuantityGroup.style.display = 'none';
                        subQuantityInput.value = '';
                        subQuantityInput.required = false;
                    } else {
                        subQuantityGroup.style.display = 'block';
                        subQuantityInput.max = maxSubQty;
                        subQuantityInput.required = false;
                    }

                    calculateTotal();
                }
            });

            // Calculate total amount
            function calculateTotal() {
                const selectedOption = productSelect.options[productSelect.selectedIndex];
                if (selectedOption.value) {
                    const price = parseFloat(selectedOption.getAttribute('data-price')) || 0;
                    const qty = parseInt(quantityInput.value) || 0;
                    const discountPercent = parseFloat(discountInput.value) || 0;

                    const subtotal = price * qty;
                    const discountAmount = (subtotal * discountPercent) / 100;
                    const total = subtotal - discountAmount;

                    totalAmountInput.value = total >= 0 ? total.toFixed(2) : '0.00';
                }
            }

            // Event listeners for calculation
            quantityInput.addEventListener('input', calculateTotal);
            discountInput.addEventListener('input', function() {
                const discount = parseFloat(this.value) || 0;
                if (discount < 0 || discount > 100) {
                    alert('Discount must be between 0 and 100');
                    this.value = discount < 0 ? 0 : 100;
                }
                calculateTotal();
            });

            // Trigger initial calculation if editing
            if (productSelect.value) {
                productSelect.dispatchEvent(new Event('change'));
            }
        });
    </script>

</body>
</html>