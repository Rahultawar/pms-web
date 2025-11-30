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
            <c:url var="noAnimationsUrl" value="/assets/css/no-animations.css" />
            <link rel="stylesheet" href="${noAnimationsUrl}" />
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
                            <!-- TODAY SALE CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-blue">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-calendar-day stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Today Sale</h6>
                                        <h2 class="stat-value"><span id="todaySaleAmount">0</span></h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-success">
                                                <i class="fas fa-calendar-check"></i> Today's transactions
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /TODAY SALE CARD -->

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

                            <!-- TOTAL SALE (MONTHLY) CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-red">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-chart-line stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Total Sale</h6>
                                        <h2 class="stat-value"><span id="monthlySaleAmount">0</span></h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-danger">
                                                <i class="fas fa-calendar-alt"></i> This month
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /TOTAL REVENUE CARD -->
                        </div>

                        <!-- Second Row of Cards -->
                        <div class="row">
                            <!-- YEARLY SALE CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-purple">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-calendar-alt stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Yearly Sale</h6>
                                        <h2 class="stat-value"><span id="yearlySaleAmount">0</span></h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-primary">
                                                <i class="fas fa-calendar-check"></i> This year
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /YEARLY SALE CARD -->

                            <!-- PENDING PAYMENT AMOUNT CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-warning">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-rupee-sign stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Pending Payment</h6>
                                        <h2 class="stat-value"><span id="pendingPaymentsAmount">0</span></h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-warning">
                                                <i class="fas fa-exclamation-circle"></i> <span id="pendingPaymentsCount">0</span> transactions
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /PENDING PAYMENT AMOUNT CARD -->

                            <!-- PENDING PAYMENT COUNT CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-info">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-hourglass-half stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Pending Payment Count</h6>
                                        <h2 class="stat-value" id="pendingCount">0</h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-info">
                                                <i class="fas fa-list"></i> Total pending
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /PENDING PAYMENT COUNT CARD -->

                            <!-- PAYMENT METHODS CARD -->
                            <div class="col-md-3 mb-4">
                                <div class="stat-card stat-card-teal">
                                    <div class="stat-icon-wrapper">
                                        <i class="fas fa-credit-card stat-icon"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h6 class="stat-label">Payment Methods</h6>
                                        <div style="margin-top: 10px;">
                                            <canvas id="paymentMethodChart" style="max-height: 120px;"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /PAYMENT METHODS CARD -->
                        </div>

                        <!-- Charts Row -->
                        <div class="row mt-4">
                            <div class="col-md-6 mb-4">
                                <div class="chart-container">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0"><i class="fas fa-chart-line me-2 text-gradient"></i>Sales Trend</h5>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <a href="DashboardServlet?trend=day" class="btn ${trendType == 'day' ? 'btn-success' : 'btn-outline-success'}">Day</a>
                                            <a href="DashboardServlet?trend=month" class="btn ${trendType == 'month' ? 'btn-success' : 'btn-outline-success'}">Month</a>
                                            <a href="DashboardServlet?trend=year" class="btn ${trendType == 'year' ? 'btn-success' : 'btn-outline-success'}">Year</a>
                                        </div>
                                    </div>
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
                                                <a href="NotificationServlet" class="btn btn-outline-warning w-100">
                                                    <i class="fas fa-bell me-2"></i>View Notifications
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
                    // INIT DASHBOARD CHARTS
                    document.addEventListener('DOMContentLoaded', function () {
                        const todaySaleAmountVal = Number('${todaySaleAmount}') || 0;
                        const monthlySaleAmountVal = Number('${monthlySaleAmount}') || 0;
                        const yearlySaleAmountVal = Number('${yearlySaleAmount}') || 0;
                        const pendingPaymentsAmountVal = Number('${pendingPaymentsAmount}') || 0;
                        const pendingPaymentsCountVal = Number('${pendingPaymentsCount}') || 0;
                        const productCountVal = Number('${productCount}') || 0;
                        const distributorCountVal = Number('${distributorCount}') || 0;
                        const hasChartJs = typeof Chart !== 'undefined';

                        // PARSE SALES TREND DATA FROM SERVER
                        let salesTrendData = {};
                        try {
                            const salesDataStr = '<c:out value="${salesTrendData}" escapeXml="false"/>';
                            console.log('Raw sales data:', salesDataStr);
                            if (salesDataStr && salesDataStr !== '' && salesDataStr !== 'null') {
                                salesTrendData = JSON.parse(salesDataStr);
                            }
                        } catch (e) {
                            console.error('Error parsing sales trend data:', e);
                        }

                        // PARSE CATEGORY DATA FROM SERVER
                        let categoryData = {};
                        try {
                            const categoryDataStr = '<c:out value="${categoryData}" escapeXml="false"/>';
                            console.log('Raw category data:', categoryDataStr);
                            if (categoryDataStr && categoryDataStr !== '' && categoryDataStr !== 'null') {
                                categoryData = JSON.parse(categoryDataStr);
                            }
                        } catch (e) {
                            console.error('Error parsing category data:', e);
                        }

                        // PARSE PAYMENT METHOD DATA FROM SERVER
                        let paymentMethodData = {};
                        try {
                            const paymentDataStr = '<c:out value="${paymentMethodData}" escapeXml="false"/>';
                            console.log('Raw payment method data:', paymentDataStr);
                            if (paymentDataStr && paymentDataStr !== '' && paymentDataStr !== 'null') {
                                paymentMethodData = JSON.parse(paymentDataStr);
                            }
                        } catch (e) {
                            console.error('Error parsing payment method data:', e);
                        }

                        console.log('Parsed sales trend data:', salesTrendData);
                        console.log('Parsed category data:', categoryData);

                        // PREPARE SALES CHART DATA
                        const salesLabels = Object.keys(salesTrendData);
                        const salesValues = Object.values(salesTrendData);
                        
                        // SALES CHART
                        const salesCtx = document.getElementById('salesChart');
                        if (hasChartJs && salesCtx) {
                            new Chart(salesCtx, {
                                type: 'line',
                                data: {
                                    labels: salesLabels.length > 0 ? salesLabels : ['No Data'],
                                    datasets: [{
                                        label: 'Sales Amount ()',
                                        data: salesValues.length > 0 ? salesValues : [0],
                                        borderColor: '#4caf50',
                                        backgroundColor: 'rgba(76, 175, 80, 0.1)',
                                        tension: 0.4,
                                        fill: true,
                                        borderWidth: 2,
                                        pointRadius: 4,
                                        pointBackgroundColor: '#4caf50',
                                        pointHoverRadius: 6
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: true,
                                    plugins: {
                                        legend: {
                                            display: true,
                                            position: 'top'
                                        },
                                        tooltip: {
                                            callbacks: {
                                                label: function(context) {
                                                    return 'Amount: ' + context.parsed.y.toFixed(2);
                                                }
                                            }
                                        }
                                    },
                                    scales: {
                                        y: {
                                            beginAtZero: true,
                                            ticks: {
                                                callback: function(value) {
                                                    return value;
                                                }
                                            }
                                        }
                                    }
                                }
                            });
                        }

                        // PREPARE PRODUCT CATEGORY DATA
                        const categoryLabels = Object.keys(categoryData);
                        const categoryValues = Object.values(categoryData);
                        const categoryColors = [
                            '#4caf50', '#2196f3', '#ff9800', '#f44336', '#9c27b0',
                            '#00bcd4', '#ffeb3b', '#795548', '#607d8b', '#e91e63'
                        ];

                        // PRODUCT CHART
                        const productCtx = document.getElementById('productChart');
                        if (hasChartJs && productCtx) {
                            new Chart(productCtx, {
                                type: 'doughnut',
                                data: {
                                    labels: categoryLabels.length > 0 ? categoryLabels : ['No Data'],
                                    datasets: [{
                                        data: categoryValues.length > 0 ? categoryValues : [1],
                                        backgroundColor: categoryLabels.length > 0 ? categoryColors.slice(0, categoryLabels.length) : ['#cccccc'],
                                        borderWidth: 2,
                                        borderColor: '#fff'
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: true,
                                    plugins: {
                                        legend: {
                                            position: 'bottom',
                                            labels: {
                                                padding: 15,
                                                font: {
                                                    size: 12
                                                }
                                            }
                                        },
                                        tooltip: {
                                            callbacks: {
                                                label: function(context) {
                                                    const label = context.label || '';
                                                    const value = context.parsed || 0;
                                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                                    const percentage = ((value / total) * 100).toFixed(1);
                                                    return label + ': ' + value + ' (' + percentage + '%)';
                                                }
                                            }
                                        }
                                    }
                                }
                            });
                        }

                        // PREPARE PAYMENT METHOD DATA
                        const paymentLabels = Object.keys(paymentMethodData);
                        const paymentValues = Object.values(paymentMethodData);
                        const paymentColors = ['#4caf50', '#2196f3', '#ff9800', '#f44336', '#9c27b0'];

                        // PAYMENT METHOD CHART
                        const paymentCtx = document.getElementById('paymentMethodChart');
                        if (hasChartJs && paymentCtx) {
                            new Chart(paymentCtx, {
                                type: 'pie',
                                data: {
                                    labels: paymentLabels.length > 0 ? paymentLabels : ['No Data'],
                                    datasets: [{
                                        data: paymentValues.length > 0 ? paymentValues : [1],
                                        backgroundColor: paymentLabels.length > 0 ? paymentColors.slice(0, paymentLabels.length) : ['#cccccc'],
                                        borderWidth: 2,
                                        borderColor: '#fff'
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: true,
                                    plugins: {
                                        legend: {
                                            position: 'bottom',
                                            labels: {
                                                padding: 10,
                                                font: {
                                                    size: 11
                                                }
                                            }
                                        },
                                        tooltip: {
                                            callbacks: {
                                                label: function(context) {
                                                    const label = context.label || '';
                                                    const value = context.parsed || 0;
                                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                                    const percentage = ((value / total) * 100).toFixed(1);
                                                    return label + ': ' + value + ' (' + percentage + '%)';
                                                }
                                            }
                                        }
                                    }
                                }
                            });
                        }

                        // ANIMATE COUNTERS
                        animateValue('todaySaleAmount', 0, todaySaleAmountVal, 800);
                        animateValue('monthlySaleAmount', 0, monthlySaleAmountVal, 1000);
                        animateValue('yearlySaleAmount', 0, yearlySaleAmountVal, 1000);
                        animateValue('pendingPaymentsAmount', 0, pendingPaymentsAmountVal, 1000);
                        animateValue('pendingPaymentsCount', 0, pendingPaymentsCountVal, 800);
                        animateValue('pendingCount', 0, pendingPaymentsCountVal, 800);
                        animateValue('countProduct', 0, productCountVal, 1200);
                        animateValue('countDistributor', 0, distributorCountVal, 1200);

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