<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Calculate unread notification count -->
<%
Integer originalNotificationCount = (Integer) request.getAttribute("totalNotifications");
if (session.getAttribute("userId") != null) {
    Integer userIdObj = (Integer) session.getAttribute("userId");
    int userId = userIdObj.intValue(); // Convert Integer to int
    try {
        com.inventory.dao.UserNotificationDAO userNotificationDAO = new com.inventory.dao.UserNotificationDAO();
        int unreadCount = userNotificationDAO.getUnreadNotificationCount(userId);
        request.setAttribute("totalNotifications", unreadCount);
    } catch (Exception e) {
        // Fallback to original count if calculation fails
        if (originalNotificationCount != null) {
            request.setAttribute("totalNotifications", originalNotificationCount);
        }
    }
}
%>

<!-- SIDEBAR -->
<c:url var="defaultLogoUrl" value="/assets/images/logo-modern.svg" />
<c:url var="logoutUrl" value="/LogoutServlet" />
<c:url var="userLogoUrl" value="/${sessionScope.medicalStoreLogo}" />
<c:set var="logoUrl" value="${not empty sessionScope.medicalStoreLogo ? userLogoUrl : defaultLogoUrl}" />

<aside id="sidebar" class="d-flex flex-column flex-shrink-0 p-3">
    <b>
        <a href="DashboardServlet"
           class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-decoration-none text-dark">
            <img src="${logoUrl}" alt="Logo" width="40" height="40" 
                 style="border-radius: 8px; object-fit: cover;"
                 onerror="this.onerror=null; this.src='${defaultLogoUrl}';">
            <span class="fs-6 ms-2">
                <c:out value="${sessionScope.medicalStoreName != null ? sessionScope.medicalStoreName : 'Medical Store'}"/>
            </span>
        </a>
    </b>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="DashboardServlet"
               class="nav-link ${param.activePage == 'dashboard' ? 'active' : ''}"
               aria-current="${param.activePage == 'dashboard' ? 'page' : ''}">
                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
            </a>
        </li>
        
        <li>
            <a href="ProductServlet"
               class="nav-link ${param.activePage == 'product' ? 'active' : ''}"
               aria-current="${param.activePage == 'product' ? 'page' : ''}">
                <i class="fas fa-pills me-2"></i> Product
            </a>
        </li>
        <li>
            <a href="DistributorServlet"
               class="nav-link ${param.activePage == 'distributor' ? 'active' : ''}"
               aria-current="${param.activePage == 'distributor' ? 'page' : ''}">
                <i class="fas fa-truck me-2"></i> Distributor
            </a>
        </li>
        <li>
            <a href="CustomerServlet"
               class="nav-link ${param.activePage == 'customer' ? 'active' : ''}"
               aria-current="${param.activePage == 'customer' ? 'page' : ''}">
                <i class="fas fa-users me-2"></i> Customers
            </a>
        </li>
        <li>
            <a href="SaleServlet"
               class="nav-link ${param.activePage == 'sale' ? 'active' : ''}"
               aria-current="${param.activePage == 'sale' ? 'page' : ''}">
                <i class="fas fa-file-invoice-dollar me-2"></i> Sales
            </a>
        </li>
        
        <li>
            <a href="ImportExportServlet"
               class="nav-link ${param.activePage == 'import-export' ? 'active' : ''}"
               aria-current="${param.activePage == 'import-export' ? 'page' : ''}">
                <i class="fas fa-file-csv me-2"></i> Import CSV Data
            </a>
        </li>
        <li>
            <a href="ProfileServlet" class="nav-link ${param.activePage == 'profile' ? 'active' : ''}" aria-current="${param.activePage == 'profile' ? 'page' : ''}">
            <a href="NotificationServlet" class="nav-link ${param.activePage == 'notifications' ? 'active' : ''}" aria-current="${param.activePage == 'notifications' ? 'page' : ''}">
                <i class="fas fa-bell me-2"></i> Notifications
                <c:if test="${totalNotifications > 0}">
                    <span class="badge bg-danger ms-1">${totalNotifications}</span>
                </c:if>
            </a>
        </li>
        <li>
            <a href="#" class="nav-link ${param.activePage == 'profile' ? 'active' : ''}" aria-current="${param.activePage == 'profile' ? 'page' : ''}">
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