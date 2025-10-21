
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>We hit a snag</title>
    <c:url var="bootstrapCss" value="/assets/css/bootstrap.min.css" />
    <c:url var="fontAwesomeCss" value="/assets/css/fontawesome.min.css" />
    <c:url var="themeCss" value="/assets/css/theme.css" />
    <c:url var="styleCss" value="/assets/css/style.css" />
    <c:url var="interRegular" value="/assets/fonts/inter/Inter-Regular.woff2" />
    <c:url var="faviconUrl" value="/assets/images/favicon.svg" />
    <link rel="icon" href="${faviconUrl}" type="image/svg+xml">
    <link rel="stylesheet" href="${bootstrapCss}">
    <link rel="stylesheet" href="${fontAwesomeCss}">
    <link rel="stylesheet" href="${themeCss}">
    <link rel="stylesheet" href="${styleCss}">
    <link rel="preload" href="${interRegular}" as="font" type="font/woff2" crossorigin>
</head>

<body class="error-page">
    <section class="error-panel glass-panel">
        <div class="error-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <h1 class="error-title">Something went wrong</h1>
        <p class="error-message">We couldn't complete your request. The team has been notified and we're on it.</p>
        <div class="error-actions">
            <a href="DashboardServlet" class="btn btn-success me-2">Back to Dashboard</a>
            <a href="index.jsp" class="btn btn-outline-success">Return to Login</a>
        </div>
    </section>
</body>

</html>
