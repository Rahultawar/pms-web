<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Login link routes back to the local username/password form -->
<c:url var="loginUrl" value="/index.jsp"/>
<a href="${loginUrl}" class="nav-link">Sign in</a>

<!-- Logout form (POST) -->
<c:url var="logoutUrl" value="/LogoutServlet"/>
<li>
  <form method="post" action="${logoutUrl}" style="margin:0;">
    <button type="submit" class="dropdown-item">Log out</button>
  </form>
</li>