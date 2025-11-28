<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            <title>Dashboard - Mahadev Medical Store</title>
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
            <c:url var="profilePicUrl" value="/assets/images/ProfilePic.jpg" />
            <c:url var="logoutUrl" value="/LogoutServlet" />

        </head>

<body data-page="dashboard">

            <div class="app-shell">
                <!-- SIDEBAR -->
                <jsp:include page="sidebar.jsp">
                    <jsp:param name="activePage" value="dashboard" />
                </jsp:include>
                <!-- /SIDEBAR -->

                <!-- MAIN CONTENT -->
                <main id="content-wrapper" class="flex-fill">
                    <div class="container-fluid">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-4">
                                <li class="breadcrumb-item"><a href="DashboardServlet">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Dashboard</li>
                            </ol>
                        </nav>

                        <div class="row">
                            <!-- TOTAL SALE CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-blue">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-dollar-sign stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Total Sales</h6>
                                        <h2 class="stat-value" id="totalSaleCount">0</h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-success">
                                                <i class="fas fa-arrow-up"></i> 5% from last week
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /TOTAL SALE CARD -->

                            <!-- TOTAL PRODUCTS CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-green">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-pills stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Total Products</h6>
                                        <h2 class="stat-value" id="countProduct">0</h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-info">
                                                <i class="fas fa-box"></i> In inventory
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!--TOTAL DISTRIBUTOR CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-orange">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-truck stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Total Distributors</h6>
                                        <h2 class="stat-value" id="countDistributor">0</h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-warning">
                                                <i class="fas fa-handshake"></i> Active partners
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /TOTAL DISTRIBUTOR CARD-->

                            <!-- TOTAL REVENUE CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-red">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-chart-line stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Total Revenue</h6>
                                        <h2 class="stat-value" id="totalRevenue">₹0</h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-danger">
                                                <i class="fas fa-coins"></i> This month
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /TOTAL REVENUE CARD -->
                        </div>

                        <!-- Charts Row -->
                        <div class="row mt-4">
                            <div class="col-md-6 mb-4">
                                <div class="chart-container">
                                    <h5 class="mb-3"><i class="fas fa-chart-line me-2 text-gradient"></i>Sales Trend
                                    </h5>
                                    <canvas id="salesChart" style="max-height: 300px;"></canvas>
                                </div>
                            </div>

                            <div class="col-md-6 mb-4">
                                <div class="chart-container">
                                    <h5 class="mb-3"><i class="fas fa-chart-pie me-2 text-gradient"></i>Product
                                        Categories</h5>
                                    <canvas id="productChart" style="max-height: 300px;"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="mb-3"><i class="fas fa-bolt me-2 text-gradient"></i>Quick Actions
                                        </h5>
                                        <div class="row">
                                            <div class="col-md-3 mb-2">
                                                <a href="ProductServlet" class="btn btn-outline-success w-100">
                                                    <i class="fas fa-plus-circle me-2"></i>Add Product
                                                </a>
                                            </div>
                                            <div class="col-md-3 mb-2">
                                                <a href="DistributorServlet" class="btn btn-outline-success w-100">
                                                    <i class="fas fa-truck me-2"></i>Add Distributor
                                                </a>
                                            </div>
                                            <div class="col-md-3 mb-2">
                                                <a href="SaleServlet" class="btn btn-outline-success w-100">
                                                    <i class="fas fa-shopping-cart me-2"></i>New Sale
                                                </a>
                                            </div>
                                            <div class="col-md-3 mb-2">
                                                <a href="ProductServlet" class="btn btn-outline-success w-100">
                                                    <i class="fas fa-box-open me-2"></i>View Inventory
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /MAIN CONTENT -->
                </main>

                <script src="${appJs}"></script>
                <script>
                    // Initialize Charts
                    document.addEventListener('DOMContentLoaded', function () {
                        const saleCountVal = Number('${saleCount}') || 0;
                        const productCountVal = Number('${productCount}') || 0;
                        const distributorCountVal = Number('${distributorCount}') || 0;
                        const hasChartJs = typeof Chart !== 'undefined';
                        // Sales Chart
                        const salesCtx = document.getElementById('salesChart');
                        if (hasChartJs && salesCtx) {
                            new Chart(salesCtx, {
                                type: 'line',
                                data: {
                                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                                    datasets: [{
                                        label: 'Daily Sales',
                                        data: [12, 19, 15, 25, 22, 30, 28],
                                        borderColor: '#4caf50',
                                        backgroundColor: 'rgba(76, 175, 80, 0.1)',
                                        tension: 0.4,
                                        fill: true
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: true,
                                    plugins: {
                                        legend: {
                                            display: false
                                        }
                                    },
                                    scales: {
                                        y: {
                                            beginAtZero: true
                                        }
                                    }
                                }
                            });
                        }

                        // Product Chart
                        const productCtx = document.getElementById('productChart');
                        if (hasChartJs && productCtx) {
                            new Chart(productCtx, {
                                type: 'doughnut',
                                data: {
                                    labels: ['Analgesic', 'Antibiotics', 'Vitamins', 'Cardiac', 'Others'],
                                    datasets: [{
                                        data: [30, 25, 20, 15, 10],
                                        backgroundColor: [
                                            '#4caf50',
                                            '#2196f3',
                                            '#ff9800',
                                            '#f44336',
                                            '#9c27b0'
                                        ]
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: true,
                                    plugins: {
                                        legend: {
                                            position: 'bottom'
                                        }
                                    }
                                }
                            });
                        }

                        // Animate counters
                        animateValue('totalRevenue', 0, 45670, 2000);
                        animateValue('totalSaleCount', 0, saleCountVal, 2000);
                        animateValue('countProduct', 0, productCountVal, 2000);
                        animateValue('countDistributor', 0, distributorCountVal, 2000);

                    });

                    function animateValue(id, start, end, duration, prefix = '') {
                        const obj = document.getElementById(id);
                        if (!obj) return;

                        const range = end - start;
                        const increment = range / (duration / 16);
                        let current = start;

                        const timer = setInterval(() => {
                            current += increment;
                            if (current >= end) {
                                obj.textContent = prefix + Math.round(end);
                                clearInterval(timer);
                            } else {
                                obj.textContent = prefix + Math.round(current);
                            }
                        }, 16);
                    }
                </script>
                <script src="${bootstrapJs}"></script>
            </div>
        </body>

        </html>
