<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            <title>Notifications - Mahadev Medical Store</title>
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
            <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"
                crossorigin="anonymous"></script>

            <c:url var="styleUrl" value="/assets/css/style.css" />
            <link rel="stylesheet" href="${styleUrl}" />
            <c:url var="enhancedStyleUrl" value="/assets/css/enhanced-ui.css" />
            <link rel="stylesheet" href="${enhancedStyleUrl}" />
            <c:url var="noAnimationsUrl" value="/assets/css/no-animations.css"/>
            <link rel="stylesheet" href="${noAnimationsUrl}"/>

            <c:url var="iconUrl" value="/assets/images/logo-modern.svg" />
            <c:url var="faviconUrl" value="/assets/images/favicon.svg" />
            <link rel="icon" href="${faviconUrl}" type="image/svg+xml">

        </head>

<body data-page="notifications">

            <div class="app-shell">
                <!-- SIDEBAR -->
                <jsp:include page="sidebar.jsp">
                    <jsp:param name="activePage" value="notifications" />
                </jsp:include>
                <!-- /SIDEBAR -->

                <!-- MAIN CONTENT -->
                <main id="content-wrapper" class="flex-fill">
                    <div class="container-fluid">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-4">
                                <li class="breadcrumb-item"><a href="DashboardServlet">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Notifications</li>
                            </ol>
                        </nav>

                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h1 class="h2 mb-0">
                                <i class="fas fa-bell me-2 text-warning"></i>Notifications
                            </h1>
                            <c:if test="${not empty lowStockProducts or not empty expiringProducts}">
                                <span class="badge badge-danger fs-6">
                                    ${fn:length(lowStockProducts) + fn:length(expiringProducts)} Alerts
                                </span>
                            </c:if>
                        </div>

                        <!-- Notifications Content -->
                        <div class="row">
                            <div class="col-12">
                                <c:if test="${empty lowStockProducts and empty expiringProducts}">
                                    <div class="card">
                                        <div class="card-body text-center py-5">
                                            <i class="fas fa-check-circle fa-4x text-success mb-3"></i>
                                            <h3 class="text-success">All Clear!</h3>
                                            <p class="text-muted mb-0">No notifications at this time. All products are in good standing.</p>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty lowStockProducts}">
                                    <div class="card mb-4">
                                        <div class="card-header bg-danger text-white">
                                            <h5 class="mb-0">
                                                <i class="fas fa-exclamation-triangle me-2"></i>Low Stock Alerts
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="list-group list-group-flush">
                                                <c:forEach var="product" items="${lowStockProducts}" varStatus="status">
                                                    <div class="list-group-item d-flex justify-content-between align-items-center" id="low_stock_${status.index}">
                                                        <div>
                                                            <strong>${product.productName}</strong> is low stock
                                                            <small class="text-muted">(Current: ${product.quantity}, Reorder: ${product.reorderLevel})</small>
                                                        </div>
                                                        <button class="btn btn-sm btn-outline-danger" onclick="dismissNotification('low_stock_${status.index}')">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty expiringProducts}">
                                    <div class="card mb-4">
                                        <div class="card-header bg-warning">
                                            <h5 class="mb-0">
                                                <i class="fas fa-clock me-2"></i>Expiry Alerts
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="list-group list-group-flush">
                                                <c:forEach var="product" items="${expiringProducts}" varStatus="status">
                                                    <div class="list-group-item d-flex justify-content-between align-items-center" id="expiry_${status.index}">
                                                        <div>
                                                            <strong>${product.productName}</strong> is near expiry
                                                            <small class="text-muted">(Expires: <fmt:formatDate value="${product.expiryDate}" pattern="dd MMM yyyy"/>)</small>
                                                        </div>
                                                        <button class="btn btn-sm btn-outline-warning" onclick="dismissNotification('expiry_${status.index}')">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                            </div>
                        </div>

                    </div>
                    <!-- /MAIN CONTENT -->
                </main>

                <script src="${appJs}"></script>
                <script src="${bootstrapJs}"></script>
                <script>
                    function dismissNotification(notificationId) {
                        // Find the list-group-item that contains the button
                        const button = event.target.closest('button');
                        const listItem = button.closest('.list-group-item');
                        if (listItem) {
                            listItem.remove();
                        }
                    }
                </script>
            </div>
        </body>

        </html>
