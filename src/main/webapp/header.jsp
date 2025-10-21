<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- login link: goes to local servlet that sets state and redirects -->
<c:url var="loginUrl" value="/cognitoLogin"/>
<a href="${loginUrl}" class="nav-link">Sign in</a>

<!-- Logout form (POST) -->
<c:url var="logoutUrl" value="/LogoutServlet"/>
<li>
  <form method="post" action="${logoutUrl}" style="margin:0;">
    <button type="submit" class="dropdown-item">Log out</button>
  </form>
</li>