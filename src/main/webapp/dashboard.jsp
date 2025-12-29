<%@ page contentType="text/html;charset=UTF-8" %>
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
            <c:url var="chartJsLocal" value="/assets/js/chart.umd.min.js" />
            <c:url var="bootstrapJs" value="/assets/js/bootstrap.bundle.min.js" />
            <c:url var="appJs" value="/assets/js/app.js" />
            <c:url var="interRegular" value="/assets/fonts/inter/Inter-Regular.woff2" />
            <link rel="stylesheet" href="${bootstrapCss}" />
            <link rel="stylesheet" href="${fontAwesomeCss}" />
            <link rel="stylesheet" href="${themeCss}" />
            <link rel="preload" href="${interRegular}" as="font" type="font/woff2" crossorigin>
            <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"
                crossorigin="anonymous"></script>
            <script src="${chartJsLocal}"></script>

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
                                        <h2 class="stat-value"><span id="todaySaleAmount" data-value="${todaySaleAmount}"><fmt:formatNumber value="${todaySaleAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span></h2>
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
                                        <h2 class="stat-value" id="countProduct" data-value="${productCount}">${productCount}</h2>
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
                                        <h2 class="stat-value" id="countDistributor" data-value="${distributorCount}">${distributorCount}</h2>
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
                                        <h2 class="stat-value"><span id="monthlySaleAmount" data-value="${monthlySaleAmount}"><fmt:formatNumber value="${monthlySaleAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span></h2>
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
                                        <h2 class="stat-value"><span id="yearlySaleAmount" data-value="${yearlySaleAmount}"><fmt:formatNumber value="${yearlySaleAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span></h2>
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
                                        <h2 class="stat-value"><span id="pendingPaymentsAmount" data-value="${pendingPaymentsAmount}"><fmt:formatNumber value="${pendingPaymentsAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span></h2>
                                        <div class="stat-trend">
                                            <span class="badge badge-warning">
                                                <i class="fas fa-exclamation-circle"></i> <span id="pendingPaymentsCount" data-value="${pendingPaymentsCount}">${pendingPaymentsCount}</span> transactions
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
                                        <h2 class="stat-value" id="pendingCount" data-value="${pendingPaymentsCount}">${pendingPaymentsCount}</h2>
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
                                            <canvas id="paymentMethodChart" style="max-height: 120px;" height="140"></canvas>
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
                                            <button type="button" class="btn btn-outline-danger" onclick="exportDashboardPdf('sales', '${trendType}')"><i class="fas fa-file-pdf"></i> PDF</button>
                                            <button type="button" class="btn ${trendType == 'day' ? 'btn-success' : 'btn-outline-success'}" data-trend="day" onclick="event.preventDefault(); changeTrend('day');">Day</button>
                                            <button type="button" class="btn ${trendType == 'month' ? 'btn-success' : 'btn-outline-success'}" data-trend="month" onclick="event.preventDefault(); changeTrend('month');">Month</button>
                                            <button type="button" class="btn ${trendType == 'year' ? 'btn-success' : 'btn-outline-success'}" data-trend="year" onclick="event.preventDefault(); changeTrend('year');">Year</button>
                                        </div>
                                    </div>
                                    <canvas id="salesChart" style="max-height: 300px;"></canvas>
                                </div>
                            </div>

                            <div class="col-md-6 mb-4">
                                <div class="chart-container">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0"><i class="fas fa-chart-pie me-2 text-gradient"></i>Product Categories</h5>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-outline-danger" onclick="exportDashboardPdf('categories')"><i class="fas fa-file-pdf"></i> PDF</button>
                                        </div>
                                    </div>
                                    <canvas id="productChart" style="max-height: 300px;" height="320"></canvas>
                                    <div id="categorySummary" class="mt-3 small text-muted" style="display:none;"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Raw JSON data for charts -->
                        <script id="salesDataJson" type="application/json"><c:out value="${salesTrendData}" escapeXml="false"/></script>
                        <script id="categoryDataJson" type="application/json"><c:out value="${categoryData}" escapeXml="false"/></script>
                        <script id="paymentDataJson" type="application/json"><c:out value="${paymentMethodData}" escapeXml="false"/></script>

                        <!-- Quick Actions -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <h5 class="mb-0"><i class="fas fa-bolt me-2 text-gradient"></i>Quick Actions</h5>
                                            <button type="button" class="btn btn-danger btn-sm" onclick="exportDashboardPdf('full')">
                                                <i class="fas fa-file-pdf me-1"></i>Export Full Report
                                            </button>
                                        </div>
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
                    // GLOBAL VARIABLES
                    let salesChart = null;
                    let productChart = null;
                    let currentTrend = '${trendType}';

                    // INIT DASHBOARD CHARTS
                    document.addEventListener('DOMContentLoaded', function () {
                        const readValue = (id) => {
                            const el = document.getElementById(id);
                            if (!el) return 0;
                            const raw = el.getAttribute('data-value') ?? el.textContent;
                            const parsed = Number(raw);
                            return isNaN(parsed) ? 0 : parsed;
                        };

                        const todaySaleAmountVal = readValue('todaySaleAmount');
                        const monthlySaleAmountVal = readValue('monthlySaleAmount');
                        const yearlySaleAmountVal = readValue('yearlySaleAmount');
                        const pendingPaymentsAmountVal = readValue('pendingPaymentsAmount');
                        const pendingPaymentsCountVal = readValue('pendingPaymentsCount');
                        const productCountVal = readValue('countProduct');
                        const distributorCountVal = readValue('countDistributor');
                        const hasChartJs = typeof Chart !== 'undefined';

                        const parseJsonFromScript = (id) => {
                            const el = document.getElementById(id);
                            if (!el) return {};
                            const raw = (el.textContent || '').trim();
                            if (!raw || raw === 'null') return {};
                            try { return JSON.parse(raw); } catch (e) { console.error('JSON parse error', id, e); return {}; }
                        };

                        const salesTrendData = parseJsonFromScript('salesDataJson');
                        const categoryData = parseJsonFromScript('categoryDataJson');
                        const paymentMethodData = parseJsonFromScript('paymentDataJson');

                        const buildChartDataset = (rawObj) => {
                            const entries = Object.entries(rawObj || {})
                                .map(([k, v]) => [typeof k === 'string' ? k.trim() : '', Number(v)])
                                .filter(([k, v]) => k !== '' && !Number.isNaN(v) && v > 0);
                            return {
                                labels: entries.map(e => e[0]),
                                values: entries.map(e => e[1])
                            };
                        };

                        console.log('Parsed sales trend data:', salesTrendData);
                        console.log('Parsed category data:', categoryData);

                        // PREPARE SALES CHART DATA
                        const salesLabels = Object.keys(salesTrendData || {});
                        const salesValues = Object.values(salesTrendData || {});
                        
                        console.log('Sales Labels:', salesLabels);
                        console.log('Sales Values:', salesValues);
                        
                        // SALES CHART
                        const salesCtx = document.getElementById('salesChart');
                        if (hasChartJs && salesCtx) {
                            // Check if we have actual sales data
                            const hasData = salesLabels.length > 0 && salesValues.some(v => v > 0);
                            
                            salesChart = new Chart(salesCtx, {
                                type: 'line',
                                data: {
                                    labels: hasData ? salesLabels : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                                    datasets: [{
                                        label: 'Sales Amount (₹)',
                                        data: hasData ? salesValues : [0, 0, 0, 0, 0, 0, 0],
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
                        const { labels: categoryLabels, values: categoryValues } = buildChartDataset(categoryData);
                        const categoryColors = [
                            '#4caf50', '#2196f3', '#ff9800', '#f44336', '#9c27b0',
                            '#00bcd4', '#ffeb3b', '#795548', '#607d8b', '#e91e63'
                        ];

                        const renderCategorySummary = () => {
                            const summaryEl = document.getElementById('categorySummary');
                            if (summaryEl) {
                                summaryEl.style.display = 'none';
                                summaryEl.textContent = '';
                            }
                        };

                        // PRODUCT CHART
                        const productCtx = document.getElementById('productChart');
                        const categoryTotal = categoryValues.reduce((a, b) => a + b, 0);

                        if (!categoryLabels.length || categoryTotal === 0) {
                            renderCategorySummary([], []);
                            if (productCtx) {
                                productCtx.style.display = 'none';
                            }
                        } else if (hasChartJs && productCtx) {
                            productChart = new Chart(productCtx, {
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
                                                font: { size: 12 }
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
                            renderCategorySummary(categoryLabels, categoryValues);
                        }

                        // PREPARE PAYMENT METHOD DATA
                        const { labels: paymentLabels, values: paymentValues } = buildChartDataset(paymentMethodData);
                        const paymentColors = ['#4caf50', '#2196f3', '#ff9800', '#f44336', '#9c27b0'];
                        const paymentSummaryEl = document.createElement('div');
                        paymentSummaryEl.className = 'mt-2 small text-muted';
                        const paymentCard = document.getElementById('paymentMethodChart')?.parentElement;
                        if (paymentCard) {
                            paymentCard.appendChild(paymentSummaryEl);
                        }

                        // PAYMENT METHOD CHART
                        const paymentCtx = document.getElementById('paymentMethodChart');
                        if (!paymentLabels.length || paymentValues.reduce((a, b) => a + b, 0) === 0) {
                            if (paymentSummaryEl) paymentSummaryEl.textContent = 'No payment data yet.';
                            if (paymentCtx) paymentCtx.style.display = 'none';
                        } else if (hasChartJs && paymentCtx) {
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

                        if (paymentSummaryEl) {
                            const totalPay = paymentValues.reduce((a, b) => a + b, 0);
                            if (!paymentLabels.length || totalPay === 0) {
                                paymentSummaryEl.textContent = 'No payment data yet.';
                            } else {
                                paymentSummaryEl.textContent = '';
                            }
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

                    // CHANGE TREND FUNCTION (AJAX)
                    function changeTrend(trend) {
                        if (currentTrend === trend) return;
                        currentTrend = trend;

                        // Update button states
                        document.querySelectorAll('[data-trend]').forEach(btn => {
                            if (btn.getAttribute('data-trend') === trend) {
                                btn.classList.remove('btn-outline-success');
                                btn.classList.add('btn-success');
                            } else {
                                btn.classList.remove('btn-success');
                                btn.classList.add('btn-outline-success');
                            }
                        });

                        // Fetch new data via AJAX
                        fetch('DashboardServlet?trend=' + trend + '&ajax=true')
                            .then(response => response.json())
                            .then(data => {
                                updateSalesChart(data);
                            })
                            .catch(error => console.error('Error fetching trend data:', error));
                    }

                    function updateSalesChart(data) {
                        if (salesChart && data.labels && data.values) {
                            salesChart.data.labels = data.labels;
                            salesChart.data.datasets[0].data = data.values;
                            salesChart.update();
                        }
                    }

                    // EXPORT DASHBOARD AS PDF
                    function exportDashboardPdf(type, trend) {
                        let url = 'ExportDashboardPdfServlet?type=' + type;
                        if (trend) {
                            url += '&trend=' + trend;
                        } else if (type === 'sales') {
                            url += '&trend=' + currentTrend;
                        }
                        window.location.href = url;
                    }

                    // EXPORT CHART AS PNG (kept for backward compatibility if needed)
                    function exportChart(canvasId, fileName) {
                        const canvas = document.getElementById(canvasId);
                        if (!canvas || typeof canvas.toDataURL !== 'function') {
                            alert('Chart not ready to export.');
                            return;
                        }

                        const link = document.createElement('a');
                        link.href = canvas.toDataURL('image/png');
                        link.download = fileName || 'chart.png';
                        link.click();
                    }

                    function animateValue(id, start, end, duration, prefix = '') {
                        const obj = document.getElementById(id);
                        if (!obj) return;

                        const range = end - start;
                        const increment = range / (duration / 16);
                        let current = start;
                        const isIntegerTarget = Number.isInteger(end);

                        const timer = setInterval(() => {
                            current += increment;
                            if (current >= end) {
                                obj.textContent = prefix + (isIntegerTarget ? Math.round(end) : end.toFixed(2));
                                clearInterval(timer);
                            } else {
                                obj.textContent = prefix + (isIntegerTarget ? Math.round(current) : current.toFixed(2));
                            }
                        }, 16);
                    }
                </script>
                <script src="${bootstrapJs}"></script>
            </div>
        </body>

        </html>