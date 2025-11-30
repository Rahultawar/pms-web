<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>Error | Pharmacy Management System</title>

    <c:url var="bootstrapCss" value="/assets/css/bootstrap.min.css"/>
    <c:url var="fontAwesomeCss" value="/assets/css/fontawesome.min.css"/>
    <c:url var="interRegular" value="/assets/fonts/inter/Inter-Regular.woff2"/>
    <c:url var="errorBg" value="/assets/images/error_page_bg.png"/>

    <link rel="stylesheet" href="${bootstrapCss}">
    <link rel="stylesheet" href="${fontAwesomeCss}">
    <link rel="preload" href="${interRegular}" as="font" type="font/woff2" crossorigin>

    <style>
        :root {
            --brand-green: #2f7a3f;
            --muted: #566057;
            --bg: #f7fff7;
        }

        html, body {
            height: 100%;
            margin: 0
        }

        body {
            font-family: "Inter", system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
            background: url('${errorBg}') center/cover no-repeat fixed;
            backdrop-filter: blur(0px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px;
        }

        .error-view {
            width: 100%;
            max-width: 980px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 36px;
            padding: 18px;
        }

        .error-code {
            font-size: clamp(48px, 9vw, 120px);
            font-weight: 800;
            color: var(--brand-green);
            line-height: 1;
            letter-spacing: -6px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 120px;
        }

        .error-text {
            max-width: 320px;
            text-align: left;
        }

        .error-title {
            font-size: clamp(20px, 3.6vw, 28px);
            color: #1f2b22;
            font-weight: 700;
            margin: 6px 0 8px;
        }

        .error-sub {
            color: var(--muted);
            margin: 0 0 14px;
            font-size: 15px;
            line-height: 1.45;
        }

        .error-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-outline {
            border: 1px solid rgba(47, 122, 63, 0.12);
            color: var(--brand-green);
            background: transparent;
            padding: 9px 16px;
            border-radius: 999px;
            font-weight: 600;
            text-decoration: none;
        }

        .btn-outline:hover {
            background-color: green;
            color: white;
        }

        @media (max-width: 880px) {
            .error-view {
                flex-direction: column-reverse;
                gap: 18px;
                align-items: center;
            }

            .error-text {
                max-width: 640px;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<%
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");

    String code = (statusCode != null) ? statusCode.toString() : "ERR";
    String title = "Unexpected Error";

    if (statusCode != null && statusCode == 404) {
        title = "Page Not Found";
    } else if (throwable instanceof java.sql.SQLException) {
        title = "Database Error";
    } else if (throwable != null) {
        title = throwable.getClass().getSimpleName();
    }
%>

<div class="error-view" role="main" aria-labelledby="err-code">
    <%-- STATUS CODE--%>
    <div class="error-code"><%= code %>
    </div>

    <div class="error-text">
        <div style="font-size:14px;color:var(--muted);font-weight:600">Error</div>
        <div class="error-title"><%= title %>
        </div>
        <div class="error-sub">We encountered an issue while processing your request.</div>

        <%-- REDIRECT LOGIN PAGE BUTTON--%>
        <div class="error-actions">
            <a class="btn-outline" href="index.jsp">Return to Login</a>
        </div>
    </div>
</div>

</body>
</html>
